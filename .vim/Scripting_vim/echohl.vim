function! ErrorMsg (msg)
	echohl ErrorMsg
	echo a:msg
	echohl none
	return 1
endfunction
call ErrorMsg('this is wrong!')
