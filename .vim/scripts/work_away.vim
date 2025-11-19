" ~/.vim/scripts/work_away.vim
" Demonstrate non-blocking async functions. 

function! g:WorkAway() abort
	let g:output = '' " store NL (line by line)
	function! CaptureOutput(channel, msg)
		let g:output .=  a:msg .. "|"
		echo g:output .. ' ::str'
		let @* = g:output
	    echo "Job exited with status: " . a:msg
	    echo "Final Output: " . g:output
	endfunction
	let job = job_start(["/bin/zsh", "-c",
		  \	"/Users/g_joss/hi.shell"], {
		  \ 'noblock': 1,
		  \ 'exit_cb': function('CaptureOutput')
		  \ })
	echo "starting..."
	let g:jid = job_status(job)
	echo g:jid
	echo g:output
endfunction
