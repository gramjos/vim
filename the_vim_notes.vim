"##########################################################
" Notes
"##########################################################
" Generate the jump tags (underscore prefix notion) for current file
" :.!grep -oE '\s_[a-z&]+\s' % | sort -u | column | expand

" Jump List File Navigation 

" Sets and Options: _sets
" 	_spell

" Automations Scripting Builtin Fx: 
" 	_tempts insert code boiler plate
" 	_py _pyv
" 	_term terminal _redir redirect command output
" 	_sh shell _prof profile performace
"  	_macro _put 

" Edit: _edit _e
" 	_ap append _s&r search&replace _mc multi cursor
"	_g global _read _cos close _y yank _reg register
"	_w write  _imc insert mode commands _dig digraphs

" Buffer Organization Aesthetics Formatting: 
" 	_fold code fold _pytab _form format lines
"	_ve virtual edit _split
"
" Buffer Navigation:
" 	_chnglst change list _h help _mov motins _f find
" 	_netrw _win windows _jmp jump list
" 	_tab _mark _tags
"
" Plugins:
" 	_fzf _tag

" Tags waiting to sort
" _mes            _pyv            
" _gx             
" _wc
" _norc           
"##########################################################
" _TODO
"##########################################################
" - visualize buffer size with clickable zoom to page features. Relative to the
"   current buffer dimensions, a new split appears off to the side that is a
"   data visualiation of the bytes/words per page (page size relative to
"   current buffer). The data visualization schema is, for each line in the
"   new split buffer proportionaly repersents each pages bytes and words. 
" - 'pop current buffer out'  into new terminal window or tab
" - after `:'<,'>w~/new-file.vim` (new file made) the help string
"   ""~/.vim/plugin/gfcreate.vim" [New] 16L, 450B written" appears in the mes
" 	area. Goal: goto to the newly created file. verify the new file with
" 	`:mes` or normal mode command q:
"   - comment box
"   - organize this buffers table of contents
"   	+ make real jump links
"   - turn on auto insert mode when creating a NEW buffer
"		- write a mapping to delete the current the file and exit
"		- a session for note taking and todos 
"	- integrate a popup window with a `fzf` as new `find` command to look for
"	arbitrary files
"##########################################################
" View the current working directory in netrw
:E<CR>
" Vertical, Side
:Vex[plore]
:Sex[plore]

" _imc Insert Mode Command 
"
" <Ctrl>c
" while in insert mode execute ONE normal command and automatically go back to
" insert mode 
"		<C>o___		where the 3 '_'are the normal mode command
"	example:
"		<C>oO
"			'control oh uppercase oh'
"			insert a line above 
" _h Help 
:helpgrep [search term]
"	this brings you to the first occurenece of [search term] 
"		To browse thru results use +quickfix commands
"	to see the list of search results :cwindow
"-----------------------------------------------------------------------------
" Prefix	|Example		|Context
"		:	|:h :r		|ex command (command starting with a colon)
" 	none	|:h r		|normal mode
"	v_		|:h v_r		|visual mode
"	i_		|:h i_CTRL-W	|insert mode
"	c_		|:h c_CTRL-R	|ex command line
"	/		|:h /\r		|search pattern (in this case, :h \r also works)
"	'		|:h 'ro'		|option
"	-		|:h -r		|Vim argument (starting Vim)
"-----------------------------------------------------------------------------
"	^ chart source https://vim.fandom.com/wiki/Learn_to_use_help
"
" _e _h Edit and Help
" In the scenario, where I execute 
:e foo.txt 
" and in the current i made	changes that are not saved yet the error: 
" 'E37: No write since last change (use ! to override)'
" will appear. to look up error message:
:h E37

" _.! Shell command output
" insert the standard out of <cmd> into current buffer buffer where cursor is
:.!<cmd>

" pretty print json in current buffer
:%!jq .
" Breakdown:
" "   %      Selects the entire file (all lines).
" "   !      Runs the selection through an external command.
" "   jq .   Runs jq with the simplest filter (.), which just outputs the formatted JSON.
"
" _dig Digraphs 			
"  insert special charaters from :dig menu with i_ctrl-k {char}{2}
"  while in insert press control k and a question mark should appear over the
"  cursor position. Type two characters(letter,number,punctuation). The two
"  character codes are on the left side of the blue digraph in the :dig menu
"  9S ⁹  8313 ... zh ㄓ 12563  
" aside, sub super script are intuitive big s for super and little s for sub
"  ²₂2

