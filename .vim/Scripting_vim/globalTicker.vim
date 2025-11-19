echo "edit started: ".strftime("%c")

let g:tp = 0 

function Vim_exe()
	let g:tp += 1
endfunction

let n = input('how many calls? (integer)')
for i in range(n)
	call Vim_exe()
endfor

echo "total times tcikered ".tp
unlet tp
