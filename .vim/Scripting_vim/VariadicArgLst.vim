function Fun(...) abort
	for arg in a:000
		call system(printf('cp %s %s.GJ', arg,arg))
	endfor
endfunction

let t_files_before = system('ls *.txt')
echo t_files_before 
call Fun('gogo1.txt','gogo3.txt')
let files_after = system('ls *.txt*')
echo files_after 
