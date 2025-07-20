" vim run commands(rc). run these commands at the start of each vim instance

" Sections of this RC file:
" Sets
"  - `set`, `autocmd`, `let`, `call`, `highlight`
" Maps
"  - `map`
" Abbreivations
"  - `iabbrev`, `ab`
" Custom func
"  - `function!`

"##########################################################
" Sets
"##########################################################
filetype off                 
set nocompatible						

set undofile " tell it to use an undo file
set undodir=$HOME/.vimundo/ " set a directory to store the undo history

set hlsearch "Search Hightlighting

" New buffer formatting/settings
set ruler               " show line and column number
set relativenumber		" show current line number with surrounding offsets
syntax enable           " syntax highlighting
set showcmd             " show (partial) command in status line
set showmatch			" highlight matching bracket when cursor over it
set number				" static numbering OFF
set tags=./tags;

" Tab/Indent Sizes
set autoindent          " copy indent from current line when 
set smartindent
set shiftwidth=4        " number of spaces to use for auto indent
set tabstop=4           " use 4 spaces to represent tab
" set mouse as clickable. to drag window size of :vert term 
"and when in term mode from insise of vim i can scroll up thru the page not 
" thru the command history
set mouse=nvi
set ls=2 " last status. always_on=2
"turn on visual bell
set noerrorbells
set vb t_vb=
set belloff="all"
" defaults for :sp and :vs respectively 
set splitbelow
set splitright  

" NETRW config
" tree view as default
let g:netrw_liststyle=3
" line numbers in netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'
" Normally, the v key splits the window vertically with the new window and cursor at the left.  To change to splitting the window vertically with the new window and cursor at the right, have    https://vimdoc.sourceforge.net/htmldoc/pi_netrw.html#netrw-v
let g:netrw_altv = 1

" Search down into subfolders
" provides tab completion for all file realted tasks
set path+=**
set encoding=utf-8

" finding files:  Display all matching files when we tab complete
set wildmenu

" Automatically start in insert mode for new files
autocmd BufNewFile * startinsert

let mapleader=" "
" key(s) in use: c d D j k n N o r u U w W ev gc hl pv qv so sp <tab>
"
"	c		comment
"	d		split pane downward shrink small
"	D		split pane downward shrink large
"	g		custom global/substitute function
"	j		add newline below
"	k		add newline above
"	m		popup menu open (M -> close)
"	n		shrink vertical split pane small
"	N		shrink vertical split pane large
"	o	 	pop up dev in ~/.vim./my_pop_ups/p1.vim
"	r		redo last colon command
"	t		fix the common python tab error
"	u		enlarge horizontal split pane small 
"	U		enlarge horizontal split pane large
"	v		visualize the cwd in netrw
"	w		enlarge vertical split pane small
"	W		enlarge vertical split pane large
"	y		global copy. copy uname register to system clipboard
"	ev		open vimrc
"	hl		highlight off
"	pv		open with Preview application
"	qv		open with spacebar (quickview)
"	so		call vim's source on the current buf
"	sp		spellcheck there nearest (going backwards) error
"	<tab>	insert a <tab> character
"	,		pager up (shared key symbol <)
"	.		pager down (shared key symbol >)

"##########################################################
" Maps
"##########################################################
noremap <leader>, Hz-jjj
noremap <leader>. Lztkkk
noremap <leader>hl :nohl<CR>
" Redo last colon command
noremap <leader>r :<Up><CR>

" Split Pane 'quick resize'
" upward - enlarge
noremap <leader>u :res +2<CR> 
noremap <leader>U :res +6<CR> 
" downward - shrink
noremap <leader>d :res -2<CR> 
noremap <leader>D :res -6<CR> 
" wider - enlarge
noremap <leader>w :vert res +2<CR> 
noremap <leader>W :vert res +6<CR> 
" narrower - shrink
noremap <leader>n :vert res -2<CR> 
noremap <leader>N :vert res -6<CR> 

" yank line/selection to sys paste bin, whether in Normal/Visual mode
nnoremap <leader>y :let @*=@0<cr>
vnoremap <leader>y :let @*=@0<cr>

function! QuickPound() abort
	python3 << EOF

import vim, re

# Mapping from filetypes to comment symbols
comment_symbols = { 'sh': '#', 'c': '//', 'python': '#', 'js': '//', 'javascript': '//', 'java': '//', 'vim': '"' }

ft = vim.eval('&filetype')
comment_char = comment_symbols.get(ft, '#')
line = vim.current.line

# Regex to detect a comment at start of line (optional space after symbol)
pattern = re.compile(r'^\s*' + re.escape(comment_char) + r'\s?')

if pattern.match(line):
    # Remove the comment symbol (preserve indentation)
    newline = re.sub(r'^(\s*)' + re.escape(comment_char) + r'\s?', r'\1', line)
    vim.current.line = newline
else:
    # Insert comment symbol after leading indent
    leading_ws_len = len(line) - len(line.lstrip())
    newline = line[:leading_ws_len] + comment_char + ' ' + line[leading_ws_len:]
    # Set the line with comment
    vim.current.line = newline
    # Adjust cursor: if it was after indent, shift it right by length of inserted comment symbol + space
    row, col = vim.current.window.cursor
    if col >= leading_ws_len:
        vim.current.window.cursor = (row, col + len(comment_char) + 1)
EOF

endfunction

nnoremap <leader>c :call QuickPound()<CR>
vnoremap <leader>c :call QuickPound()<CR>

nnoremap <leader>ev :!evr<cr>
nnoremap <leader>so :source %:p<cr>

nnoremap <leader><tab> :call BumpRight()<CR>

function! BumpRight() abort
  let s:saved_line = line('.')
  let s:saved_col = col('.')
  execute "normal! mti\<TAB>\<ESC>`t"
  call cursor(s:saved_line, s:saved_col)
endfunction

" insert upward or downward return while staying in command mode
noremap <leader>j :call AddSpaceDown()<CR>
noremap <leader>k :call AddSpaceUp()<CR>

function! AddSpaceUp() abort
	" save(mark) location
	normal! mz
	" add space above in insert mode
	normal! O
	" jmp back to mark
	normal! `z
	" remove mark
	execute 'delmarks z'
endfunction

function! AddSpaceDown() abort
	" save(mark) location
	normal! mz
	" add space below in insert mode
	normal! o
	" jmp back to mark
	normal! `z
	" remove mark
	execute 'delmarks z'
endfunction

nnoremap <leader>qv :call Qkv()<CR>

function! Qkv()
	let curse_word = expand('<cfile>')
	execute '!qkv' curse_word '&'
endfunction

function! Pkv()
	let curse_word = expand('<cfile>')
	execute '!open -a "Preview" ' curse_word '&'
endfunction

nnoremap <leader>pv :call Pkv()<CR>

" terminal mapping, bufferize sub shell for scroll 
"	(any route to insert mode triggers sub shell)
tnoremap <esc> <C-W>N	

imap ;; <Esc>

"##########################################################
" Abbreviations
"##########################################################
"insert mode abbreviation. get the prev line and put here
iabbr <expr> ^^- getline(search('\S\_.*\n\_.*\%#','b'))

ab pymn if __name__ == "__main__":

