vim9script

# ==========================================================
# AskBot v4 - Multi-file AI Assistant with Streaming
# ==========================================================
# Features:
#   - FZF-based multi-file selection (text and images)
#   - Support for Gemini Vision API (images + text)
#   - Async streaming responses
#   - Modular architecture
# ==========================================================

# ==========================================================
# Configuration
# ==========================================================
const CONFIG = {
    api_key_file: expand('~/.config/gemini_key_4_vim/g.key'),
    model: 'gemini-2.0-flash-exp',
    api_base: 'https://generativelanguage.googleapis.com/v1beta/models',
    supported_images: ['.png', '.jpg', '.jpeg', '.gif', '.webp'],
}

# ==========================================================
# Utility Functions
# ==========================================================

def GetApiKey(): string
    if !filereadable(CONFIG.api_key_file)
        echoerr $"Error: API key file not found at {CONFIG.api_key_file}"
        return ""
    endif
    
    var api_key = readfile(CONFIG.api_key_file)[0]->trim()
    
    if empty(api_key)
        echoerr $"Error: API key file is empty: {CONFIG.api_key_file}"
        return ""
    endif
    
    return api_key
enddef

def IsImageFile(filepath: string): bool
    var ext = fnamemodify(filepath, ':e')->tolower()
    return CONFIG.supported_images->index('.' .. ext) >= 0
enddef

def EncodeImageBase64(filepath: string): string
    # Use base64 command to encode image
    var cmd = ['base64', '-w', '0', filepath]
    var result = system(cmd->join(' '))
    return result->trim()
enddef

def GetImageMimeType(filepath: string): string
    var ext = fnamemodify(filepath, ':e')->tolower()
    var mime_map = {
        'png': 'image/png',
        'jpg': 'image/jpeg',
        'jpeg': 'image/jpeg',
        'gif': 'image/gif',
        'webp': 'image/webp',
    }
    return get(mime_map, ext, 'image/jpeg')
enddef

# ==========================================================
# File Selection with FZF
# ==========================================================

def SelectFilesWithFzf(current_file: string): list<string>
    # Get list of files from current git repo or directory
    var git_cmd = 'git ls-files 2>/dev/null'
    var find_cmd = 'find . -type f \( ! -path "*/\.*" \) | sed "s|^\./||" | head -1000'
    
    # Try git first, fallback to find
    var list_cmd = $'({git_cmd} || {find_cmd})'
    
    # Use fzf for multi-selection
    # --multi: enable multi-select with TAB
    # --prompt: custom prompt
    # --preview: show file preview
    var fzf_cmd = 'fzf --multi --prompt="Select files (TAB to select multiple, ENTER to confirm): " --preview="head -50 {}"'
    
    var full_cmd = $'{list_cmd} | {fzf_cmd}'
    
    # Call fzf via system() - it will use the terminal
    var selected = systemlist(full_cmd)
    
    if v:shell_error != 0
        return []
    endif
    
    # Convert to absolute paths
    var cwd = getcwd()
    var result: list<string> = []
    for file in selected
        var abs_path = fnamemodify(file, ':p')
        if filereadable(abs_path)
            result->add(abs_path)
        endif
    endfor
    
    # Always include current file first if not in selection
    if !result->empty() && result->index(current_file) < 0
        result = [current_file] + result
    endif
    
    return result
enddef

# ==========================================================
# API Payload Construction
# ==========================================================

def BuildMultiFilePrompt(files: list<string>, question: string): dict<any>
    var parts: list<dict<any>> = []
    
    # Add question first
    var intro = "I have a question about the following files:\n\n"
    parts->add({text: intro})
    
    # Process each file
    for filepath in files
        if IsImageFile(filepath)
            # Add image part
            var image_data = EncodeImageBase64(filepath)
            var mime_type = GetImageMimeType(filepath)
            
            parts->add({text: $"\nImage: {filepath}\n"})
            parts->add({
                inline_data: {
                    mime_type: mime_type,
                    data: image_data
                }
            })
        else
            # Add text file
            var content = readfile(filepath)->join("\n")
            parts->add({text: $"\n### File: {filepath}\n```\n{content}\n```\n"})
        endif
    endfor
    
    # Add the actual question
    parts->add({text: $"\n\nQuestion: {question}\n\nPlease provide a detailed answer."})
    
    return {
        contents: [{
            parts: parts
        }]
    }
enddef

# ==========================================================
# Streaming Response Handler
# ==========================================================

def CreateOutputBuffer(question: string, files: list<string>): number
    execute 'new'
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal filetype=markdown
    setlocal wrap linebreak
    
    var bufnr = bufnr()
    
    # Add header
    call setline(1, '# AI Assistant Response')
    call append(1, '')
    call append(2, $'**Question:** {question}')
    call append(3, '')
    call append(4, '**Files:**')
    
    var line_num = 5
    for file in files
        var display_name = fnamemodify(file, ':~:.')
        var file_type = IsImageFile(file) ? '[Image]' : '[Text]'
        call append(line_num, $'  - {file_type} {display_name}')
        line_num += 1
    endfor
    
    call append(line_num, '')
    call append(line_num + 1, '---')
    call append(line_num + 2, '')
    
    execute 'normal! G'
    
    return bufnr
enddef

