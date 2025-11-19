def g:GetApiKey(): string
    var key_file = expand('~/.config/gemini_key_4_vim/g.key')

    if !filereadable(key_file)
        echoerr $"Error: API key file not found at {key_file}"
        return ""
    endif

    # readfile() returns a list of lines. Get the first line.
    # trim() removes any trailing newlines
    var api_key = readfile(key_file)[0]->trim()

    if empty(api_key)
        echoerr $"Error: API key file is empty: {key_file}"
        return ""
    endif

    return api_key
enddef

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

    # Read the current file content
    var file_content = readfile(current_file)->join("\n")

    # Prepare the prompt
    var prompt = $"File: {current_file}\n\n```\n{file_content}\n```\n\nQuestion: {question}"

    # Create JSON payload for Google Gemini API
    var json_payload = {
        contents: [{
            parts: [{
                text: prompt
            }]
        }]
    }

    var payload_str = json_encode(json_payload)

    # Call the API using curl
    var api_url = $"https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key={api_key}"

    echo " Sending request to Gemini API..."
    var response = system($'curl -s -X POST -H "Content-Type: application/json" -d {shellescape(payload_str)} {shellescape(api_url)}')

    # Parse and display response
    g:DisplayApiResponse(response)
enddef


# --- Helper function to display API response ---
def g:DisplayApiResponse(response: string)
    try
        var response_obj = json_decode(response)

        # Extract the text from Gemini's response
        if has_key(response_obj, 'candidates') && !empty(response_obj.candidates)
            var candidate = response_obj.candidates[0]
            if has_key(candidate, 'content') && has_key(candidate.content, 'parts')
                var text = candidate.content.parts[0].text

                # Open response in a new split
                execute 'new'
                setlocal buftype=nofile bufhidden=wipe noswapfile
                setlocal filetype=markdown

                # Insert the response
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
# AI Bot Mappings
# ==========================================================
nnoremap <leader>af <Cmd>call g:AskAboutFile()<CR>

