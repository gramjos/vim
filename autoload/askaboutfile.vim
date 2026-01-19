vim9script
# ==============================================================================
# askaboutfile.vim - Gemini AI Integration for Vim
# ==============================================================================
# This autoload plugin provides functions to query Google's Gemini AI about:
#   1. The current file's contents
#   2. A visual selection
#   3. Multiple files selected via fzf
#
# The responses are streamed in real-time to a scratch buffer, providing
# a live, interactive experience similar to modern AI chat interfaces.
#
# Architecture Overview:
#   - API key is read from a local file for security (not hardcoded)
#   - Requests use Server-Sent Events (SSE) for streaming responses
#   - A shell pipeline (curl | awk | jq) processes the stream
#   - Vim's job_start() with raw output mode handles async I/O
# ==============================================================================

# ------------------------------------------------------------------------------
# Function: GetApiKey
# ------------------------------------------------------------------------------
# Purpose:
#   Retrieves the Gemini API key from a secure local file.
#
# Returns:
#   string - The API key if successful, or an empty string on failure.
#
# Security Note:
#   The API key is stored in a separate file (~/.config/gemini_key_4_vim/g.key)
#   rather than being hardcoded, preventing accidental exposure in version
#   control or when sharing dotfiles.
# ------------------------------------------------------------------------------
def GetApiKey(): string
    # Define the path to the API key file using ~ for home directory portability
    var key_file = expand('~/.config/gemini_key_4_vim/g.key')

    # filereadable() returns 1 if file exists and is readable, 0 otherwise
    if !filereadable(key_file)
        # echoerr displays error message and adds to :messages history
        # Using string interpolation ($"...") for cleaner variable embedding
        echoerr $"Error: API key file not found at {key_file}"
        return ""
    endif

    # readfile() returns a List of lines; we take the first line [0]
    # trim() removes leading/trailing whitespace (including trailing newline)
    # The ->method() syntax is Vim9's method-call chaining (like piping)
    return readfile(key_file)[0]->trim()
enddef

# ------------------------------------------------------------------------------
# Function: HandleStream
# ------------------------------------------------------------------------------
# Purpose:
#   Callback function invoked by Vim's job system each time new data arrives
#   from the streaming API response. Appends the streamed text to the output
#   buffer while correctly handling embedded newlines.
#
# Parameters:
#   channel: channel     - The Vim channel object (required by callback signature,
#                          but not used directly in this function)
#   msg: string          - The raw text chunk received from the stream. May contain
#                          zero, one, or multiple newline characters.
#   output_bufnr: number - Buffer number of the scratch buffer where output is
#                          displayed. Captured via closure from StreamResponse().
#
# Algorithm:
#   1. Split incoming message on newlines, preserving empty segments
#   2. Append first segment to the current (last) line (continues partial line)
#   3. Add any remaining segments as new lines
#
# Why this approach:
#   Streaming data arrives in arbitrary chunks that don't align with line
#   boundaries. A message might be "Hello\nWorld" or "Hel" followed by "lo\n".
#   By always appending the first part to the last line, we handle both cases.
# ------------------------------------------------------------------------------
def HandleStream(channel: channel, msg: string, output_bufnr: number)
    # Guard clause: skip processing if message is empty
    # This can happen with keep-alive signals or empty SSE events
    if empty(msg)
        return
    endif

    # split(string, pattern, keepempty) splits the string on the pattern
    # The third argument (v:true) is critical: it keeps empty strings in the
    # result when there are consecutive delimiters or leading/trailing delimiters
    # Example: "a\n\nb" -> ["a", "", "b"] with v:true, ["a", "b"] without
    # This preserves intentional blank lines in the AI response
    var parts = split(msg, '\n', v:true)

    # getbufline(bufnr, lnum) returns a List of lines; '$' means last line
    # We get the current last line so we can append the first chunk to it
    # (the stream might have been mid-word when the last chunk ended)
    var last_line = getbufline(output_bufnr, '$')[0]

    # setbufline(bufnr, lnum, text) replaces line lnum with text
    # We concatenate (..) the existing last line with the first part of new data
    # This "completes" any partial line from the previous chunk
    setbufline(output_bufnr, '$', last_line .. parts[0])

    # If there were newlines in the message, we have additional parts to add
    # parts[1 :] is Vim9 slice syntax: from index 1 to end (note required spaces)
    # appendbufline(bufnr, lnum, list) inserts lines AFTER line lnum
    # '$' means after the last line, effectively adding to the end
    if len(parts) > 1
        appendbufline(output_bufnr, '$', parts[1 :])
    endif
enddef