def StartStreamingRequest(payload: dict<any>, output_bufnr: number)
    var api_key = GetApiKey()
    if empty(api_key)
        return
    endif
    
    var payload_str = json_encode(payload)
    var api_url = $"{CONFIG.api_base}/{CONFIG.model}:streamGenerateContent?key={api_key}&alt=sse"
    
    # Build curl command for streaming
    var cmd = [
        'curl', '-N', '-s', '-X', 'POST',
        '-H', 'Content-Type: application/json',
        '-d', payload_str,
        api_url
    ]
    
    # State for streaming
    var stream_state = {
        data_buffer: "",
        bufnr: output_bufnr
    }
    
    # Stdout callback - handles SSE streaming
    var On_stdout = (job: any, data: string) => {
        if empty(data)
            return
        endif
        
        stream_state.data_buffer ..= data .. "\n"
        var lines = split(stream_state.data_buffer, "\n", true)
        
        # Keep last incomplete line in buffer
        stream_state.data_buffer = lines->remove(-1)
        
        for line in lines
            var trimmed = line->trim()
            
            # SSE format: "data: {json}"
            if trimmed =~ '^data: '
                var json_str = trimmed[6:]
                
                try
                    var chunk = json_decode(json_str)
                    
                    # Handle errors
                    if has_key(chunk, 'error')
                        call appendbufline(stream_state.bufnr, '$', '')
                        call appendbufline(stream_state.bufnr, '$', $"**Error:** {chunk.error.message}")
                        continue
                    endif
                    
                    # Extract text from candidates
                    if has_key(chunk, 'candidates') && !empty(chunk.candidates)
                        for candidate in chunk.candidates
                            if has_key(candidate, 'content')
                                && has_key(candidate.content, 'parts')
                                && !empty(candidate.content.parts)
                                && has_key(candidate.content.parts[0], 'text')
                                
                                var text_chunk = candidate.content.parts[0].text
                                
                                if !empty(text_chunk)
                                    # Append to current line, then add new lines
                                    var new_lines = split(text_chunk, "\n", true)
                                    var last_line_num = getbufinfo(stream_state.bufnr)[0].linecount
                                    var last_content = getbufline(stream_state.bufnr, last_line_num)[0]
                                    
                                    call setbufline(stream_state.bufnr, last_line_num, last_content .. new_lines[0])
                                    
                                    if new_lines->len() > 1
                                        call appendbufline(stream_state.bufnr, last_line_num, new_lines[1:])
                                    endif
                                endif
                            endif
                        endfor
                    endif
                catch
                    # Silently ignore parse errors for incomplete chunks
                endtry
            endif
        endfor
    }
    
    var On_stderr = (job: any, data: string) => {
        if !empty(data)
            call appendbufline(stream_state.bufnr, '$', $"[Error: {data}]")
        endif
    }
    
    var On_exit = (job: any, status: number) => {
        call appendbufline(stream_state.bufnr, '$', '')
        call appendbufline(stream_state.bufnr, '$', '')
        if status == 0
            call appendbufline(stream_state.bufnr, '$', '---')
            call appendbufline(stream_state.bufnr, '$', '*Response complete*')
        else
            call appendbufline(stream_state.bufnr, '$', $'*Request failed (exit code: {status})*')
        endif
    }
    
    var job_options = {
        'out_cb': On_stdout,
        'err_cb': On_stderr,
        'exit_cb': On_exit,
        'out_mode': 'raw',
        'err_mode': 'nl',
    }
    
    echo "Streaming response from Gemini API..."
    
    var job = job_start(cmd, job_options)
    
    if job_status(job) == 'fail'
        echoerr "Failed to start API request job"
    endif
enddef

# ==========================================================
# Main Entry Point
# ==========================================================

export def AskAboutFiles()
    var api_key = GetApiKey()
    if empty(api_key)
        return
    endif
    
    var current_file = expand('%:p')
    if empty(current_file) || !filereadable(current_file)
        echoerr "Error: No valid file in current buffer"
        return
    endif
    
    # Step 1: Get question from user
    var question = input("Ask a question about files: ")
    if empty(question)
        echo "Cancelled."
        return
    endif
    
    echo "\n"
    
    # Step 2: Select files (opens FZF in terminal)
    echo "Opening file selector... (TAB to multi-select, ENTER to confirm)"
    var selected_files = SelectFilesWithFzf(current_file)
    
    if empty(selected_files)
        echo "No files selected. Using current file only."
        selected_files = [current_file]
    endif
    
    # Step 3: Create output buffer
    var output_bufnr = CreateOutputBuffer(question, selected_files)
    
    # Step 4: Build API payload
    var payload = BuildMultiFilePrompt(selected_files, question)
    
    # Step 5: Start streaming request
    StartStreamingRequest(payload, output_bufnr)
enddef

# ==========================================================
# Simple wrapper for single-file mode (backward compat)
# ==========================================================

export def AskAboutCurrentFile()
    var api_key = GetApiKey()
    if empty(api_key)
        return
    endif
    
    var current_file = expand('%:p')
    if empty(current_file) || !filereadable(current_file)
        echoerr "Error: No valid file in current buffer"
        return
    endif
    
    var question = input("Ask about current file: ")
    if empty(question)
        echo "Cancelled."
        return
    endif
    
    var output_bufnr = CreateOutputBuffer(question, [current_file])
    var payload = BuildMultiFilePrompt([current_file], question)
    StartStreamingRequest(payload, output_bufnr)
enddef

# ==========================================================
# Mappings
# ==========================================================

# Multi-file mode with FZF selection
nnoremap <leader>aa <Cmd>call <SID>AskAboutFiles()<CR>

# Single-file mode (quick access)
nnoremap <leader>af <Cmd>call <SID>AskAboutCurrentFile()<CR>
