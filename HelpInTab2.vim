 "
 " Open Help in Docs in a Tab
function! g:HelpInTab() abort 
		let help_term = input('Help in: ') 
		exe ":tab help " help_term
endfunction 

debug call HelpInTab()