"Enter meta character (digraph) mode with 
" <Ctrl>k
"then, below denotes the format to pick specific character 
" 	___S
" 		where the three under scores are characters/digits that wiil
" 			be 'S'uperscripted
" while in insert mode <ctrl>k wait for cursor to change then RF
" ▤ 
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

"When working with Meta-charates
"In insert mode:
" control v 	"to access meta character mode" " control m		"inputs " replace m with any meta
" 
" _prof Profiling Performace 
"	displays what files are sourced at vim's startup
:sciptnames
"
" _py Python's Vim API. only py3 is installed not py or py
:py3do 			
" do python expression every line with builtins like line number
" and line contents (line,linenr)
"
" Example:
'<,'>py3do return "%s\t%d" % (line[::-1], len(line))
" or with modern f string 
'<,'>py3do return f"here: {line[::-1]}, {len(line)}"

" _pyv Python with Visual Line mode
" select text then hit colon to enter command mode
" you will see
:'<,'>
"	this repersents the selected text
:'<,'>!python
"	this will execute the selected code snippet and REPLACE
"		the selected with the results of the snippet
"
import math; print(math.pi);
import math;
print(math.pi);
3.141592653589793
"
" _redir _mes Re-Direct Mes
" Below is a one liner to filter the mes
:redir => g:vim_messages | silent messages | redir END | let g:message_lines = split(g:vim_messages, "\n") | put =g:message_lines[-2]

	:redir => g:vim_messages |
	"	declare locally and ephemerally (temporarily) to write all messages to a global variable `vim_messages`
	silent messages |
	"	then 'mock' call the messages function with silent on, so the actual messages do not get displayed.
	redir END | 
	"	Then 'END' the redirecting of the messages. 
	let g:message_lines = split(g:vim_messages, "\n") 
	" Then split the string by newline into a list of strings. 
	put =g:message_lines[-2]
	" slice out a mes
	"
" Last message mes_
:echo v:statusmsg

" _norc 
"	$ vi -u NONE
"	temporarily start vim with a blank user. this creates a runtime that
"		ignores: runtime commands (.vimrc) and (.vim)

" _mc Multiple Cursor
" Repeat multiple lines of text at visual block 
" Insert characters into Visual Block
" 	<ctrl>v to enter Visual Blcok mode. After selecting a block
"		press <shift>i then, type the fill in sequence followed
"		<esc> twice

" _ap
" Append
" Append selection to a file that already exists
:'<,'>w >> file

" Write and create 
" write to file that does NOT exist yet
:'<,'>w file

"##########################################################
" Options and Sets _sets
"##########################################################
" to toggle a set option just end with a bang '!'
:set cursorline		# turn on
:set cursorline!	# toggle option

" _pytab Common Python Identation error
" fixing the python indentation error
:set listchars=tab:>-,trail:-,nbsp:
:set list
" the above pair of commands dislpays those hidden character
:set invlist
" invert to undo
" search and replace to fix botch files
:%s/\t/    /g
" also try 
:retab

" Formatting Issue: meta character ^M replaces newlines...
:%s/\r/\r/g

