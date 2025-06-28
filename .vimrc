set nocompatible						
filetype off                 

" tell it to use an undo file
set undofile
" set a directory to store the undo history
set undodir=/home/gramjos/.vimundo/

"  _   _      _ _         __        __         _     _
" | | | | ___| | | ___    \ \      / /__  _ __| | __| |
" | |_| |/ _ \ | |/ _ \    \ \ /\ / / _ \| '__| |/ _` |
" |  _  |  __/ | | (_) |    \ V  V / (_) | |  | | (_| |
" |_| |_|\___|_|_|\___/      \_/\_/ \___/|_|  |_|\__,_|
" +-------------+
" |  |
" +-------------+


let mapleader=" "
" key(s) in use:
"	c d D j k n N o r u U w W ev gc hl pv qv so sp <tab>
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
"	u		enlarge horizontal split pane small "	U		enlarge horizontal split pane large
"	v		visualize the cwd in netrw
"	w		enlarge vertical split pane small
"	W		enlarge vertical split pane large
"	ev		open vimrc
"	gc		global copy. copy uname register to system clipboard
"	hl		highlight off
"	pv		open with Preview application
"	qv		open with spacebar (quickview)
"	so		call vim's source on the current buf
"	sp		spellcheck there nearest (going backwards) error
"	<tab>	insert a <tab> character

" View the current working directory in netrw
" nnoremap <leader>v e %:h<CR>
"					 E<CR>

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
" noremap <leader>z :stop<CR> " now just ctrl-z to throw to background

" Move the contents of the unnamed register to the 
" global clipboard
nnoremap <leader>gc :let @*=@0<cr>

" yank line/selection to sys paste bin, whether in Normal/Visual mode
nnoremap <leader>y :let @*=@0<cr>
vnoremap <leader>y :let @*=@0<cr>

nnoremap <leader>c :call QuickPound()<CR>
vnoremap <leader>c :call QuickPound()<CR>

" <option>s		
nmap  ß  :%s//g<LEFT><LEFT>

let s:comment_symbols = {
	\ 'sh': '#',
	\ 'c': '//',
	\ 'python': '#',
	\ 'js': '//',
	\ 'javascript': '//',
	\ 'java': '//',
	\ 'vim': '"'
\ }

function! QuickPound() abort
	let l:ft = &filetype
	let l:comment = get(s:comment_symbols, l:ft, '#')
	" Escape special regex characters in the comment string. If parametere 2
	" is in parameter 1 then place slash before it '\'
	let l:escaped_comment = escape(l:comment, '/\.*$^~[]')
	let l:line = getline('.') " current line content
	" line starts with optional whitespace followed by the comment symbol.
	let l:comment_pat = '^\s*' . l:escaped_comment . '\s\?'
	" regex compare -> Does this line start with a comment?
	if l:line =~ l:comment_pat
		" TRUE there exist a comment symbol so lets remove it
		" matches:
		" 'start-of-line', capture group , comment symbol, optional space
		let l:extract_comment_pat = '^\(\s*\)' . l:escaped_comment . '\s\?'
		" It removes the constructed regex pat to match the appropriate
		" comment symbol. 
		let l:newline = substitute(l:line, l:extract_comment_pat, '\1', '')
		call setline('.', l:newline)
	else
		" Preserve the cursor location while inserting the comment symbol.
		normal! mp
		execute 'normal! I' . l:comment . ' '
		normal! `p
	endif
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

nnoremap <leader>sp :call FixLastSpellingError()<CR>

" Normal Mode Mapping - spell check for this file
:nmap <F5> :setlocal spell! spelllang=en_us<CR>

" insert upward or downward return while staying in command mode
nnoremap <leader>qv :call Qkv()<CR>

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

" NETRW config
" tree view as default
let g:netrw_liststyle=3
" line numbers in netrw
let g:netrw_bufsettings = 'noma nomod nu nobl nowrap ro'

" Change Vim's shell from bash to zsh
set shell=/bin/zsh

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

" Setting for Help Searching
" 
""""""""""""""""""""""""""""

" skel Templates C Java HTML
autocmd BufNewFile *.c 0r ~/.vim/templates/c.skel

autocmd BufNewFile *.java 0r ~/.vim/templates/java.skel

autocmd BufNewFile *.html 0r ~/.vim/templates/html.skel

" FixLastSpellingError() fx + map
function! FixLastSpellingError()
	normal! mm[s1z=`m
