vim9script

# ==========================================================
# API Key Helper (Unchanged)
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

# ==========================================================
# Main Async Function (Corrected)
# ==========================================================

def g:AskAboutFile()
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
    # var api_url = $"https://generativelace.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"
    var api_url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"


    # --- Asynchronous Logic using job_start() ---

    var cmd = ['curl', '-s', '-X', 'POST', '-H', 'Content-Type: application/json', '-d', payload_str, api_url]

    var response_data: list<string> = []
    var error_data: list<string> = []

    # FIX: Changed `var on_exit` to `var On_exit`
    # Vim9script requires variables holding a Funcref to be capitalized.
    var On_exit = (job: any, status: number) => {
        if status != 0
            echoerr $"Async job failed with status: {status}"
            var err_msg = error_data->join('')
            if !empty(err_msg)
                echoerr $"Stderr: {err_msg}"
            endif
            return
        endif

        # On success, join all the received chunks and
        # call the original display function.
        var final_response = response_data->join('')
        g:DisplayApiResponse(final_response)
    }

    # Define the job options, using lambdas for the I/O callbacks
    var job_options = {
        'out_cb': (channel, data) => response_data->add(data),
        'err_cb': (channel, data) => error_data->add(data),
        # FIX: Use the capitalized `On_exit` variable
        'exit_cb': On_exit,
    }

    echo "Sending request to Gemini API (async)..."

    var job = job_start(cmd, job_options)

    if job_status(job) == 'fail'
        echoerr "Failed to start async job."
    endif

    # Function now exits immediately, Vim is not blocked.
    # The `On_exit` callback will run when the job completes.
enddef


# ==========================================================
# Response Display Helper (Unchanged)
# ==========================================================

def g:DisplayApiResponse(response: string)
    try
        var response_obj = json_decode(response)

        if has_key(response_obj, 'candidates') && !empty(response_obj.candidates)
            var candidate = response_obj.candidates[0]
            if has_key(candidate, 'content') && has_key(candidate.content, 'parts')
                var text = candidate.content.parts[0].text

                execute 'new'
                setlocal buftype=nofile bufhidden=wipe noswapfile
                setlocal filetype=markdown

                call setline(1, split(text, "\n"))
                execute 'normal! gg'
            else
                echoerr "Unexpected response format"
                echo response
            endif
        elseif has_key(response_obj, 'error')
            echoerr $"API Error: {response_obj.error.message}"
        else
            echoerr "Unexpected response format"
            echo response
        endif
    catch
        echoerr $"Error parsing response: {v:exception}"
        echo response
    endtry
enddef

# ==========================================================
# AI Bot Mappings (Unchanged)
# ==========================================================
nnoremap <leader>af <Cmd>call g:AskAboutFile()<CR>

