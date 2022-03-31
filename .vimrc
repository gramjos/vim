"Vundle packager setup
set nocompatible							" always switch to VIM from VI
filetype off                 
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	" alternatively, pass a path where Vundle should install plugins
	"call vundle#begin('~/some/path/here')
	Plugin 	'VundleVim/Vundle.vim'
	Plugin	'metakirby5/codi.vim'
cal vundle#end()
filetype plugin on

"testing for double leader namspace

" Leader key - namespace for customised keyboard shortcuts
let mapleader=' '

nnoremap <leader><tab> i<tab><esc>

"Search Hightlighting
set hlsearch 
"toggle off after a search
nnoremap <leader>hl :noh<CR>

" NETRW config
" tree view as default
let g:netrw_liststyle=3
" line numbers in netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" Change Vim's shell from bash to zsh
set shell=/usr/local/bin/zsh

" Search down into subfolders
" provides tab completion for all file realted tasks
set path+=**

" Status Bar
"set statusline=

set encoding=utf-8

" set the dictionary paths. to activate pop-up window. Control xk. 
" Control buton = ^
set dictionary+=/usr/share/dict/web2

" finding files:  Display all matching files when we tab complete
set wildmenu

set belloff="all"

" skel Templates C Java HTML
autocmd BufNewFile *.c 0r ~/.vim/templates/c.skel

autocmd BufNewFile *.java 0r ~/.vim/templates/java.skel

autocmd BufNewFile *.html 0r ~/.vim/templates/html.skel

" FixLastSpellingError() fx + map
function! FixLastSpellingError()
  normal! mm[s1z=`m
endfunction
nnoremap <leader>sp :call FixLastSpellingError()<CR>

autocmd BufNewFile *.txt		set spell spelllang=en_us

" Normal Mode Mapping - spell check for this file
:nmap <F5> :setlocal spell! spelllang=en_us<CR>

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
autocmd BufWinLeave *.*\|.* mkview
autocmd BufWinEnter *.*\|.* silent loadview

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

function g:VimIt()
	y
	@0
endfunction

xmap vs :call g:VimIt()<CR>

" always turn on .vimrc syntax
"autocmd 

" Move the contents of the unnamed register to the 
	" global clipboard
nnoremap <leader>gc :let @*=@0<cr>
