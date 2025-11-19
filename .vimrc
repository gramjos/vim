vim9script 

# vim run commands(rc). run these commands at the start of each vim instance
# Folds at:

    # Sets
    #  - `set`, `autocmd`, `let`, `call`, `highlight`
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
# time out on mapping after two seconds, time out on key codes after a ninety-ninth
set timeout timeoutlen=2000 ttimeoutlen=99
#
filetype off                 
set nocompatible                        
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
# Taken Leader combos aside, use :vimgrep /leader/ ~/Computation/vim/.vimrc
# <Tab> bn bp d D ev gf hl j k n N o pv qv r so sp u U w W y


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

# --- Insert Newline without leaving Normal Mode ---
def g:AddSpace(direction: string, mark_char: string = 'z')
  # 1. Create the correct mark specifier string (e.g., "'z").
  var mark_spec = "'" .. mark_char

  # 2. Save the original position of the chosen mark, if it exists.
  var original_mark_pos = getpos(mark_spec)

  # 3. Save the current cursor position to the mark.
  execute $"normal! m{mark_char}"

  # 4. Open a new line and immediately return to Normal mode.
  execute $"normal! {direction}" .. "\<Esc>"

  # 5. Return the cursor to the exact position it was at before adding the line.
  execute $"normal! `{mark_char}"

  # 6. Restore the original mark's position or delete our temporary mark.
  #    A line number of 0 in the position list indicates the mark was not set.
  if original_mark_pos[1] == 0
    # The mark was not set before, so we clean up after ourselves.
    execute $":delmarks {mark_char}"
  else
    # The mark was set, so we restore it to its original position.
    setpos(mark_spec, original_mark_pos)
  endif
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
noremap <leader>so <Cmd>source %<CR>
nnoremap <leader>ev <Cmd>!evr<CR>
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

nnoremap <leader>aa <Cmd>call g:AskAboutFiles()<CR>

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

def g:AskAboutFiles()
    var api_key = g:GetApiKey()
    if empty(api_key)
        return
    endif

    var question = input("Ask about files: ")
    if empty(question)
        echo "Cancelled."
        return
    endif

    # Use fzf to select multiple files. The result is a list of file paths.
    # Note: fzf#run() returns a list of strings directly in Vim9.
    var selected_files: list<string> = fzf#run({
        'source': 'find . -type f -not -path "*/.git/*" -not -path "*/node_modules/*" -not -path "*/__pycache__/*" -not -path "*/venv/*" -not -path "*/.venv/*" -not -path "*/env/*" -not -path "*/vim/view/*" -not -path "*/.vim/view/*"',
        'options': '--multi --prompt="Select files to ask about: "',
    })

    # fzf#run returns an empty list if the user cancels.
    if empty(selected_files)
        echo "No files selected. Cancelled."
        return
    endif

    # --- Capture original buffer info ---
    var original_buf_name = expand('%:p')
    var original_buf_content = getline(1, '$')->join("\n")

    # --- Create the scratch buffer *before* the job ---
    execute 'new'
    setlocal buftype=nofile bufhidden=wipe noswapfile
    setlocal filetype=markdown
    var output_bufnr = bufnr()
    call setline(1, $"[Query: {question}]")
    call append(1, $"[Original Buffer: {original_buf_name}]")
    call append(2, $"[File(s) Selected: {join(selected_files, ', ')}]")
    call append(3, "---")
    execute 'normal! G' # Move to end, ready to stream

    # --- Prepare API request ---
    var prompt_parts: list<string> = []

    # Add original buffer content to the prompt
    if !empty(original_buf_name)
        prompt_parts->add($"File: {original_buf_name} (Current Buffer)\n\n```\n{original_buf_content}\n```")
    endif

    for file_path in selected_files
        if filereadable(file_path)
            var file_content = readfile(file_path)->join("\n")
            prompt_parts->add($"File: {file_path}\n\n```\n{file_content}\n```")
        else
            prompt_parts->add($"File: {file_path}\n\n[Error: Unable to read file]")
        endif
    endfor

    var prompt = prompt_parts->join("\n\n---\n\n") .. $"\n\nQuestion: {question}"

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
