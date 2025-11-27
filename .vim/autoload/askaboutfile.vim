vim9script

# https://ai.google.dev/gemini-api/docs/models#model-variations
const AVAILABLE_MODELS = [
    'gemini-2.5-flash-lite',
    'gemini-2.5-flash',
    # 'gemini-2.5-pro',
    # 'gemini-3.0-pro',
]

# 2. The "Global" State Variable
var current_model = AVAILABLE_MODELS[0]

# 3. Global Getter: Returns the actual model string for API calls
export def GetCurrentModel(): string
    return current_model
enddef

# 4. Global Setter: Sets model if valid, returns success status
export def SetModel(model_name: string): bool
    if index(AVAILABLE_MODELS, model_name) >= 0
        current_model = model_name
        echo $"[Gemini] Model set to: {current_model}"
        return true
    else
        echoerr $"[Gemini] Invalid model: {model_name}"
        return false
    endif
enddef

# 5. Function to View Possible Models
export def ListModels()
    echo "--- Available Gemini Models ---"
    for m in AVAILABLE_MODELS
        if m == current_model
            echohl ModeMsg | echo $"* {m} (Active)" | echohl None
        else
            echo $"  {m}"
        endif
    endfor
enddef

# 6. Function to Toggle Model (Cycle through list)
export def ToggleModel()
    var idx = index(AVAILABLE_MODELS, current_model)
    var next_idx = (idx + 1) % len(AVAILABLE_MODELS)
    current_model = AVAILABLE_MODELS[next_idx]

    redraw # Clear command line to ensure message is seen
    echohl WarningMsg
    echo $"[Gemini] Switched to: {current_model}"
    echohl None
enddef

# 7. Function to Print Current Model to Screen
export def ShowCurrentModel()
    echo $"[Gemini] Active Model: {current_model}"
enddef

# Select Model via Popup Menu
export def SelectModel(): string
    var choice_lines = []
    var default_idx = 1
    var idx = 1

    # Build the choices string (e.g., "&1 gemini-flash\n&2 gemini-pro")
    for m in AVAILABLE_MODELS
        if m == current_model
            default_idx = idx
        endif
        # Add &Number to make it selectable via keyboard keys
        add(choice_lines, $"&{idx} {m}")
        idx += 1
    endfor

    # confirm({msg}, {choices}, {default}) returns 1-based index or 0 (cancel)
    var choice = confirm("Select Gemini Model:", join(choice_lines, "\n"), default_idx)

    if choice > 0
        var selected_model = AVAILABLE_MODELS[choice - 1]
        SetModel(selected_model)
        return selected_model
    endif

    echo "Selection cancelled"
    return ""
enddef

# --- Private Helpers ---

def GetApiKey(): string
    var key_file = expand('~/.config/gemini_key_4_vim/g.key')
    if !filereadable(key_file)
        echoerr $"Error: API key file not found at {key_file}"
        return ""
    endif
    return readfile(key_file)[0]->trim()
enddef

def StreamResponse(context_text: string, user_question: string)
    var api_key = GetApiKey()
    if empty(api_key) | return | endif

    # Create Scratch Buffer
    execute 'vnew'
    setlocal buftype=nofile bufhidden=wipe noswapfile filetype=markdown wrap
    var output_bufnr = bufnr()
	var model = GetCurrentModel()
    setline(1, [$"# Model: {model}", $"# Query: {user_question}"])
    append(1, "---")

    # Prepare Prompt & API
    var prompt = $"Context:\n{context_text}\n\nQuestion: {user_question}"
    var json_payload = { contents: [{ parts: [{ text: prompt }] }] }
    var api_url = $"https://generativelanguage.googleapis.com/v1beta/models/{model}:streamGenerateContent?key={api_key}&alt=sse"

    # Construct Pipeline
    # Note: We use '@-' to tell curl to read the body from stdin (which we pipe below)
    var awk_cmd = '/^data: / { print substr($0, 7); fflush() }'
    var pipeline = join([
        'curl -N -s -X POST -H "Content-Type: application/json" -d @- ' .. shellescape(api_url),
        $"awk '{awk_cmd}'",
        'jq --unbuffered -r ".candidates[0].content.parts[0].text // empty"'
    ], ' | ')

    # Start Job
    # We assume 'in_io': 'pipe' to send the JSON payload
    var job = job_start(['/bin/bash', '-c', pipeline], {
        'in_io': 'pipe',
        'out_cb': (ch, msg) => appendbufline(output_bufnr, '$', msg),
        'exit_cb': (ch, st) => appendbufline(output_bufnr, '$', ["", "---", "[Done]"])
    })

    # --- FIX: Send the payload as a STRING and CLOSE the input ---
    var ch = job_getchannel(job)
    ch_sendraw(ch, json_encode(json_payload))
    ch_close_in(ch)
