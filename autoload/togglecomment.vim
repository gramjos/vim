vim9script

#
# autoload/togglecomment.vim
#
# Core logic for the comment toggling plugin.
# Functions are loaded on-demand.
#

# Define comment characters for different file types.
# This is a script-local constant.
const comment_map = {
    \ 'python': '#',
    \ 'javascript': '//',
    \ 'typescript': '//',
    \ 'vim': '#',
    \ 'sh': '#',
    \ 'ruby': '#',
    \ 'go': '//',
    \ 'rust': '//',
    \ 'html': '<!--,-->',
    \ 'c': '//',
    \ 'cpp': '//',
    \ 'java': '//',
    \ 'lua': '--',
    \ 'perl': '#',
    \ 'php': '//',
    \ 'default': '#',
    \ }

# Internal helper function to toggle a single line.
# It does not need to be exported.
def ToggleLine(line: string, comment_char: string): string
    if line =~ '^\s*$'
        return line
    endif

    # Check if this is a paired comment (e.g., HTML: <!--,-->)
    if comment_char =~ ','
        var parts = split(comment_char, ',')
        var start_comment = parts[0]
        var end_comment = parts[1]
        return ToggleLinePaired(line, start_comment, end_comment)
    endif

    # Check if the line starts with the comment character (ignoring leading whitespace)
    if line =~ '^\s*' .. escape(comment_char, '/\')
        # Remove comment character and one optional space
        return substitute(line, '^\(\s*\)' .. escape(comment_char, '/\') .. '\s\?', '\1', '')
    else
        # Add comment character and a space
        # We'll preserve indentation by finding the first non-whitespace character
        var indent = matchstr(line, '^\s*')
        var rest = strpart(line, strlen(indent))
        return indent .. comment_char .. ' ' .. rest
    endif
enddef

# Helper function to toggle paired comments (e.g., HTML <!-- -->)
def ToggleLinePaired(line: string, start_comment: string, end_comment: string): string
    var indent = matchstr(line, '^\s*')
    var rest = strpart(line, strlen(indent))

    # Check if line is already commented (starts with start_comment and ends with end_comment)
    var start_pattern = '^' .. escape(start_comment, '/\.*[]') .. '\s\?'
    var end_pattern = '\s\?' .. escape(end_comment, '/\.*[]') .. '\s*$'

    if rest =~ start_pattern && rest =~ end_pattern
        # Remove both comment markers
        var uncommented = substitute(rest, start_pattern, '', '')
        uncommented = substitute(uncommented, end_pattern, '', '')
        return indent .. uncommented
    else
        # Add comment markers
        return indent .. start_comment .. ' ' .. rest .. ' ' .. end_comment
    endif
enddef

# The main function that will be called by the plugin.
# We `export` it so it can be imported by other scripts.
export def ToggleComment(start_line: number, end_line: number)
    var comment_char = comment_map->get(&filetype, comment_map['default'])

    for lnum in range(start_line, end_line)
        var current_line = getline(lnum)
        var new_line = ToggleLine(current_line, comment_char)
        setline(lnum, new_line)
    endfor
enddef