" Term information
echo $TERM  
" -> xterm-color256
" Virtual Edit _ve 
" visual select strictly tabular
set ve=block
" To standardize width. Make the 81st column magenta 
highlight ColorColumn ctermbg=magenta
call matchadd('ColorColumn','\%81v',100)
" '\%81v' -> regex "once at the 81st column virtually"
" turn off capitalization 
set spellcapcheck=<CR>
" ruler: displays the line number, the column number, the virtual column 
" number,and the relative position of the cursor in the file (as a percentage)
set ruler               " show line and column number
syntax enable           " syntax highlighting
set showcmd             " show (partial) command in status line
set autoindent          " copy indent from current line when starting a new line
set smartindent
set shiftwidth=4        " number of spaces to use for auto indent
set tabstop=4           " use 4 spaces to represent tab
set relativenumber		" show current line number with surrounding offsets
set number				" static numbering OFF
" _sh Change Vim's shell from bash to zsh
set shell=/usr/local/bin/zsh
" Leader key - namespace for customised keyboard shortcuts
let mapleader=' '
set encoding=utf-8
" set the dictionary paths. to activate pop-up window. Control xk. 
" Control buton = ^
set dictionary+=/usr/share/dict/web2
" finding files:  Display all matching files when we tab complete
set wildmenu
" the below is in-efficient
" like :tabe [file] (or :find, :sfind, gf, etc.) and the file is not in the current directory,
" Vim searches for that file in all directories listed in your 'path'. removed inreal vimrc
set path+=.,,**,./**,../**
" always switch to VIM from VI
set nocompatible
set belloff=all
"##########################################################
" Auto Commands
"##########################################################
" Templates C Java HTML _tempts 
" create a template for c files
autocmd BufNewFile *.c 0r ~/.vim/templates/c.skel
" Replaces the empty buffer with the output of a shell command.
autocmd BufNewFile *.html 0r ~/.vim/templates/html.skel
autocmd BufNewFile *.java 0r ~/.vim/templates/java.skel
" † figure out † auto fill in class name same as given filename ___.java
" create a template for java files: FIGURED
autocmd BufNewFile *.java execute '%!cat ~/.vim/templates/java.skel | sed "s/CLASSNAME/' . expand('%:r') . '/g"'
" filter the entire (%) buffer thru the command !{cmd} 
	%!cat ~/.vim/templates/java.skel |
" globally replace the hardcoded `CLASSNAME' for the file name
	sed "s/CLASSNAME/' . expand('%:r') . '/g"'

"##########################################################
" Maps
"##########################################################

" # Builtin/Default #

" normal mode mapping to 'background' the editor. sends one to terminal. 'fg'
" to bring back, but now just ctrl-z to throw to background
noremap <leader>z :stop<CR> 

" _wc Counting Col,Ln,Wrd,Byte
" Get the word count, lines, and bytes of current file or selection while in normal
" mode. 
" 	- When you have something selected in normal mode, press g then control g
" 	- W/o selection then whole file.
" Example mes printed
"	Col 1 of 34; Line 1 of 415; Word 1 of 1998; Char 1 of 11788; Byte 1 of 11792

" _gx call the system `open` on the path the cursor is on. 

" _y Yank

" Yanking from register to vim command line or while in insert mode _imc
"		<Crtl>r reg_ref<CR>
"			after <Ctrl>r is hit a double will appear on the vim command line
"				then procede to enter the register refernece 


" _reg Registers
" to see what is currently being stored
:registers 
:reg
:display
"	copy one register contents to another is like variable assignment with let. 
"		:let @"=@*
"			"the unnamed register now has the contents of register *
"			
"		:echo getreg('"')
"		: let @a = getreg('"')
"
" yank the word the curosr is over into register 8
" NOTE the leading double below is part of the builtin normal mode mapping
		"8yw

" 8"p   
"	paste from reg x with 'hot keys'

" _put Put
" place contents of register 4 where cursor is
:put 4

" _put Vim Script Snippets with Functions:		
	" :put =readfile('/path/to/foo/foo.c')[146:226]
	" sorta of like a paste from other file w/in line numbers
" _read Read
" put the standard output of cmd one line below the cursor
:read!{cmd}
:read!date

" Want to do a read the hard way?
" Robustly run shell command, insert stdout at cursor
function! Qs(...) abort
    if a:0 < 1 " an integer that holds the total count of arguments passed to the function.
        echoerr "Provide at least 1 word as shell command"
        return
    endif
    let cmd = join(a:000, ' ') " a List containing all the arguments passed to the function
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

" _mark Marking
" in normal mode:
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
" when opening a text file set spell check on with <F5>
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

"##########################################################
" Maps
"##########################################################

" # User Defined #

" Pager with with a three line context buffer
noremap <leader>, Hz-jjj
" H		Move cursor to top.
" z-	Re-orient page, make curosr the bottom of page
" j{n}	Basic movement. 3 lines down.
noremap <leader>. Lztkkk

" the native equivalent:
" Page Down	<C-f> (Control-F)	Scrolls forward (down) one full screen.
" Page Up	<C-b> (Control-B)	Scrolls backward (up) one full screen.
" Half Page Down	<C-d> (Control-D)	Scrolls down a half screen.
" Half Page Up	<C-u> (Control-U)	Scrolls up a half screen.
" Line Scrolling	<C-e> (Control-E)	Scrolls the screen one line down (eel up).
" <C-y> (Control-Y)	Scrolls the screen one line up (eye down).


" Snippet
" n     -> Normal Mode. Snippet for when in n
" nore  -> Not Recursive.
" map   -> The key binding function
" <F4>  -> when <F4> is pressed in normal mode
" :-1read ~/pt.txt 
"       read in contents from file with a -1 offset when inputting
" <CR> enter pressed
"when in normal mode hit F4 and it will read in the contents of pt.txt
nnoremap <F4> :read ~/pt.txt<CR>


" short cut back to Normal mode 
imap ;; <Esc>

"##########################################################
" Abbreviations
"##########################################################
" NOTE: insert mode abbreviations add an extra space as a known bug. Use the
" built-in helper Eatchar 'eat character'    
func Eatchar(pat)
  let c = nr2char(getchar(0))
  return (c =~ a:pat) ? '' : c
endfunc
" insert mode. when 'this' typed replace it with 'that'
"  ab this that
ab hwg here we go	

"insert mode abbreviation. get the prev line and put here
iabbr <expr> ^^- getline(search('\S\_.*\n\_.*\%#','b'))

" python main section. no need for <CR> after colon b/c
	" of usage preferences. i plan to hit <CR> after the
	" n in _pymn_ 
ab pymn if __name__ == "__main__":

" Spell Checker _spell
"
" a normal mode function:
" m  mark this location. the second m is the varible name of the marking
" [s go to previous misspelled word (aside, ]s next mispelled word)
" 1z= take first suggestion for the misspelled word
" ` go back to a marked location of m
" from https://github.com/christoomey/your-first-vim-plugin/tree/master/spelling-error
function! FixLastSpellingError()
  normal! mm[s1z=`m
endfunction
nnoremap <leader>sp :call FixLastSpellingError()<cr>

autocmd BufNewFile *.txts set spell spelllang=en_us

" Normal Mode Mapping - spell check for this file
:nmap <F5> :setlocal spell! spelllang=en_us<CR>

" quick open and put process in the backgorund
function! Qkv()
  let curse_word = expand('<cfile>')
  execute '!qkv' curse_word '&'
endfunction

nnoremap <leader>qv :call Qkv()<CR>

function! Pkv()
  let curse_word = expand('<cfile>')
  execute '!open -a "Preview" ' curse_word '&'
endfunction

"	Two ways to skin a cat: 1.) builtin  2.) nmap
"	jump to an editor session for the file that the cursor is on
"go to file cursor is over (must be a full path)
:nmap ;e :execute 'next ' . expand('<cfile>')<CR>
" a normal mode mapping. when ;e is hit when the cursor is on a path. go to path
" <control> o takes bake to previous buffer. 
" aside :ls to view available buffers. :b _some_buff_
" 
"
"
"	when cursor is over the word in normal mode
"		<Shift>k
"		takes you to the manual page
"
" _chnglst Change List
" 	 Contains cursor positions
" 	 below are both normal mode commands 
"			g;			 cycle backward thru edit list
"			g,			 cycle foward thru edit list

" JumpList 			_jmp
"  To view the jump list :ju
"		Buffer Jump List 
"			<ctrl>o
"				go backwards on the buffer jump list go
"			<ctrl>i
"				go forewards on the buffer jump list
"			NOTE can use a number as a range to move N many positions up or
"			down the jump list

" Jump V. Change Disambiguation 
" 	Jump: cursor history
" 	Change: edit history
"
"_win
"Windows
"	<C>w w 		toggle windoes focus
"	<C>w r		rotate windows
"	<C>w n		new horizontally split buffer
"						:new 						
"
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

" _form Re-Formmat Lines
" 	visual select the lines then the normal sequence gw to adjust trailing
" 	lines. 

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
"		Editting with grouping chracters 
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

"_s&r
"	Search and replace Example. In this case, replace with nothing
"	:%s:\~/Desktop/term_color::g
"		deletes the string (happens to be a file path)
"		~/Desktop/term_color
"			using a different delimiter(:) than / fowards slashes helps
"				avoid back slahing hell but still have to escape out of the
"				special ~ tilde character
"
" _y
" yanking to registers 
"	"kyy 
"		yank full line to reg k
"	"Ky
" 		append to reg k
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
" :-5,y
" 	yank everything from 5 line back to current line
"
" _g
" Global (g) command - 
" Execute a command in range that matches a pattern
"
" search and delete lines that match pattern
" :g/\/\/.*$/d
" 	the above pattern matches any lines that contain a double forward slash
" Instead of `d` for deleted is be any Ex command found here :help ex-cmd-index

" _mov Movement:		
" in command mode:
	" }  jump to next white space
	" <shift>l 		move cursor to bottom of page
	" <shift>h			'	'	   top		 '
	" z. 	adjust scrolling in the frame. cursor to middle of page
	" z-    adjust scrolling in the frame. cursor to bottom of page
	" zt    adjust scrolling in the frame. cursor to top of page

" Old ideas...
" there is a built in for paging.... find it! it is a control plus somethig...but which mode??
noremap <leader>, Hz-jjj
" or the native Ctrl-b without the 3 line context
noremap <leader>. Lztkkk
" or the native Ctrl-f without the 3 line context
" Normal Mode Half-Pager
" d for down
" Ctrl-d
" u for up
" Ctrl-u

" _split Split Editor - same file and same edits happen in both panes
" horizontal split
:sp
"
" : sp <file>
" 		creates new file in a split pane
" 		or type % the tab to auto complete from current path
"
" " defaults for :sp and :vs respectively 
" set splitbelow
" set splitright   

:sf 
" split find. split pane and find file/dir
"
:tabfind
"
" Rotate the split tabs vert to hort or vice versa
" To change two vertically split windows to horizonally split:
" Ctrl-w t Ctrl-w K
" 
" Horizontally to vertically:
" Ctrl-w t Ctrl-w H
"
" Got form two panes (vert or hort) to two tabs
" Ctrl-w T

" :vs		vertical
" <crt>w 'm'
"	control w then 'm' stands for movement command like hjkl

" _cos Close Vim Ex/colon command
" close current pane
:q
" close all panes
:qa
" Close from Normal Mode
" ZZ	double capital z will soft close a named file
" ZQ 	force close 

" _tab Tabs for files(buffers)
:tabnew [new_buffer(file_name)]
"		creates a new tab(buffer/file)
"
"	in commmand mode with many tabs up
"		gt
"			next tab
"		gT
"			prev tab
"		ngt
"			where n is a number. go to nth tab
"
:tab sb <buffListItem>
" 	open buffer in new tab
 
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
" _f Finding a chracter in the same line 
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
" <control>r
" 	redo

" Convert page to HTML
"		:TOhtml
"		save new .html in current directory 

" _term Terminal 		
:term
" 	emulate a terminal horizontally
:vert term
"
:term ls
" 	runs the ls command and puts the output in a buffer
"
"	 Scrolling in new buffered :term 
"	 	^w N	(control w capital n)
"	 	turn the term buffer into a file buffer
"	 	i	character will escape from file buffer view Back to term buffer
"	 	
 tnoremap <Esc> <C-W>N
"	 		'terminal non recursive mapping'
"
" _w 
" Select from current buffer and copy into new file
:5,50 w newfile 
"			to create a new file containing the text from line 5 to line 50
"
:'a,'b w newfile 
"			to create a new file containing the text from mark a to mark b
"	set your marks by using ma and mb where ever you like

" Normal Mode Command
" q: Command Line history to appear. Can edit previous commands inside of window
"
" The command mode counter for the above command
" 	while in command mode (colon mode) ctrl+f
" 	to bring up previous commands. navigate the line, either execute
" 	that command right away with <enter> or edit then execute
" 
" *** no matter which one enters the command history pane ( from command mode
" or normal) use / to search that list
"
" Normal mode command _nmc
"		z{n}<CR>
"			where {n} is a positive integer. Increase current window height
"			by n.
"
" _nmc Normal mode command 
" <control>a over a number will increment it 
" <control>x			'''						decrement 3
"
" Sequential Increment over visual block
" https://httpbin.org/delay/1
" https://httpbin.org/delay/1
" https://httpbin.org/delay/1
" https://httpbin.org/delay/1
" https://httpbin.org/delay/1
" Once at the 1 column is visually(block) selected g<CTRL>a
"
" ~
" 	tilde will flip the casing of the letter the cursor is on
" 		or flip casing of a highlighted sectionn
"
" Netrw _netrw
" 	netrw is for readig, writing files over  a network
" 		and you just entered a random file to go back to the file explorer view enter the Ex command :E[xplore]
" File Management
" d 	Create Directory: Prompts for a new directory name.
" % 	Create File: Prompts for a new filename.
" R 	Rename: Rename the file/directory under the cursor.
" D 	Delete: Delete the file/directory (requires confirmation).
" 
" Navigation & "Zooming"
" <CR> 	Open: Enter directory or open file.
" - 	Up: Go up one directory level.
" c 	Make Root: Set current directory as the browsing root (CWD).
" gn 	Zoom In: Make the directory under cursor the top of the tree.
" u 	History: Go back to the previously browsed directory.
" 
" Opening Files
" p 	Preview: Open file in a preview window (cursor stays in netrw).
" t 	Tab: Open file/directory in a new tab.
" v 	V-Split: Open file/directory in a vertical split.
" o 	H-Split: Open file/directory in a horizontal split.
" 
" View Customization
" i 	Cycle View: Thin → Long → Wide → Tree.
" s 	Sort: Cycle sorting by Name → Time → Size → Extension.
" r 	Reverse: Reverse the current sort order.
" a 	Hiding: Toggle hiding of files matching g:netrw_list_hide.
" Ctrl-l 	Refresh: Redraw the directory listing.
"
" Marking & Bulk Actions
" mf 	Mark: Mark the file/directory under the cursor.
" mu 	Unmark: Remove marks from all files.
" mt 	Target: Set the target directory for copy/move operations.
" mc 	Copy: Copy marked files to the target directory.
" mm 	Move: Move marked files to the target directory.
"
" 	the built-in mapping `cd` will change the current working directory 
" 	(NetrwTreeListing) to the directory of the curosr line. Then a colon 
" 	command to start a terminal at the `NetrwTreeListing` directory

" ctags
" given my project for vanilla web dev
" $ tree
" .
" ├── data
" │   ├── bnsf_rail.geojson
" │   └── pro_pic.jpg
" ├── index.html
" ├── js
" │   ├── app.js
" │   ├── basemap-control.js
" │   ├── charts-panel.js
" │   ├── landing-page.js
" │   ├── modal-info.js
" │   ├── table-interactions.js
" │   └── table-resize.js
" ├── package.json
" ├── README.md
" ├── server.js
" ├── styles.css

" Run this command to generate a 'tags' file

$ ctags -R --languages=JavaScript,HTML,CSS --exclude=node_modules --exclude=dist --exclude=.git --exclude='*.geojson' -exclude='*.jpg'
" $ ctags -R --languages=JavaScript,HTML,CSS \
"   --exclude=node_modules \
"   --exclude=dist \
"   --exclude=.git \
"   --exclude='*.geojson' \
"   --exclude='*.jpg'

" _tags
" see all tags 
:edit $VIMRUNTIME/doc/tags

" _fzf
" Switch buffer
:Buffers

" Project text search (ripgrep)
:Rg someFunctionName

" Interactive “search as you type” ripgrep
:RG

" Search within current buffer
:BLines

" Search across all open buffers
:Lines

" Jump to any window across tabs
:Windows

" Fullscreen:
:Windows!

" Update v. Redraw
:update " deals with File I/O (Data Persistence).
	" Executes only if the buffer has been modified (&modified is set)

:redraw  " deals with Screen Rendering (Visual Display).

