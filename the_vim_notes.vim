" .vimrc file - vim run commands. 
"               'run these commands at the start of each vim instance'
"
"Sections of this RC file:
"  _+jmp-code			descripion
" help		 		 unimplemented ideas			'_help jumps to this section'
" tempts 		   language templates
"	.py ext
"	.c
"	.java
" abb 				abbreviations
" macro			  recording macro
" fx					vim builtin functions
" 							term, TOhtml, put readfile,
" org 		 		File/buffer Organization
"  win					windows 	
"								resize
"								rotate
"	fold  			code folding
"	tab 				page tabs
"	split 			vertical or horozontal split
"	nav  			  navigation
"	jmp					jumplist
"	find
"	mov					page movement
"					 		 scroll cursor
"						   scroll page
"	mouse				 mouse/cursor use "			
"	edit				Editting section
"		egc				 edit with grouping characters ({["'
"	  s&r			   search and replace
"		cp		     copy pasting yanking to registers
"		d^				Delete 'Special Character' 
"
"		change_wrd
"		bvf				 Buffer View Formatting
"	stat_bar	  Status Bar formatting
"	meta				meta characters
"	
"##########################################################
"	nmc 			  Normal Mode Commands
"	 dict		    adding words to Dictionary
"	 wc				  curretn file stats
"	 ~				  flip letter casing
"		          command history pane
"		          increment number
"
"##########################################################
" cc					Command Line Mode (Colon or Ex Commands) 
"	 dt					 dump terminal results into vim buffer
"	 dig				 Digraphs
"
" term 				vertical split terminal
"##########################################################
"	imc 				Insert mode Commands 
"		replace expression with evaluation
"		escape to do one normal mode commond
" _help TODO
"   - comment box
"   - orginize this buffers table of contents
"   	+ make real jump links
"   - turn on auto insert mode when creating a new buffer
"   - use the qkv alias with a leader mapping to open file
"   		that the cursor is under
" Change Vim's shell from bash to zsh
set shell=/usr/local/bin/zsh

" Status Bar
" _stat_bar
set statusline=
set statusline+=%#DiffAdd#%{(mode()=='n')?'\ \ NORMAL\ ':''}
set statusline+=%#DiffChange#%{(mode()=='i')?'\ \ INSERT\ ':''}
set statusline+=%#DiffDelete#%{(mode()=='r')?'\ \ RPLACE\ ':''}
set statusline+=%#Cursor#%{(mode()=='v')?'\ \ VISUAL\ ':''}
set statusline+=\ %n\           " buffer number
set statusline+=%#Visual#       " colour
set statusline+=%{&paste?'\ PASTE\ ':''}
set statusline+=%{&spell?'\ SPELL\ ':''}
set statusline+=%#CursorIM#     " colour
set statusline+=%R                        " readonly flag
set statusline+=%M                        " modified [+] flag
set statusline+=%#Cursor#               " colour
set statusline+=%#CursorLine#     " colour
set statusline+=\ %t\                   " short file name
set statusline+=%=                          " right align
set statusline+=%#CursorLine#   " colour
set statusline+=\ %Y\                   " file type
set statusline+=%#CursorIM#     " colour
set statusline+=\ %3l:%-2c\         " line + column
set statusline+=%#Cursor#       " colour
set statusline+=\ %3p%%\                " percentage



" :registers to see what is currently being stored
" or :reg
" x"p   
"	paste from reg x

" Leader key - namespace for customised keyboard shortcuts
let mapleader=' '

set encoding=utf-8

" set the dictionary paths. to activate pop-up window. Control xk. 
" Control buton = ^

set dictionary+=/usr/share/dict/web2

" finding files:  Display all matching files when we tab complete
set wildmenu

" always switch to VIM from VI
set nocompatible

set belloff=all

" Templates C Java HTML _tempts 
" create a template for c files
autocmd BufNewFile *.c 0r ~/.vim/templates/c.skel

" † figure out † auto fill in class name same as given filename ___.java
" create a template for java files
autocmd BufNewFile *.java 0r ~/.vim/templates/java.skel

autocmd BufNewFile *.html 0r ~/.vim/templates/html.skel