endfunction

autocmd BufNewFile *.txt set spell spelllang=en_us

function! Qkv()
	let curse_word = expand('<cfile>')
	execute '!qkv' curse_word '&'
endfunction

function! Pkv()
	let curse_word = expand('<cfile>')
	execute '!open -a "Preview" ' curse_word '&'
endfunction

nnoremap <leader>pv :call Pkv()<CR>


:nmap ;e :execute 'next ' . expand('<cfile>')<CR>
"go to file cursor is over (must be a full path)
" a normal mode mapping. when ;e is hit when the cursor is on a path. 
" go to path. Same as the builtin `gf`

" <control> o takes bake to previous buffer. 
" aside :ls to view available buffers. :b _some_buff_

" turn off capitalization 
set spellcapcheck=<CR>

" New buffer formatting/settings
set ruler               " show line and column number
set relativenumber		" show current line number with surrounding offsets
syntax enable           " syntax highlighting
set showcmd             " show (partial) command in status line
set showmatch			" highlight matching bracket when cursor over it
set number						" static numbering OFF
set fileformat=mac
"set tags=tags				"setting up ctags
set tags=./tags;
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

" imap section: _imap
" short cut back to Normal mode 
imap ;; <Esc>

autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType python set omnifunc=python3complete#Complete

"insert mode abbreviation. get the prev line and put here
iabbr <expr> ^^- getline(search('\S\_.*\n\_.*\%#','b'))

ab pymn if __name__ == "__main__":

" Color Margin
" To standardize width. Make the 81st column magenta 
" highlight ColorColumn ctermbg=LightGreen 
" call matchadd('ColorColumn','\%80v')
" '\%81v' -> regex "once at the 81st column virtually"

highlight FindMe ctermbg=green guibg=green gui=bold
call matchadd("FindMe", "Graham Joss")


" set mouse as clickable. to drag window size of :vert term 
"and when in term mode from insise of vim i can scroll up thru the page not 
" thru the command history
set mouse=nvi

" last status. always_on=2
set ls=2

"turn on visual bell
set noerrorbells
set vb t_vb=


" defaults for :sp and :vs respectively 
set splitbelow
set splitright   

" Graham's Global Command
" A mix betweeen the global command and the substitute. Should really
" acheieved with a slash search and then quickfix menu manipulation.
" BUG: when pattern match in the on the top lines of the buffer it will not be
" scrolled to.
" Usage: :call DeleteMatchingLinesConfirm('<pattern>')
" function! DeleteMatchingLinesConfirm(pattern)
function! D()
  " Prompt user for a regex pattern.
  let l:pattern = input('Enter regex: ')
  if empty(l:pattern)
    echo "No regex provided."
    return
  endif
  " Escape any slashes in the pattern.
  let l:escaped = escape(l:pattern, '/')
  " Highlight all matches using the Search highlight group.
  execute 'match Search /' . l:escaped . '/'
  redraw! " Force a screen redraw before starting the loop
  " Iterate backwards to avoid skipping lines when deleting.
  for lnum in reverse(range(1, line('$')))
    let line_text = getline(lnum)
    if line_text =~ l:pattern
      " --- Scroll and center the matching line ---
      redraw!            " Clear any messages that may shrink the text area
      call cursor(lnum, 1)
      normal! zz         " Center the line in the window
      redraw!            " Make sure the display is updated
      " --- Ask for deletion confirmation ---
      let ans = confirm("Delete: (line no. " . lnum . ") " . line_text, "&Yes\n&No")
      redraw!            " Clear any leftover messages from the confirm
      if ans == 1
        " Delete the matching line.
        execute lnum . 'delete'
        call cursor(lnum, 1)
        normal! zz
        redraw!
	  endif
    endif
  endfor
  " Clear highlighting and redraw one final time.
  match none
  redraw!
