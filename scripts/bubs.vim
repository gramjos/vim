command! -nargs=+ Bubble :call BubbleFont(<q-args>)
" Define the function that does the work.
function! BubbleFont(text)
    " Define the path to your Python script.
    " '~' is expanded to your home directory.
    let script_path = expand('~/.vim/scripts/mk_ascii.py')

    " Use the system() function to execute the external script.
    " a:text contains the string passed to the function.
    " shellescape() ensures the text is safely passed to the shell.
    let bubble_output = system(script_path . ' ' . shellescape(a:text))

    " The 'put' command inserts the output below the current line.
    " The '=' register is used to insert the content of a variable.
    execute 'put =bubble_output'
endfunction