" Marking
" _mark
" in comand mode :
" 	ma
" 		will mark (m) at (a)
" 	`a
" 		will return you back to that marker (back tick)
"
" ** local markers defined with lower case a-z
" ** global markers use upper case A-Z
" 
"	in command mode:
"		''
"		two single quotes. takes you back to the start of the line of 
"			where you were
"		``
"		two backticks. take you back to the location on the line of 
"			where you were
"	:help mark-motions
"	:help jump-motions

"	
" when opening a text file set spell check on
" In command mode 
"	[s and ]s 
"		will move back and forth, respectively thru misspelled words 
"	z=
"		once cursor on a misspelled word. Brings up options 
"		hit enter w/o a digit to leave options with no change made
"	** once on mispelled word 'short circuit' option selection 
"			1z=   'take first option'
"	zg
"		word the cursors on,add this word to dictionary 
"	zw
"		word the cursors on,delete this word from dictionary 
"
" a normal mode function:
" m  mark this location. the second m is the varible name of the marking
" [s go to previous misspelled word
" 1z= take first suggestion for the misspelled word
" ` go back to a marked location of m
" from https://github.com/christoomey/your-first-vim-plugin/tree/master/spelling-error
function! FixLastSpellingError()
  normal! mm[s1z=`m
endfunction
nnoremap <leader>sp :call FixLastSpellingError()<cr>

autocmd BufNewFile *.txt		set spell spelllang=en_us

" Normal Mode Mapping - spell check for this file
:nmap <F5> :setlocal spell! spelllang=en_us<CR>


"go to file cursor is over (must be a full path)
:nmap ;e :execute 'next ' . expand('<cfile>')<CR>
" a normal mode mapping. when ;e is hit when the cursor is on a path. go to path
" <control> o takes bake to previous buffer. 
" aside :ls to view available buffers. :b _some_buff_

" turn off capitalization 
set spellcapcheck=<CR>

" ruler: displays the line number, the column number, the virtual column 
" number,and the relative position of the cursor in the file (as a percentage)
set ruler               " show line and column number

syntax enable           " syntax highlighting
set showcmd             " show (partial) command in status line
set autoindent          " copy indent from current line when 
						"   starting a new line
set smartindent
set shiftwidth=4        " number of spaces to use for auto indent
set tabstop=4           " use 4 spaces to represent tab
set relativenumber		" show current line number with surrounding offsets
set number				" static numbering OFF

" Snippet
" n     -> Normal Mode. Snippet for when in n
" nore  -> Not Recursive.
" map   -> The key binding function
" <F4>  -> when <F4> is pressed in normal mode
" :-1read ~/pt.txt 
"       read in contents from file with a -1 offset when inputting
" <CR> enter pressed
"when in normal mode hit F4 and it will read in the contents of pt.txt
"nnoremap <F4> :read ~/pt.txt<CR>

" short cut back to Normal mode 
imap ;; <Esc>

" Abbreviations _abb
" insert mode. when 'this' typed replace it with 'that'
"  ab this that
ab hwg here we go	

"insert mode abbreviation. get the prev line and put here
iabbr <expr> ^^- getline(search('\S\_.*\n\_.*\%#','b'))

" python main section. no need for <CR> after colon b/c
	" of usage preferences. i plan to hit <CR> after the
	" n in _pymn_ 
ab pymn if __name__ == "__main__":


" To standardize width. Make the 81st column magenta 
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn','\%81v',100)
" '\%81v' -> regex "once at the 81st column virtually"

" Repeat multiple lines of text at visual block 
" Insert characters into Visual Block
" 	<ctrl>v to enter Visual Blcok mode. After selecting a block
"		press <shift>i then, type the fill in sequence followed
"		<esc> twice
"
"	_nmc
"
"Word Count/Total Words
"	normal mode command g<C>g  "press 'g' then let go, then hold down ^ with 'g' 
"	Col 1 of 34; Line 1 of 415; Word 1 of 1998; Char 1 of 11788; Byte 1 of 11792
"
"Look up manual page for word			_wc
"	when cursor is over the word in normal mode
"		<Shift>k
"		takes you to the manual page
"
" JumpList 			_jmp
" 	 Contains cursor positions
" 	 below are both normal mode commands 
"			g;			 cycle backward thru jumplist
"			g,			 cycle foward thru jumplist
"
"		Buffer Jump List 
"			<ctrl>o
"				go backwards on the buffer jump list
"			<ctrl>i
"				go forewards on the buffer jump list
"				
"
"_win
"Windows
"	<C>w w 		toggle windoes focus
"	<C>w r		rotate windows
"	<C>w n		new horizontally split buffer
"						:new 						
"	Normal mode command _nmc
"		z{n}<CR>
"			where {n} is a positive integer. Increase current window height
"			by n.
"
" fold code lines _fold
" zf#j creates a fold from the cursor down # lines.
" zj moves the cursor to the next fold.
" zk moves the cursor to the previous fold.
" za toggle a fold at the cursor.
" zo opens a fold at the cursor.
" zO opens all folds at the cursor.
" zc closes a fold under cursor. 
" zm increases the foldlevel by one.
" zM closes all open folds.
" zr decreases the foldlevel by one.
" zR decreases the foldlevel to zero -- all folds will be open.
" zd deletes the fold at the cursor.
" zE deletes all folds.
" [z move to start of open fold.
" ]z move to end of open fold.

"Record Macro	_macro
"in normal mode press q then the register to store the macro (n)
"do the series of key then to end macro recording while in normal
"mode press q
"to preform macro @n

"Eddting Section _edit
" .		'to repeat an edit' (period)
" 	in the scenario of going between insert mode and command
" 	(edit) mode. to repeat the most previous set of insert mode commands while
" 	in command(edit) mode
"
"		Editting with grouping chracters _egc
"		Parenthesis, Square Brackets, Curly braces, Quotes
"		d% deletes to the next parenthesis, brackets, braces
"		y% copy 				'		'		'		'
"		ci' change inside the single quotes 
"				or: (,[,{
"
"		_d^
"		In noraml mode, d^  to Delete Backwards til FirstCharOnLine (relative)
"		or d0 delete til the first position on line (absolute)
"		or d| same effects do not know it works
"
"		*NOTE*
"		^, | and 0 are defined as exclusive in Vim
"		dv_		where _ is ^, 0, or | 
"			v is flag for inclusive bounds on motion 

" 	CTRL-u
" 	In insert mode, control u to delete from cursor to beginning of the line

"
"	:%s:\~/Desktop/term_color::g
"		\~/Desktop/term_color
"			using a different delimiter than / fowards slashes helps
"				avoid back slahing hell but still have to escape out of the
"				special ~ tilde character
"
" yanking to registers _cp
"	"kyy 
"		yank full line to reg k
"	"Ky
" 		append highlighted section to reg k
"	"kp
"		paste from reg k
"
"	relative yank from cursor position
"	:-13y
"	relative range yank
"	:+8,+14y		
"		yanks ahead
" :-2,+2y
" 	yank around cursor
"

" Movement:		_mov
" in command mode:
	" <shift>l 		move cursor to bottom of page
	" <shift>h			'	'	   top		 '
	" z. 	adjust scrolling in the frame. cursor to middle of page
	" z-    adjust scrolling in the frame. cursor to bottom of page
	" zt    adjust scrolling in the frame. cursor to top of page

" Split Editor - same file and same edits happen in both panes
" :sp 		horizontal split
" :vs		vertical
" <crt>w 'm'
"	control w then 'm' stands for movement command like hjkl
" :q 		close current pane
" :qa		close all panes

" Tabs for files(buffers)
"	:tabnew [new_buffer(file_name)]
"		creates a new tab(buffer/file)
"
"	in commmand mode with many tabs up
"		gt
"			next tab
"		gT
"			prev tab
"		ngt
"			where n is a number. go to nth tab
"	:qa
"		close all tabs and exit vim
"
 
" Command Mode:
" 	<control> d
" 		decrement page down
" 	<control> u
" 		increment page up
" 
" 	<control> e
" 		decrement line down
" 	<control> y
" 		increment line up
"
"Finding a chracter in the same line _find
" 	f_
" 		where _ is a single character. move cursor to next occurence
" 			of character _ on current line
" 	F_
" 		find backwards
" 	t_
" 		same as f_ but stops cursor a column before
" 	T_
" 	to repeat a find command use semi-colon  ;  
" 
" Deleting while in Command Mode:
" 	lowercase d means delete
" 	d needs to be combined with movment command to know where and to
" 		delete
" 	d will keep you in command mode
" 	de
" 		delete til end of word
" 	db
" 		delete backward til end of word
" 
" Change while in command then leaves you in Insert mode
" 	change c takes movement like d
" 
" <control>r
" 	redo
" 
" Yank y (copy) take a movement command following
" 
" 



" 
" Vim Script Snippets with Functions:		_fx
	" :put =readfile('/path/to/foo/foo.c')[146:226]
	" sorta of like a paste from other file w/in line numbers

"Convert page to HTML
"		:TOhtml
"		save new .html in current directory 

" Terminal 		_term
" :term
" 	emulate a terminal horizontally
" :vert term
"
" :term ls
" 	runs the ls command and puts the output in a buffer
"
"	 Scrolling in new buffered :term 
"	 	^w N	(control w capital n)
"	 	turn the term buffer into a file buffer
"	 	i	character will escape from file buffer view Back to term buffer
"	 	
"	 	tnoremap <Esc> <C-W>N
"	 		'terminal non recursive mapping'




"Select from current buffer and copy into new file
"	:5,50 w newfile 
"			to create a new file containing the text from line 5 to line 50
"
"	:'a,'b w newfile 
"			to create a new file containing the text from mark a to mark b
"	set your marks by using ma and mb where ever you like

" Normal Mode Commands _normal_mode_commands
" Command Line history to appear. Can edit previous commands inside of window
" Normal Mode q: 
"
" The command mode counter for the above command
" 	while in command mode (colon mode) ctrl+f
" 	to bring up previous commands. navigate the line, either execute
" 	that command right away with <enter> or edit then execute
" 
" *** no matter which one enters the command history pane ( from command mode
" or normal) use / to search that list
"
" Normal mode command 
" <control>a over a number will increment it 
"
" ~
" 	tilde will flip the casing of the letter the cursor is on
" 		or flip casing of a highlighted section
"
"Mouse control
" set mouse=a
"			visualy sellect wiht cursor/mouse
"			 adjust window panes with mouse
"
" Insert mode Command _imc
" <Ctrl>k
" 	___S
" 		where the three under scores are characters/digits that wiil
" 			be 'S'uperscripted
" 		*aside* <ctrl>k enters meta charater mode. 
"
"	<Ctrl>r =	
"		"ctrl and r key toegether and then press ="
"		the equal will appear at the command line and proceede to type
"		an arithmetic expression like 2+2  OR a shell call like 
"		system('ls')<enter> and the results are inserted at the cursor in the
"		curtrent buffer  
"
" Leave insert mode to do one normal mode command
" 	<ctrl>o
"
"Registers
"	copy one register contents to another is like variable assignment with let. 
"		:let @"=@*
"			"the unnamed register now has the contents of register *
"			
"		:echo getreg('"')
"		: let @a = getreg('"')
"
"Visual Line mode
" select text then hit colon to enter command mode
" you will see
" 				:'<,'>
" 				this repersents the selected text
"					:'<,'>!python
"					this will execute the selected code snippet and REPLACE
"						the selected with the results of the snippet
"
"Yanking from register to vim command line
"		<C>r reg_ref<CR>
"			after <C>r is hit a double will appear on the vim command line
"				then procede to enter the register refernece 
"				
"Insert mode Command _imc
"	while in insert mode execute ONE normal command and automatically 
"		go back to insert mode.
"		<C>O
"			'control uppercase oh'
"			insert a line above 

" Term information
" 	echo $TERM  -> xterm-color256
" 	
"Help 
"	:helpgrep [search term]
"	this brings you to the first occurenece of [search term] 
"		Broweser thru results use +quickfix commanss
"		to see the list of search results :cwindow
"		
"						
"
"##########################################################
"Command Mode Commands (Ex or Colon Commands)  _cc
"
" Digraphs 			_dig
"  insert special charaters from :dig menu with i_ctrl-k {char}{2}
"  while in insert press control k and a question mark should appear over the
"  cursor position. Type two characters(letter,number,punctuation). The two
"  character codes are on the left side of the blue digraph in the :dig menu
"  9S ⁹  8313 ... zh ㄓ 12563
"
"When working with Meta-charaters
" control v 	"to access meta character mode"
" control m		"inputs " replace m with any meta
"
