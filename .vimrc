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
g:mapleader = ' '
filetype plugin indent on
packadd! matchit
# time out on mapping after two seconds, time out on key codes after a ninety-ninth
set timeout timeoutlen=2000 ttimeoutlen=99
#
set undofile # tell it to use an undo file
set undodir=/Users/gramjos/.vimundo/ # set a directory to store the undo history
#
# set cursorline
# highlight CursorLine gui=underline cterm=underline guisp=Red
#
# set termguicolors
# highlight LineNr guifg=#7ff4f1
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
set fileformat=unix  # changed from mac 12/29/26
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
# Taken Leader combos aside, use :vimgrep /leader/ ~/.vim/*
### vimgrep
# <Tab> . ? aa af as b c d D ev f fc fd gf hl j k m n N o pv qv r s so sp ss u U vk w W x y
#
# SORT visual selected based on pattern mask      :'<,'>sort /^#\s*/

# Buffer & File Navigation

# f   — Next (forward) buffer.
# b   — Previous buffer.
# gf   — Create the file/directory under the cursor if it doesn't exist, then edit it.
# ev   — Edit .vimrc in a new tab.
# vk   - Edit the_vim_notes.vim in a new tab
# so   — Source (reload) .vimrc.
# fc   — open fzf at cfile
# fd   — open fzf at user input

# System & External Tools

# TODO # m — Copy the last system message (:1messages) to the system clipboard.
# qv — Open current file with external app qkv (via job_start).
# pv — Open current file with external app Preview.
# o — Open the current file path (inside [[...]]) in Obsidian.
# y — Yank current buffer/selection to the system clipboard (* register).
# ? - search normal mode mappings with fzf
# x - run py3do over the selected range line, linenr
# sa - say all
# ss - say selected

# Editing & formatting

# j      — Insert a blank line below the cursor (keeps cursor position).
# k      — Insert a blank line above the cursor (keeps cursor position).
# <Tab>  — Indent the current line (custom macro).
# hl     — Turn off search highlighting (:nohlsearch).
# . 	   — Redo the last Ex command (maps to @:).
# sp     — Fix spelling at current position (jump to bad word, pick first suggestion, jump back).
# ln	 - Toggle line number and relative

# Window Resizing

# u / U — Increase window height (+2 / +6).
# d / D — Decrease window height (-2 / -6).
# w / W — Increase window width (+2 / +10).
# n / N — Decrease window width (-2 / -10).

# AI / AskBot Mappings

# ac — Clear Memory: Deletes the log.json conversation history.
# af — Ask File: Send the entire current file context to Gemini.
# as — Ask Selection: Visual Select
# aa — Ask All: Fuzzy select multiple files (via fzf) to send as context.

# Visual Mode Mappings

# y   — Yank the selected text to the system clipboard.
# as   — Ask Selection: Send only the visually selected text to Gemini.

def EchoSelection()
    var save_reg = getreg('"')
    var save_type = getregtype('"')

    normal! y
    var text = getreg('"')

    # 4. Encase the text into the async job 
    job_start(['say', text])

    setreg('"', save_reg, save_type)
enddef

def SpeakFile()
    # Streams the current buffer directly to 'say'
    # 'bufnr()' gets the ID of the current buffer
    job_start('say', {in_io: 'buffer', in_buf: bufnr()})
enddef

xnoremap <leader>ss <ScriptCmd>EchoSelection()<CR>
nnoremap <leader>s <ScriptCmd>SpeakFile()<CR>
nnoremap <F10> <ScriptCmd>system('pkill say')<CR>

# Search normal mode maps using Space + ?
nmap <Space>? <Plug>(fzf-maps-n)

def BackwardRemind()
    bp
    redraw
    echo ':bp[revious] -> Path: ' .. expand('%:p')
    timer_start(4000, (_) => execute('redraw | echo ""'))
enddef

nnoremap <leader>b <ScriptCmd>BackwardRemind()<CR>

# def BackwardRemind()
    # bp
    # redraw
    # echo ':bp[revious] -> Path: ' .. expand('%:p')
# enddef
# nnoremap <leader>b <ScriptCmd>BackwardRemind()<CR>

# ==========================================================
# Functions 
# ==========================================================

# ==========================================================
# FZF Context Search
# ==========================================================
def g:FzfContext(mode: string)
    var root_dir = ''

    if mode == 'cursor'
        # Get raw string under cursor
        var raw_path = expand('<cfile>')

        # Expand ~ to home and resolve to full absolute path
        var full_path = fnamemodify(raw_path, ':p')

        if isdirectory(full_path)
            # It is a directory, set as root
            root_dir = full_path
        elseif filereadable(full_path)
            # It is a file, get the parent directory
            root_dir = fnamemodify(full_path, ':h')
        else
            echo "No valid path under cursor (Must be Absolute or ~)."
            return
        endif
    else
        # Prompt user for directory
        root_dir = input('Fzf Root: ', '', 'dir')
        # Handle tilde expansion on user input
        root_dir = fnamemodify(root_dir, ':p')
    endif

    if isdirectory(root_dir)
        # Construct FZF options
        # 'dir' sets the root for the search
        var spec = {
            'dir': root_dir,
            'options': ['--preview', 'bat --color=always {}']
        }
        # Run FZF with the wrapped spec
        call fzf#run(fzf#wrap(spec))
    else
        echoerr "Invalid Directory: " .. root_dir
    endif
enddef

# --- FZF Context Mappings ---

# <leader>fc = Fzf Cursor: Scans path under cursor
nnoremap <leader>fc <ScriptCmd>g:FzfContext('cursor')<CR>

# <leader>fd = Fzf Directory: Manually enter path
nnoremap <leader>fd <ScriptCmd>g:FzfContext('input')<CR>

# --- Split Long Lines (>80 chars) ---
# Finds lines longer than 80 chars and formats them individually using 'gqq'
# Preserves the cursor position and view.
def g:SplitLongLines()
  var view = winsaveview()
  # 'silent!' suppresses "Pattern not found" error if the file is already clean
  # 'normal!' ensures we use built-in formatting, ignoring any custom maps
  silent! execute 'g/.\{81\}/normal! gqq'
  winrestview(view)
enddef

# S — Split lines longer than 80 characters (Hard Wrap)
nnoremap <leader>S <Cmd>call g:SplitLongLines()<CR>

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
noremap <leader>so <Cmd>source $MYVIMRC<CR>
nnoremap <leader>ev <Cmd>tabe $MYVIMRC<CR>
nnoremap <leader>vk <Cmd>tabe $MYVIMDIR/the_vim_notes.vim<CR>
# redo last Ex command
nnoremap <leader>. @:
# 
xnoremap <buffer> <leader>x :py3do return f""<Left>

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
imap ;; <Esc>
tnoremap <Esc> <C-W>N
# alt-s
nmap ß :%s//g<Left><Left> 	
# 
# # ==========================================================
# # Abbreviations
# # ==========================================================
iabbr <expr> ^^- getline(search('\\S\\_.*\\n\\_.*\\%#', 'b'))
iabbrev pymn if __name__ == "__main__":
# 
source ~/.vim/scripts/web_popup.vim

nmap <silent> <leader>gf <Plug>(GfCreate)
nmap <silent> <leader>k  <Plug>(AddSpaceAbove)
nmap <silent> <leader>j  <Plug>(AddSpaceBelow)
