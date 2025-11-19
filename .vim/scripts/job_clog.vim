" ~/.vim/scripts/job_clog.vim

function! g:JobClog() abort

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
		  \ 'exit_cb': function('CaptureOutput')
		  \ })
	echo "starting..."
	let g:jid = job_status(job)
	echo g:jid
	while g:jid == 'run'
		let g:jid = job_status(job)
		sleep 40m
	endwhile
	echo g:jid
	echo g:output

endfunction
