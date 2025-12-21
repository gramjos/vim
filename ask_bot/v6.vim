# # just a scratch pad
#
#
#
#
#
# Global Memory Variable
if !exists('g:memory')
    g:memory = false
endif

# Show Memory Mode
command! IsMemoryOn {
    echo $"AskBot Memory is: {g:memory ? 'ON' : 'OFF'}"
}
# toggle memory 
command! ToggleMemory {
    g:memory = !g:memory
    echo $"AskBot Memory is now: {g:memory ? 'ON' : 'OFF'}"
}
# Function to clear memory by deleting the log.json file
def g:ClearMemory()
    var log_file = expand('~/.vim/askbot_log/log.json')
    if filereadable(log_file)
        call delete(log_file)
        echo "AskBot memory cleared."
    else
        echo "No memory to clear."
    endif
enddef

# Map a keybinding to clear memory (e.g., <leader>ac)
nnoremap <silent> <leader>ac :call g:ClearMemory()<CR>


nnoremap <silent> <leader>af :call g:AskCurrentFile()<CR>
##
## # 2. Ask Selection: <leader>as
## # We use <Esc> to update the '< and '> marks before calling the function
vnoremap <silent> <leader>as :call g:AskSelection()<CR>
##
## # 3. Ask All (Fuzzy): <leader>aa
nnoremap <silent> <leader>aa :call g:AskAll()<CR>

# --- Helper: Logging ---
def LogInteraction(query: string, context_text: string, response: string)
    var log_dir = expand('~/.vim/askbot_log')
    var log_file = log_dir .. '/log.json'

    # 1. Ensure directory exists
    if !isdirectory(log_dir)
        mkdir(log_dir, 'p')
    endif

    # 2. Load existing logs
    var logs = []
    if filereadable(log_file)
        try
            var file_content = readfile(log_file)
            if !empty(file_content)
                logs = json_decode(join(file_content, "\n"))
            endif
        catch
            # If JSON is corrupt, we start fresh
            logs = []
        endtry
    endif

    # 3. Create new entry
    var new_entry = {
        query: query,
        query_context: context_text,
        response: response,
        timestamp: strftime('%Y-%m-%d %H:%M:%S')
    }

    # 4. Append and Write
    add(logs, new_entry)
    writefile([json_encode(logs)], log_file)
enddef

def GetApiKey(): string
    var key_file = expand('~/.config/gemini_key_4_vim/g.key')
    if !filereadable(key_file)
        echoerr $"Error: API key file not found at {key_file}"
        return ""
    endif
    return readfile(key_file)[0]->trim()
enddef

# --- Helper: Memory Retrieval ---
def GetMemoryContext(): string
    var log_file = expand('~/.vim/askbot_log/log.json')
    if !filereadable(log_file)
        return ""
    endif

    var logs = []
    try
        var content = readfile(log_file)->join("\n")
        logs = json_decode(content)
    catch
        return ""
    endtry

    if empty(logs)
        return ""
    endif

    var memory_string = "--- CONVERSATION HISTORY ---\n"
    for entry in logs
        memory_string ..= $"USER ASKED: {entry.query}\n"
        memory_string ..= $"AI REPLIED: {entry.response}\n"
        memory_string ..= "---\n"
    endfor
    memory_string ..= "--- END HISTORY ---\n\n"

    return memory_string
enddef

def StreamResponse(context_text: string, user_question: string)
    var api_key = GetApiKey()
    if empty(api_key) | return | endif

    # Create Scratch Buffer
    execute 'vnew'
    setlocal buftype=nofile bufhidden=wipe noswapfile filetype=markdown wrap
    var output_bufnr = bufnr()

    # Visual indicator if memory is being used
	append(1, $"(Memory: {g:memory ? 'ON' : 'OFF'})")
    append(1, "---")

    # --- Construct Prompt with Memory if enabled ---
    var final_context = ""

    if g:memory
        var history = GetMemoryContext()
        final_context = $"{history}CURRENT FILE CONTEXT:\n{context_text}"
    else
        final_context = $"Context:\n{context_text}"
    endif

	var prompt = $"{final_context}\n\nQuestion: {user_question}"
    append(1, "---")
    setline(1, split(prompt, "\n"))

    # Prepare API Payload
    var json_payload = { contents: [{ parts: [{ text: prompt }] }] }

    var base_url = "https://generativelanguage.googleapis.com/v1beta/models/"
    var model_url = "gemini-2.5-flash-lite"
    var api_url = $"{base_url}{model_url}:streamGenerateContent?key={api_key}&alt=sse"
	#
    # Construct Pipeline
    var awk_cmd = '/^data: / { print substr($0, 7); fflush() }'
    var pipeline = join([
        'curl -N -s -X POST -H "Content-Type: application/json" -d @- ' .. shellescape(api_url),
        $"awk '{awk_cmd}'",
        'jq --unbuffered -r ".candidates[0].content.parts[0].text // empty"'
    ], ' | ')

    # --- Capture State for Logging ---
    var collected_response = []

    # Start Job
    var job = job_start(['/bin/bash', '-c', pipeline], {
        'in_io': 'pipe',
        'out_cb': (ch, msg) => {
            # 1. Update Buffer
            appendbufline(output_bufnr, '$', msg)
            # 2. Accumulate for Log
            add(collected_response, msg)
        },
        'exit_cb': (ch, st) => {
            appendbufline(output_bufnr, '$', ["", "---", "[Done]"])
            # 3. Save to Log when finished
            var full_response_text = join(collected_response, "\n")
            LogInteraction(user_question, context_text, full_response_text)
        }
    })

    # Send payload
    var ch = job_getchannel(job)
    ch_sendraw(ch, json_encode(json_payload))
    ch_close_in(ch)
enddef

# --- Public Exported Functions ---

# 1. Ask about the current whole file
def g:AskCurrentFile()
    var content = getline(1, '$')->join("\n")
    var q = input("Ask about current file: ")
    if !empty(q)
        StreamResponse(content, q)
    endif
enddef

# 2. Ask about the visual selection
def g:AskSelection()
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

# 3. Ask about multiple files (Requires fzf)
def g:AskAll()
    if !exists('*fzf#run')
        echoerr "FZF is not installed."
        return
    endif

    var raw_input = input(
        $"Where search from? Currently at {getcwd()} \n(Enter=Here, .=Home, or path): ",
        "",
        "dir"
    )
    redraw

    var search_path = ""
    if empty(raw_input)
        search_path = "."
    elseif raw_input == '.'
        search_path = expand("~")
    else
        search_path = fnamemodify(raw_input, ':p')
    endif

    if !isdirectory(expand(search_path))
        echoerr $"Directory not found: {search_path}"
        return
    endif

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
        '-not -name "*.swn"'
    ]
    var ignore_flags = join(exclusions, " ")

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




