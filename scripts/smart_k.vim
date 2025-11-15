vim9script

command! Ddoc :call SmartK()

def SmartK()
    var script_path = expand('~/.vim/scripts/smart_k.py')

    # Use the system() function to execute the external script.
    # a:text contains the string passed to the function.
    # shellescape() ensures the text is safely passed to the shell.
    var bubble_output = system(script_path)

    # The 'put' command inserts the output below the current line.
    # The '=' register is used to insert the content of a variable.
    execute 'put =bubble_output'
enddef

