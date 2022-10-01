set ff=unix
set nocompatible						
filetype off                 

let mapleader=" "

" insert upward or downward return while staying in command mode
noremap <leader>j o<esc>
noremap <leader>k O<esc>

nnoremap <leader>ev :!evr<cr>
nnoremap <leader>sv :!source /Users/g_joss/.vimrc<cr>

nnoremap <leader><tab> i<tab><esc>

nnoremap <leader><CR> i<CR><esc>

" terminal mapping, bufferize sub shell for scroll
tnoremap <esc> <C-W>N	

nmap <leader>w viw " Select word

"Search Hightlighting
set hlsearch 
"toggle off highlighting after a search
nnoremap <leader>hl :noh<CR>


" Search down into subfolders
" provides tab completion for all file realted tasks
set path+=**

" Status Bar
"set statusline=

set encoding=utf-8

" finding files:  Display all matching files when we tab complete
set wildmenu

set belloff="all"

:nmap ;e :execute 'next ' . expand('<cfile>')<CR>
"go to file cursor is over (must be a full path)
" a normal mode mapping. when ;e is hit when the cursor is on a path. go to path
" <control> o takes bake to previous buffer. 
" aside :ls to view available buffers. :b _some_buff_

" turn off capitalization 
set spellcapcheck=<CR>

" New buffer formatting/settings
set ruler               " show line and column number
syntax enable           " syntax highlighting
set showcmd             " show (partial) command in status line
set relativenumber		" show current line number with surrounding offsets
set number						" static numbering OFF
set tags=tags				"setting up ctags
" persist code fold
augroup Left_Off
	autocmd BufWinLeave *.*\|.* mkview
	autocmd BufWinEnter *.*\|.* silent loadview
augroup END

" Tab/Indent Sizes
set autoindent          " copy indent from current line when 
						"   starting a new line
set smartindent
set shiftwidth=4        " number of spaces to use for auto indent
set tabstop=4           " use 4 spaces to represent tab

" short cut back to Normal mode 
imap ;; <Esc>

"insert mode abbreviation. get the prev line and put here
iabbr <expr> ^^- getline(search('\S\_.*\n\_.*\%#','b'))

ab pymn if __name__ == "__main__":

" Color Margin
" To standardize width. Make the 81st column magenta 
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn','\%81v',100)
" '\%81v' -> regex "once at the 81st column virtually"

" set mouse as clickable. to drag window size of :vert term 
	" and when in term mode from insise of vim i can scroll up thru the page not
	" thur the command history
set mouse=nvi

" last status. always_on=2
set ls=2

"turn on visual bell
set noerrorbells
set vb t_vb=

" normal mode mapping to 'background' the editor. sends one to terminal. 'fg'
" to bring back
noremap <leader>z  :stop<CR>

" run selected in vimscript
	" the code is hightlghted. 
	" store in register z


xmap vs :call g:VimIt()<CR>

" always turn on .vimrc syntax
"autocmd 

" Move the contents of the unnamed register to the 
	" global clipboard
nnoremap <leader>gc :let @*=@0<cr>


