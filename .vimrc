vim9script 

# vim run commands(rc). run these commands at the start of each vim instance
# Folds at:

    # Sets
    #  - `set`, `autocmd`, `let`, `call`, `highlight` optional packages
    # Auto Comands
    # Custom func
    #  - `function!`
    # Maps
    #  - `map`
    # Abbreivations
    #  - `iabbrev`, `ab`

###########################################################
# Sets
###########################################################
filetype plugin indent on
packadd! matchit
# time out on mapping after two seconds, time out on key codes after a ninety-ninth
set timeout timeoutlen=2000 ttimeoutlen=99
#
#
set undofile # tell it to use an undo file
set undodir=/Users/gramjos/.vimundo/ # set a directory to store the undo history
#
# highlight CurSearch cterm=reverse gui=reverse
highlight CurSearch guibg=Red guifg=Black

# For Terminal Vim
highlight CurSearch ctermbg=Red ctermfg=Black

highlight FindMe ctermbg=green guibg=green gui=bold
call matchadd("FindMe", "Graham Joss")
set spellcapcheck=<CR> # turn off capitalization 
#
set hlsearch #Search Hightlighting
#
# New buffer formatting/settings
set ruler               # show line and column number
syntax enable           # syntax highlighting
set showcmd             # show (partial) command in status line
set showmatch            # highlight matching bracket when cursor over it
# set number                # static numbering OFF
set fileformat=mac
# Tell Vim to look for tags file in current directory and upward
set tags=./tags,tags;
#
# Tab/Indent Sizes
set autoindent          # copy indent from current line when 
set smartindent
set shiftwidth=4        # number of spaces to use for auto indent
set tabstop=4           # use 4 spaces to represent tab
# set mouse as clickable. to drag window size of :vert term 
#and when in term mode from insise of vim i can scroll up thru the page not 
# thru the command history
set mouse=nvi
set ls=2 # last status. always_on=2
#turn on visual bell
set noerrorbells
set vb t_vb=
# set belloff="all"
# defaults for :sp and :vs respectively 
set splitbelow
set splitright  
#
# NETRW config
# tree view as default
g:netrw_liststyle = 3
# line numbers in netrw
g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
# Normally, the v key splits the window vertically with the new window and cursor at the left.  To change to splitting the window vertically with the new window and cursor at the right, have    https://vimdoc.sourceforge.net/htmldoc/pi_netrw.html#netrw-v
g:netrw_altv = 1
#
set shell=/bin/zsh # Change Vim's shell from bash to zsh
#
# Search down into subfolders
# provides tab completion for all file realted tasks but way too expensive, just know where you are!
# set path+=.,,**,./**,../**
set encoding=utf-8
# set the dictionary paths. to activate pop-up window. Control xk. 
# Control buton = ^
set dictionary+=/usr/share/dict/web2
#
# finding files:  Display all matching files when we tab complete
set wildmenu
#
# How to collect cexpr system('coinz') output as raw line
set errorformat=%m
#
# skeleton Templates C Java HTML
autocmd BufNewFile *.c :0r ~/.vim/templates/c.skel
autocmd BufNewFile *.html :0r ~/.vim/templates/html.skel
autocmd BufNewFile *.java execute ':0read !cat ~/.vim/templates/java.skel | sed "s/CLASSNAME/' .. expand('%:r') .. '/g"'

# Persist code folds
augroup LeftOff
  autocmd!
  autocmd BufWinLeave *.* if &buftype == '' && filereadable(expand('%')) | mkview | endif
  autocmd BufWinEnter *.* if &buftype == '' && filereadable(expand('%')) | silent! loadview | endif
augroup END

augroup FiletypeSettings
  autocmd!
  autocmd FileType txt set spell spelllang=en_us
  autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python set keywordprg=python3\ -m\ pydoc
  # When in the quickfix window, map 'p' to preview the entry and return.
  autocmd FileType qf nnoremap <buffer><silent> p <CR><C-w>p
augroup END


# ----------------------------------------------------------
# Leader Key
# ----------------------------------------------------------
g:mapleader = ' '
# Taken Leader combos aside, use :vimgrep /leader/ ~/.vim/*
### vimgrep
# <Tab> . aa af as b c d D ev f gf hl j k m n N o pv qv r so sp u U w W y

# " Map 'f' to move forward (Buffer Next)
nnoremap <leader>f :bn<CR>

# " Map 'b' to move backward (Buffer Previous)
nnoremap <leader>b :bp<CR>

# Map <leader>m to copy the last message to the system clipboard
nnoremap <leader>m :let @+ = trim(execute('1messages'))<CR>

def g:GfCreate()
	var raw_path = expand('<cfile>')
	if empty(raw_path)
		echoerr "No file path under cursor."
		return
	endif
	var expanded_path = expand(raw_path)
	var dir_path = fnamemodify(expanded_path, ':h')
	if !empty(dir_path) && dir_path != '.'
		if mkdir(dir_path, 'p') == -1
			echoerr "Failed to create directory: " .. dir_path
			return
		endif
	endif
	execute 'edit ' .. fnameescape(expanded_path)
enddef
nnoremap <silent> <Leader>gf :call g:GfCreate()<CR>

