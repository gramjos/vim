vim9script

# Mappings for Normal and Visual mode to call the comment toggling function.
nnoremap <leader>c <ScriptCmd>QuickToggleComment()<CR>
vnoremap <leader>c <ScriptCmd>QuickToggleComment()<CR>

def QuickToggleComment()
    # Define a mapping from filetype to its comment symbol.
    const comment_symbols: dict<string> = {
        sh: '#',
        c: '//',
        python: '#',
        js: '//',
        javascript: '//',
        java: '//',
        vim: '"',
    }

    # Determine the comment string for the current filetype, defaulting to '#'.
    # &filetype is a direct way to access the filetype option.
    const comment_str = get(comment_symbols, &filetype, '#')
    const comment_leader = comment_str .. ' '
    # Escape the comment string for use in regular expressions.
    const escaped_comment_str = escape(comment_str, '\')

    # Get the line range. For Normal mode, it's just the current line.
    # For Visual mode, it's the range from the visual start ('<) to end ('>) marks.
    var [start_line, end_line] = [line("'<"), line("'>")]
    # The call is from Normal mode if the mode is not Visual ('v', 'V', or 'CTRL-V').
    if mode() !~# '[vV\x16]'
        start_line = line('.')
        end_line = line('.')
    endif

    # Process each line in the determined range.
    for lnum in range(start_line, end_line)
        var line_content = getline(lnum)
        # Find the first non-whitespace character to determine indentation.
        const indent_len = indent(lnum)
        const indented_line = line_content[indent_len :]

        # Check if the line is already commented by seeing if it matches the
        # comment string at the beginning (after indentation).
        if match(indented_line, '^' .. escaped_comment_str) == 0
            # Line is commented, so uncomment it.
            # substitute() finds and replaces the comment leader.
            # '\s*' handles any space between the comment symbol and the code.
            const replacement_pattern = '\v\s*' .. escaped_comment_str .. '\s*'
            line_content = substitute(line_content, replacement_pattern, '', '')
        else
            # Line is not commented, so add a comment.
            # We preserve the original indentation by substituting at the start
            # of the non-whitespace part of the line.
            line_content = substitute(line_content, '\v\S', comment_leader .. '\0', '')
        endif
        # Update the line in the buffer.
        setline(lnum, line_content)
    endfor
enddef
