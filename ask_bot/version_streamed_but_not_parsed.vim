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
# Main Async Streaming Function (With Debugging)
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
    # --- 1. Create the scratch buffer *before* the job ---
    execute 'new'
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal filetype=markdown
    var output_bufnr = bufnr()
    call setline(1, $"[Query: {question}]")
    call setline(2, "---")
    execute 'normal! G'
    # --- 2. Prepare API request ---
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
    # --- 3. Use the STREAMING endpoint ---
    var api_url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash-lite:streamGenerateContent?key={api_key}&alt=sse"
    # --- 4. Use `curl -N` for streaming ---
    var cmd = ['curl', '-N', '-s', '-X', 'POST', '-H', 'Content-Type: application/json', '-d', payload_str, api_url]
    # --- 5. Define state and callbacks ---
    var stream_state = {
        data_buffer: "",
        bufnr: output_bufnr
    }
    # --- DEBUGGING VERSION of On_stdout ---
    # This will dump its internal state into the buffer
    var On_stdout = (job: any, data: string) => {
        # DEBUG 1: Show the raw data chunk from curl
        call appendbufline(stream_state.bufnr, '$', $"[RAW_DATA_CHUNK: {data}]")
        stream_state.data_buffer ..= data
        var lines = split(stream_state.data_buffer, "\n")
        stream_state.data_buffer = lines->remove(-1)
        for line in lines
            var trimmed_line = line->trim()
            # DEBUG 2: Show the line we are about to process
            call appendbufline(stream_state.bufnr, '$', $"[PROCESSING_LINE: {trimmed_line}]")
            if trimmed_line =~ '^data: '
                # DEBUG 3: Confirm we matched the 'data:' prefix
                call appendbufline(stream_state.bufnr, '$', "[DEBUG: 'data:' prefix found]")
                var json_str = trimmed_line[6 :]
                # DEBUG 4: Show the JSON string before parsing
                call appendbufline(stream_state.bufnr, '$', $"[DEBUG: Decoding JSON: {json_str}]")
                try
                    var chunk_obj = json_decode(json_str)
                    # DEBUG 5: Confirm JSON parsing was successful
                    call appendbufline(stream_state.bufnr, '$', "[DEBUG: JSON decode success]")
                    if has_key(chunk_obj, 'error')
                        call appendbufline(stream_state.bufnr, '$', $"[API Error: {chunk_obj.error.message}]")
                        continue
                    endif
                    if has_key(chunk_obj, 'candidates')
                        call appendbufline(stream_state.bufnr, '$', "[DEBUG: 'candidates' key found]")
                        for candidate in chunk_obj.candidates
                            if has_key(candidate, 'content')
                                    && has_key(candidate.content, 'parts')
                                    && !empty(candidate.content.parts)
                                    && has_key(candidate.content.parts[0], 'text')
                                var text_chunk = candidate.content.parts[0].text
                                call appendbufline(stream_state.bufnr, '$', $"[DEBUG: Extracted text: {text_chunk}]")
                                if empty(text_chunk)
                                    continue
                                endif
                                var new_lines = split(text_chunk, "\n", true)
                                var lnum = getbufinfo(stream_state.bufnr)[0].linecount
                                var lcontent = getbufline(stream_state.bufnr, lnum)[0]
                                call setbufline(stream_state.bufnr, lnum, lcontent .. new_lines[0])
                                if new_lines->len() > 1
                                    call appendbufline(stream_state.bufnr, lnum, new_lines[1 :])
                                endif
                            else
                                call appendbufline(stream_state.bufnr, '$', "[DEBUG: Candidate found, but no text part]")
                            endif
                        endfor
                    else
                        call appendbufline(stream_state.bufnr, '$', "[DEBUG: No 'candidates' key in this chunk]")
                    endif
                catch
                    # DEBUG 6: Catch and display any parsing errors
                    call appendbufline(stream_state.bufnr, '$', $"[JSON Parse Error: {v:exception}]")
                    call appendbufline(stream_state.bufnr, '$', $"[Problematic Line: {trimmed_line}]")
                endtry
            endif
        endfor
    }
    # This callback logs any stderr output from curl
    var On_stderr = (job: any, data: string) => {
        call appendbufline(stream_state.bufnr, '$', $"[curl STDERR: {data}]")
    }
    var On_exit = (job: any, status: number) => {
        if status == 0
            call appendbufline(stream_state.bufnr, '$', "")
            call appendbufline(stream_state.bufnr, '$', "[Stream finished]")
        else
            call appendbufline(stream_state.bufnr, '$', "")
            call appendbufline(stream_state.bufnr, '$', $"[Stream failed, exit status: {status}]")
        endif
    }
    # --- 6. Define job options ---
    var job_options = {
        'out_cb': On_stdout,
        'err_cb': On_stderr,
        'exit_cb': On_exit,
    }
    echo "Starting stream to Gemini API (async)..."
    # --- 7. Start the job ---
    var job = job_start(cmd, job_options)
    if job_status(job) == 'fail'
        echoerr "Failed to start async job."
    endif
enddef
# ==========================================================
# AI Bot Mappings (Unchanged)
# ==========================================================
nnoremap <leader>af <Cmd>call g:AskAboutFile()<CR>