# ==========================================================
# Functions (Vim9script)
# ==========================================================

def g:AddSpace(direction: string): void
    # Get the count. v:count1 defaults to 1 if no count is given.
    var count = v:count1

    # Save cursor position
    var original_pos = getpos('.')

    # Create the new lines.
    # We use 'execute "normal!..."' to apply the count.
    if direction == 'O'
        execute $"normal! {count}O"
    else
        execute $"normal! {count}o"
    endif

    # Return cursor to its original position
    setpos('.', original_pos)
enddef

nnoremap <silent> <leader>k <Cmd>call g:AddSpace('O')<CR>
nnoremap <silent> <leader>j <Cmd>call g:AddSpace('o')<CR>

# # --- Open File with External Application ---
def g:OpenWith(app_name: string)
  var file_path = expand('<cfile>')
  # Use job_start for non-blocking execution
  if app_name == 'qkv'
      job_start(['qkv', file_path])
  else
      job_start(['open', '-a', app_name, file_path])
  endif
enddef
nnoremap <leader>qv <Cmd>call g:OpenWith('qkv')<CR>
nnoremap <leader>pv <Cmd>call g:OpenWith('Preview')<CR>


# --- Open Current File in Obsidian ---
# BROKEN: cant find the right path to open in shell call
# All files have the form [[...]] where ... is either file1 or dir/file2
def g:OpenInObsidian()
  # Yank the content inside the square brackets
  execute 'normal! vi]y'
  var file_path = getreg('"')

  if empty(file_path)
    echo "Error: Could not find a file path in [[...]] brackets."
    return
  endif

  # Append .md if not present and construct the URL-encoded path
  var obsidian_path = fnameescape(file_path .. '.md')
  var safe_obsidian_path = substitute(obsidian_path, ' ', '%20', 'g')

  # Use job_start with the 'open' command on macOS
  job_start(['open', $"obsidian://open?path={safe_obsidian_path}"])
  echomsg $"Opening {safe_obsidian_path}.md in Obsidian"
enddef
nnoremap <silent> <leader>o <Cmd>call g:OpenInObsidian()<CR>

command! -nargs=1 -complete=help Hw OpenHelpInNewTerminal(<q-args>)
def OpenHelpInNewTerminal(topic: string)
  var vim_command = $"vim -c 'help {topic}' -c 'only'"
  var apple_script = $"tell application \"Terminal\" to do script \"{vim_command}\""
  job_start(['osascript', '-e', apple_script])
  redraw!
enddef
# 
# --- Help in New tab
command -nargs=1 Ht execute 'tab help ' .. <q-args>

# --- ASCII Art Generator ---
command -nargs=+ Bubble BubbleFont(<q-args>)
def BubbleFont(text: string)
    var script_path = expand('~/.vim/scripts/mk_ascii.py')
    var bubble_output = system(script_path .. ' ' .. shellescape(text))
    put = bubble_output # Insert the output below the current line
enddef
#
# # ==========================================================
# # Mappings
# # ==========================================================
# # --- General ---
noremap <leader><Tab> mzI<Tab><Esc>`z
noremap <leader>hl <Cmd>nohlsearch<CR>
noremap <leader>r :<Up><CR>
noremap <leader>so <Cmd>source $MYVIMRC<CR>
nnoremap <leader>ev <Cmd>tabe $MYVIMRC<CR>
# redo last Ex command
nnoremap <leader>. @:
# 
# # --- Window Resizing ---
noremap <leader>u <Cmd>resize +2<CR>
noremap <leader>U <Cmd>resize +6<CR>
noremap <leader>d <Cmd>resize -2<CR>
noremap <leader>D <Cmd>resize -6<CR>
noremap <leader>w <Cmd>vertical resize +2<CR>
noremap <leader>W <Cmd>vertical resize +10<CR>
noremap <leader>n <Cmd>vertical resize -2<CR>
noremap <leader>N <Cmd>vertical resize -10<CR>
# 
# # --- Yank to System Clipboard ---
nnoremap <leader>y <Cmd>let @* = @0<CR>
vnoremap <leader>y <Cmd>let @* = @0<CR>
# 
# # --- Spelling ---
nnoremap <leader>sp mz[s1z=`z
nmap <F5> <Cmd>setlocal spell! spelllang=en_us<CR>
# 
# # --- Other Mappings ---
imap ;; <Esc>
tnoremap <Esc> <C-W>N
nmap ß :%s//g<Left><Left>
# 
# # ==========================================================
# # Abbreviations
# # ==========================================================
iabbr <expr> ^^- getline(search('\\S\\_.*\\n\\_.*\\%#', 'b'))
iabbrev pymn if __name__ == "__main__":
# 
source ~/.vim/scripts/web_popup.vim


# Global Memory Variable
if !exists('g:memory')
    g:memory = false
endif

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

    # Limit to the last 5 interactions to save token costs/limit
    var recent_logs = logs
    if len(logs) > 5
        recent_logs = logs[-5 : ]
    endif

    var memory_string = "--- CONVERSATION HISTORY ---\n"
    for entry in recent_logs
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
    if g:memory
        append(1, "(Memory: ON)")
    endif
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
    setline(1, $"{prompt}")

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