# ------------------------------------------------------------------------------
# Function: StreamResponse
# ------------------------------------------------------------------------------
# Purpose:
#   Core function that sends a prompt to the Gemini API and streams the
#   response into a new scratch buffer in real-time.
#
# Parameters:
#   context_text: string  - The content to analyze (file contents, selection, etc.)
#   user_question: string - The user's question about the context
#
# Technical Flow:
#   1. Retrieve API key
#   2. Create a scratch buffer for output display
#   3. Construct the JSON payload with the combined prompt
#   4. Build a shell pipeline: curl (HTTP) -> awk (SSE parsing) -> jq (JSON extraction)
#   5. Start an async job with the pipeline
#   6. Send the JSON payload to the job's stdin
#   7. As data streams in, HandleStream() updates the buffer
#   8. On completion, append a "[Done]" marker
#
# Why a shell pipeline instead of pure Vimscript:
#   - curl's -N flag enables unbuffered streaming (critical for SSE)
#   - awk efficiently strips SSE "data: " prefixes line-by-line
#   - jq extracts the text field from each JSON chunk
#   - Vim's job system handles the async I/O without blocking the editor
# ------------------------------------------------------------------------------
def StreamResponse(context_text: string, user_question: string)
    # Retrieve API key; abort if unavailable
    var api_key = GetApiKey()
    # Vim9 allows single-line if statements with | separator
    if empty(api_key) | return | endif

    # --- Create Scratch Buffer ---
    # 'vnew' opens a new vertical split with an empty buffer
    execute 'vnew'

    # Configure buffer as a scratch buffer (non-persistent, special-purpose):
    #   buftype=nofile   - Buffer is not associated with a file
    #   bufhidden=wipe   - Buffer is deleted when hidden (frees memory)
    #   noswapfile       - Don't create a swap file (it's temporary)
    #   filetype=markdown - Enable markdown syntax highlighting for AI responses
    #   wrap             - Wrap long lines for readability
    setlocal buftype=nofile bufhidden=wipe noswapfile filetype=markdown wrap

    # bufnr() with no args returns the buffer number of the current buffer
    # We capture this to pass to HandleStream via closure
    var output_bufnr = bufnr()

    # Initialize buffer with the query as a header
    setline(1, $"# Query: {user_question}")
    append(1, "---")

    # --- Prepare Prompt & API Configuration ---
    # Construct the full prompt by combining context and question
    # The AI will see the context first, then the specific question about it
    var prompt = $"Context:\n{context_text}\n\nQuestion: {user_question}"

    # Build the JSON payload following Gemini API's expected structure
    # Vim9 allows literal dict/list syntax without explicit 'dict' keyword
    var json_payload = { contents: [{ parts: [{ text: prompt }] }] }

    # Construct API URL with:
    #   - streamGenerateContent endpoint for streaming responses
    #   - API key as query parameter
    #   - alt=sse to request Server-Sent Events format
    var api_url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:streamGenerateContent?key={api_key}&alt=sse"

    # --- Construct Shell Pipeline ---
    # The pipeline processes the streaming response in three stages:

    # Stage 1: curl
    #   -N: Disable buffering (crucial for real-time streaming)
    #   -s: Silent mode (no progress meter)
    #   -X POST: HTTP POST method
    #   -H: Set Content-Type header for JSON
    #   -d @-: Read POST body from stdin (we'll send it via ch_sendraw)
    #   shellescape(): Safely escapes the URL for shell execution

    # Stage 2: awk
    #   SSE format sends lines like "data: {...json...}"
    #   This awk command:
    #     - Matches lines starting with "data: "
    #     - Extracts everything after "data: " using substr($0, 7)
    #     - fflush() forces immediate output (prevents buffering)
    var awk_cmd = '/^data: / { print substr($0, 7); fflush() }'

    # Stage 3: jq
    #   --unbuffered: Disable jq's output buffering for real-time output
    #   -j: Join mode - output raw strings WITHOUT adding newlines
    #       (Critical: -r would add newlines between chunks, breaking formatting)
    #   The filter extracts the text from the nested JSON structure:
    #     .candidates[0].content.parts[0].text
    #   "// empty" provides a fallback if the path doesn't exist (prevents errors)
    var pipeline = join([
        'curl -N -s -X POST -H "Content-Type: application/json" -d @- ' .. shellescape(api_url),
        $"awk '{awk_cmd}'",
        'jq --unbuffered -j ".candidates[0].content.parts[0].text // empty"'
    ], ' | ')

    # --- Start Asynchronous Job ---
    # job_start() runs a command asynchronously without blocking Vim
    # We wrap the pipeline in bash -c to enable pipe interpretation
    var job = job_start(['/bin/bash', '-c', pipeline], {
        # 'in_io': 'pipe' - We'll write to the job's stdin via a channel
        'in_io': 'pipe',

        # 'out_mode': 'raw' - Receive output as raw bytes, not line-buffered
        # This is essential: default mode buffers by line, which would break
        # our newline handling since we need to see the actual \n characters
        'out_mode': 'raw',

        # 'out_cb': Callback invoked when stdout data is available
        # We use a lambda to capture output_bufnr in a closure
        # (ch, msg) are the channel and message passed by Vim's job system
        'out_cb': (ch, msg) => HandleStream(ch, msg, output_bufnr),

        # 'exit_cb': Callback invoked when the job terminates
        # (ch, st) are the channel and exit status
        # We append visual markers to indicate completion
        'exit_cb': (ch, st) => appendbufline(output_bufnr, '$', ["", "---", "[Done]"])
    })

    # --- Send Payload to Job's Stdin ---
    # job_getchannel() retrieves the channel associated with the job
    # Channels are Vim's abstraction for inter-process communication
    var ch = job_getchannel(job)

    # ch_sendraw() sends raw bytes to the channel's stdin
    # json_encode() converts the Vim dict to a JSON string
    ch_sendraw(ch, json_encode(json_payload))

    # ch_close_in() closes the stdin side of the channel
    # This signals EOF to curl, telling it we're done sending the request body
    # Without this, curl would wait indefinitely for more input
    ch_close_in(ch)