endfunction

" Map the function to <leader>g in normal mode.
nnoremap <leader>g :call D()<CR>

" pop up dev separate
" Variable added to the global namespace;
" job_output, popup_id, cur_job
source /Users/gramjos/.vim/my_pop_ups/p1.vim
nnoremap <leader>m :call OpenPopup()<CR>
nnoremap <leader>M :call ClosePopup()<CR>

" `say`
function! SpeakVisualSelection()
    silent '<,'>!say
    let &modifiable = l:save_modifiable
endfunction

" vnoremap <leader>x :set modifiable|'<,'>!say|set nomodifiable<CR>
" vnoremap <leader>x :set ma<CR>:'<,'>!say<CR>:set noma<CR>
" Visual mode mapping to invoke the function on selection
" Visual mode mapping to invoke the function on selection
vnoremap <leader>x :<C-u>call StartScriptJob()<CR>

" Function definition
function! StartScriptJob() range
  " Save original register to restore later
  let l:original_reg = getreg('"')
  let l:original_regtype = getregtype('"')

  " Yank visual selection into register x
  normal! gv"xy

  " Get the content of register x (the visual selection)
  let l:selected_text = getreg('x')

  " Log selected text with timestamp to :messages
  call LogSelection(l:selected_text)

  " Start the shell command as a detached job
  call job_start(['zsh', '-c', GetShellCommand(l:selected_text)])
endfunction

" Helper function to log messages with timestamp
function! LogSelection(selection)
  let l:timestamp = strftime("%Y-%m-%d %H:%M:%S")
  echom printf('[%s] Selection: %s', l:timestamp, a:selection)
endfunction

function! GetShellCommand(selection)
  " URL-encode spaces and special characters
  let l:encoded_selection = substitute(a:selection, '\s', '+', 'g')

  " Construct curl command clearly
  let l:curl_cmd = 'curl "https://search.brave.com/search?q=' . l:encoded_selection . '&source=desktop" | vi -'

  " Create the AppleScript command (tell Terminal to open and run the curl command)
  let l:apple_script = 'tell application "Terminal"
        \ to do script "' . l:curl_cmd . '"'

  " Escape for shell execution
  let l:escaped_script = shellescape(l:apple_script)

  " Final zsh command to execute
  return 'sleep 1; osascript -e ' . l:escaped_script
endfunction

func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc

" HTML helpers
iabbrev divid <div id=""></div><ESC>2F"a<C-R>=Eatchar('\s')<CR>
iabbrev divcl <div class=""></div><ESC>2F"a<C-R>=Eatchar('\s')<CR>

" Help in new Terminal window
function! OpenHelpInNewTerminal(topic)
python3 << EOF
import subprocess
import vim

topic = vim.eval('a:topic')
apple_script = f'''
tell application "Terminal"
    do script "vim -c 'help {topic}' -c 'only'"
end tell
'''
subprocess.run(["osascript", "-e", apple_script])
EOF
endfunction

command! -nargs=1 Hw call OpenHelpInNewTerminal(<q-args>)

" Open help in a new tab
command! -nargs=1 Ht execute 'tab help' <q-args>

" Robustly run shell command, insert stdout at cursor
function! Qs(...) abort
    if a:0 < 1
        echoerr "Provide at least 1 word as shell command"
        return
    endif
    let cmd = join(a:000, ' ')
	echom cmd
    let output = split(system(cmd), "\n")
    if v:shell_error
        echoerr "Shell error occurred: " . cmd
        return
    endif
    call append(line('.') - 1, output)
endfunction

" Concise custom command
command! -nargs=+ Qs call Qs(<f-args>)