enddef

# --- Public Exported Functions ---

# 1. Ask about the current whole file
export def AskCurrentFile()
    var content = getline(1, '$')->join("\n")
    var q = input("Ask about current file: ")
    if !empty(q)
        StreamResponse(content, q)
    endif
enddef

# 2. Ask about the visual selection
export def AskSelection()
    # Get the range of the last visual selection
    var [lnum1, col1] = getpos("'<")[1 : 2]
    var [lnum2, col2] = getpos("'>")[1 : 2]

    var lines = getline(lnum1, lnum2)
    if len(lines) == 0
        echo "No selection found."
        return
    endif

    var content = lines->join("\n")
    var q = input("Ask about selection: ")
    if !empty(q)
        StreamResponse(content, q)
    endif
enddef
#
# 3. Ask about multiple files (Requires fzf)
export def AskMultipleFiles()
    if !exists('*fzf#run')
        echoerr "FZF is not installed."
        return
    endif

    # --- 1. Determine Search Path ---
    var raw_input = input(
		$"Where search from? Currently at {getcwd()} \n(Enter=Here, .=Home, or path): ",
		"",
		"dir"
	)
    redraw # Clears the input prompt from the command line

    var search_path = ""

    if empty(raw_input)
        # CASE: Empty Input -> Use current directory
        # We use "." specifically so 'find' returns relative paths (cleaner list)
        search_path = "."
    elseif raw_input == '.'
        # CASE: "." Input -> Map to Home (User Request)
        search_path = expand("~")
    else
        # CASE: Path Input -> Handle ~, relative, or absolute paths
        # ':p' expands tildes and converts relative paths to full absolute paths
        search_path = fnamemodify(raw_input, ':p')
    endif

    # Validation: Ensure the path actually exists
    if !isdirectory(expand(search_path))
        echoerr $"Directory not found: {search_path}"
        return
    endif

    # --- 2. Define Exclusions ---
    var exclusions = [
        '-not -path "*/.git/*"',
        '-not -path "*/node_modules/*"',
        '-not -path "*/__pycache__/*"',   
        '-not -path "*/.venv/*"',         
        '-not -path "*/venv/*"',
        '-not -path "*/venv*"',
        '-not -path "*/.venv*"',
        '-not -path "*/virtenv/*"',
        '-not -path "*/dist/*"',          
        '-not -path "*/build/*"',
        '-not -path "*/target/*"',        
        '-not -path "*/.idea/*"',         
        '-not -path "*/.vscode/*"',       
        '-not -name ".DS_Store"',         
        '-not -name "*.svg"',             
        '-not -name "*.png"',             
        '-not -name "*.jpg"',
        '-not -name "*.pyc"',
        '-not -name ".env"', 
        '-not -name "*.swp"',
        '-not -name "*.swo"',
        '-not -name "*.swn"'  # Removed trailing comma here for strict Vim9 safety
    ]
    var ignore_flags = join(exclusions, " ")

    # --- 3. Run FZF ---
    # We use shellescape() on search_path to handle folder names with spaces
    var files = fzf#run({
        'source': $"find {shellescape(search_path)} -type f {ignore_flags}",
        'options': '--multi --prompt="Select files > "'
    })

    if empty(files) | return | endif

    var q = input($"Ask about {len(files)} files: ")
    if empty(q) | return | endif

    var combined_content = []
    for f in files
        combined_content += [$"\n--- File: {f} ---", readfile(f)->join("\n")]
    endfor

    StreamResponse(combined_content->join("\n"), q)
enddef
