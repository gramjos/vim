# single file ai help  
# ==========================================================
nnoremap <leader>aa <Cmd>call g:AskAboutAllFiles()<CR>

# API Key Helper (Unchanged and Solid)
# ==========================================================
def g:GetApiKey(): string
    var key_file = expand('~/.config/gemini_key_4_vim/g.key')
    if !filereadable(key_file)
        echoerr $"Error: API key file not found at {key_file}"
        return ""
    endif
    var api_key = readfile(key_file)[0]->trim()
    if empty(api_key)
        echoerr $"Error: API key file is empty: {key_file}"
        return ""
    endif
    return api_key
enddef

def g:AskAboutAllFiles()
    var api_key = g:GetApiKey()
    if empty(api_key)
        return
    endif
    var current_file = expand('%:p')
    if empty(current_file) || !filereadable(current_file)
        echoerr "Error: No valid file in current buffer"
        return
    endif
    var question = input("Ask about this file: ")
    if empty(question)
        echo "Cancelled."
        return
    endif

    # TODO: multi select fzf files to include in prompt


    # --- Create the scratch buffer *before* the job ---
    execute 'new'
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal filetype=markdown
    var output_bufnr = bufnr()
    call setline(1, $"[Query: {question}]")
    call setline(2, "---")
    execute 'normal! G' # Move to end, ready to stream
    # --- Prepare API request ---
    var file_content = readfile(current_file)->join("\n")
    var prompt = $"File: {current_file}\n\n```\n{file_content}\n```\n\nQuestion: {question}"
    var json_payload = {
        contents: [{
            parts: [{
                text: prompt
            }]
        }]
    }
    var payload_str = json_encode(json_payload)
    var api_url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:streamGenerateContent?key={api_key}&alt=sse"
    var awk_cmd = '/^data: / { print substr($0, 7); fflush() }' # magic 7 from length of prefix len("data: ") then real json starts
    var awk_command_full = "awk '" .. awk_cmd .. "'"
    var pipeline = join([
        'curl -N -s -X POST -H "Content-Type: application/json" -d "$1" "$2"',
        awk_command_full,  
        'jq --unbuffered -r ".candidates[0].content.parts[0].text // empty"'
    ], ' | ')
    var cmd = ['/bin/bash', '-c', pipeline, 'bash', payload_str, api_url]
    var On_stdout = (job: any, data: string) => {
        if empty(data)
            return
        endif
        call appendbufline(output_bufnr, '$', data)
   }
    var On_stderr = (job: any, data: list<string>) => {
        for line in data
            if !empty(line)
                call appendbufline(output_bufnr, '$', $"[Pipeline STDERR: {line}]")
            endif
        endfor
    }
    var On_exit = (job: any, status: number) => {
        if status == 0
            call appendbufline(output_bufnr, '$', "")
            call appendbufline(output_bufnr, '$', "[Stream finished]")
        else
            call appendbufline(output_bufnr, '$', "")
            call appendbufline(output_bufnr, '$', $"[Pipeline failed, exit status: {status}]")
        endif
    }
    var job_options = {
        'out_cb': On_stdout,
        'err_cb': On_stderr,
        'exit_cb': On_exit,
        'out_mode': 'nl',
        'err_mode': 'nl',
    }
    echo "Starting pipeline to Gemini API (async)..."
    var job = job_start(cmd, job_options)
    if job_status(job) == 'fail'
        echoerr "Failed to start async job."
    endif
enddef

