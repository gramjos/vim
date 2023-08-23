set relativenumber		" show current line number with surrounding offsets
set ff=unix
set nocompatible						
filetype off                 
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
	Plugin 	'VundleVim/Vundle.vim'
	Plugin	'metakirby5/codi.vim'
cal vundle#end()
filetype plugin on

" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=/home/yourname/.vimundo/

let mapleader=" "
" key(s) in use:
"	c d D j k n N r u U w W z ev gc hl pv qv so sp <tab>

" Redo last colon command
noremap <leader>r :<Up><CR>

" quick resize
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

" normal mode mapping to 'background' the editor. sends one to terminal. 'fg'
" to bring back
noremap <leader>z :stop<CR>

" Move the contents of the unnamed register to the 
	" global clipboard
nnoremap <leader>gc :let @*=@0<cr>

" yank line/selection to sys paste bin, whether in Normal/Visual mode
nnoremap <leader>y :let @*=@0<cr>
vnoremap <leader>y :let @*=@0<cr>

" quick pound sign - mark at r, front of line in insert (I) mode, enter
"	# character then back to normal mode, jump to mark r
" quick pound for visually selected area
function! QuickPound() abort
	:execute 's/^/#/g | noh'
endfunction
nnoremap <leader>c :call QuickPound()<CR>
vnoremap <leader>c :call QuickPound()<CR>

" insert upward or downward return while staying in command mode
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

noremap <leader>j :call AddSpaceDown()<CR>
noremap <leader>k :call AddSpaceUp()<CR>

nnoremap <leader>ev :!evr<cr>
nnoremap <leader>so :source %:p<cr>

nnoremap <leader><tab> i<tab><esc>

" terminal mapping, bufferize sub shell for scroll 
"	(any route to insert mode triggers sub shell)
tnoremap <esc> <C-W>N	

"Search Hightlighting
set hlsearch 
"toggle off highlighting after a search
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
" add a relative search path for find commands (start searching from current
" dir)

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

autocmd BufNewFile *.txt set spell spelllang=en_us

" Normal Mode Mapping - spell check for this file
:nmap <F5> :setlocal spell! spelllang=en_us<CR>

function! Qkv()
  let curse_word = expand('<cfile>')
  execute '!qkv' curse_word '&'
endfunction

nnoremap <leader>qv :call Qkv()<CR>

function! Pkv()
  let curse_word = expand('<cfile>')
  execute '!open -a "Preview" ' curse_word '&'
endfunction

nnoremap <leader>pv :call Pkv()<CR>


:nmap ;e :execute 'next ' . expand('<cfile>')<CR>
"go to file cursor is over (must be a full path)
" a normal mode mapping. when ;e is hit when the cursor is on a path. 
" go to path

" <control> o takes bake to previous buffer. 
" aside :ls to view available buffers. :b _some_buff_

" turn off capitalization 
set spellcapcheck=<CR>

" New buffer formatting/settings
set ruler               " show line and column number
syntax enable           " syntax highlighting
set showcmd             " show (partial) command in status line
" set relativenumber		" show current line number with surrounding offsets
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

" python specific format from PEP 8 
au BufNewFile,BufRead *.py
    \ set tabstop=4 |      
    \ set softtabstop=4|
    \ set shiftwidth=4|
    \ set textwidth=79|
    \ set noexpandtab|
    \ set autoindent|
    \ set fileformat=unix

" short cut back to Normal mode 
imap ;; <Esc>

"insert mode abbreviation. get the prev line and put here
iabbr <expr> ^^- getline(search('\S\_.*\n\_.*\%#','b'))

ab pymn if __name__ == "__main__":

" Color Margin
" To standardize width. Make the 81st column magenta 
highlight ColorColumn ctermbg=LightGrey
call matchadd('ColorColumn','\%80v')
" '\%81v' -> regex "once at the 81st column virtually"

highlight FindMe ctermbg=green guibg=green
call matchadd("FindMe", "Graham Joss")


" set mouse as clickable. to drag window size of :vert term 
  "and when in term mode from insise of vim i can scroll up thru the page not 
  " thur the command history
set mouse=nvi

" last status. always_on=2
set ls=2

"turn on visual bell
set noerrorbells
set vb t_vb=


" defaults for :sp and :vs respectively 
set splitbelow
set splitright   


nnoremap <leader>m :call GetUserInput()<cr>

function! GetUserInput()
  let input = input("!!;Enter an integer: ")
  let doubled_input = input * 2
  echo "The doubled input is: " . doubled_input
endfunction


" Step 1: Create the visual mode mapping
xnoremap <leader>i :call RunPython()<cr>

" Step 2: Define the RunPython() function
function! RunPython() abort 
endfunction 