enddef

# ==============================================================================
# PUBLIC EXPORTED FUNCTIONS
# ==============================================================================
# These functions are the public API of this plugin, called via:
#   :call askaboutfile#AskCurrentFile()
#   :call askaboutfile#AskSelection()
#   :call askaboutfile#AskMultipleFiles()
#
# The 'export' keyword makes them accessible from outside this script.
# ==============================================================================

# ------------------------------------------------------------------------------
# Function: AskCurrentFile (exported)
# ------------------------------------------------------------------------------
# Purpose:
#   Prompts the user for a question and sends the entire current buffer's
#   contents to Gemini for analysis.
#
# Usage:
#   :call askaboutfile#AskCurrentFile()
#   Or map to a key: nnoremap <leader>af :call askaboutfile#AskCurrentFile()<CR>
#
# Workflow:
#   1. Capture all lines of the current buffer
#   2. Prompt user for their question
#   3. Stream the AI response to a new scratch buffer
# ------------------------------------------------------------------------------
export def AskCurrentFile()
    # getline(1, '$') returns a List of all lines from line 1 to end ($)
    # join("\n") concatenates them with newlines to recreate the file content
    var content = getline(1, '$')->join("\n")

    # input() displays a prompt and waits for user input
    # Returns the entered string, or empty string if user presses Esc
    var q = input("Ask about current file: ")

    # Only proceed if user entered a non-empty question
    if !empty(q)
        StreamResponse(content, q)
    endif
enddef

# ------------------------------------------------------------------------------
# Function: AskSelection (exported)
# ------------------------------------------------------------------------------
# Purpose:
#   Prompts the user for a question and sends the last visual selection
#   to Gemini for analysis.
#
# Usage:
#   Select text visually, then:
#   :call askaboutfile#AskSelection()
#   Or map: vnoremap <leader>as :<C-u>call askaboutfile#AskSelection()<CR>
#
# Technical Note:
#   This function uses '< and '> marks which store the start and end
#   positions of the last visual selection. These marks persist after
#   leaving visual mode, allowing this function to be called from normal mode.
# ------------------------------------------------------------------------------
export def AskSelection()
    # getpos() returns [bufnum, lnum, col, off] for a mark
    # '< is the mark at the start of the last visual selection
    # '> is the mark at the end of the last visual selection
    # [1 : 2] slices the list to get just [lnum, col] (indices 1 and 2)
    # Note: Vim9 requires spaces around : in slice syntax
    var [lnum1, col1] = getpos("'<")[1 : 2]
    var [lnum2, col2] = getpos("'>")[1 : 2]

    # getline(start, end) returns a List of lines in the range
    var lines = getline(lnum1, lnum2)

    # Guard: Check if we actually got any lines
    if len(lines) == 0
        echo "No selection found."
        return
    endif

    # Join lines with newlines to create the selection content
    # Note: For character-wise selections, this includes full lines,
    # not just the selected characters. This is a simplification.
    var content = lines->join("\n")

    var q = input("Ask about selection: ")
    if !empty(q)
        StreamResponse(content, q)
    endif
enddef

