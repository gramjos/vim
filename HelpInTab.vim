" Open Help in Docs in a Tab
function! g:HelpInTab()
	let help_term = input('Help in: ')
	exe ":tab help " help_term
endfunction

call HelpInTab()

" command -nargs=+ Bedit call BackupAndEdit(<f-args>)
" the above line above make the function a custom vim commandline command
" -nargs=+  means the Bedit function can take one or more arguments from the 
" command line
" <f-args> means to pass BackupAndEdit all the arguments passed at the command
	"		line

