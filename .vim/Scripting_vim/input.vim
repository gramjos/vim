let x = input("name here: ")

" vim treats 0 as false. 
" the return value of confirm() cannot be 0. 1 for Y or 2 N in this case
" tip: check against the return value. confirm() == 2 
if confirm('your name is really '.x.'?', "&Yes\n&No", 1)
	let choices = ['shall i call you: ',
					\ ' 1: '.x,
					\ ' 2: Bruce'
					\]
	let nm = inputlist(choices)

	echo "\n\n chose:" choices[nm]
endif