# ------------------------------------------------------------------------------
# Function: AskMultipleFiles (exported)
# ------------------------------------------------------------------------------
# Purpose:
#   Uses fzf to let the user select multiple files, then sends their
#   combined contents to Gemini for analysis.
#
# Requirements:
#   - fzf.vim plugin must be installed (https://github.com/junegunn/fzf.vim)
#
# Usage:
#   :call askaboutfile#AskMultipleFiles()
#
# Workflow:
#   1. Prompt user for a directory to search (default: cwd)
#   2. Run `find` with exclusions to list files
#   3. Present files in fzf for multi-selection
#   4. Read and combine selected file contents
#   5. Stream the AI response
#
# Special Input Handling:
#   - Empty input (just Enter): Use current working directory
#   - Single dot (.): Use home directory
#   - Any other input: Treat as a path (supports ~, relative, absolute)
# ------------------------------------------------------------------------------
export def AskMultipleFiles()
    # Check if fzf plugin is available
    # exists('*funcname') returns true if the function exists
    if !exists('*fzf#run')
        echoerr "FZF is not installed."
        return
    endif

    # --- Step 1: Determine Search Path ---
    # input(prompt, default, completion) shows a prompt and returns user input
    # Third arg "dir" enables directory name completion with Tab
    var raw_input = input(
		$"Where search from? Currently at {getcwd()} \n(Enter=Here, .=Home, or path): ",
		"",
		"dir"
	)

    # redraw clears the command line area after input
    # Without this, the prompt text would remain visible
    redraw

    var search_path = ""

    if empty(raw_input)
        # CASE: Empty Input -> Use current directory
        # Using "." makes `find` return relative paths, which are cleaner
        # and shorter in the fzf display
        search_path = "."
    elseif raw_input == '.'
        # CASE: Literal "." Input -> Map to Home Directory
        # This is a convenience shortcut (user-requested behavior)
        # expand("~") returns the absolute path to home directory
        search_path = expand("~")
    else
        # CASE: Path Provided -> Normalize it
        # fnamemodify(path, ':p') applies the :p modifier which:
        #   - Expands ~ to home directory
        #   - Converts relative paths to absolute paths
        #   - Resolves . and .. components
        search_path = fnamemodify(raw_input, ':p')
    endif

    # Validate that the path is an actual directory
    # expand() is needed to expand ~ if search_path is "~" literally
    # isdirectory() returns true if path exists and is a directory
    if !isdirectory(expand(search_path))
        echoerr $"Directory not found: {search_path}"
        return
    endif

    # --- Step 2: Define File Exclusions ---
    # These patterns prevent searching in common non-source directories
    # and exclude binary/generated files that wouldn't be useful for AI analysis
    # Each uses `find`'s -not -path or -not -name predicates
    var exclusions = [
        # Version control
        '-not -path "*/.git/*"',
        # Package managers / dependencies
        '-not -path "*/node_modules/*"',
        # Python artifacts
        '-not -path "*/__pycache__/*"',   
        '-not -path "*/.venv/*"',         
        '-not -path "*/venv/*"',
        '-not -path "*/venv*"',
        '-not -path "*/.venv*"',
        '-not -path "*/virtenv/*"',
        # Build outputs
        '-not -path "*/dist/*"',          
        '-not -path "*/build/*"',
        '-not -path "*/target/*"',        # Rust/Java build output
        # IDE directories
        '-not -path "*/.idea/*"',         
        '-not -path "*/.vscode/*"',       
        # Individual file exclusions
        '-not -name ".DS_Store"',         # macOS metadata
        '-not -name "*.svg"',             # Binary/large files
        '-not -name "*.png"',             
        '-not -name "*.jpg"',
        '-not -name "*.pyc"',             # Python bytecode
        '-not -name ".env"',              # Environment files (may contain secrets)
        '-not -name "*.swp"',             # Vim swap files
        '-not -name "*.swo"',
        '-not -name "*.swn"'
    ]

    # Join all exclusion flags with spaces for the find command
    var ignore_flags = join(exclusions, " ")

    # --- Step 3: Run FZF File Picker ---
    # fzf#run() invokes fzf with the given configuration and returns selected items
    # 'source': The shell command that generates the list of candidates
    #           shellescape() handles paths with spaces or special characters
    # 'options': fzf command-line options
    #           --multi: Allow selecting multiple files with Tab
    #           --prompt: Custom prompt text shown in fzf
    var files = fzf#run({
        'source': $"find {shellescape(search_path)} -type f {ignore_flags}",
        'options': '--multi --prompt="Select files > "'
    })

    # fzf#run() returns an empty list if user cancels (Esc) or selects nothing
    if empty(files) | return | endif

    # Prompt for the question about the selected files
    var q = input($"Ask about {len(files)} files: ")
    if empty(q) | return | endif

    # --- Step 4: Combine File Contents ---
    # Build a list containing all file contents with headers
    var combined_content = []
    for f in files
        # Add a header to identify each file's content
        # += appends items to the list (can append list to list)
        # readfile(f) returns List of lines, join("\n") makes it a single string
        combined_content += [$"\n--- File: {f} ---", readfile(f)->join("\n")]
    endfor

    # Join all parts with newlines and send to the AI
    StreamResponse(combined_content->join("\n"), q)
enddef
