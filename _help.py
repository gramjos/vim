##################################################
#
#	From .vimrc
##################################################
import vim, re

# Mapping from filetypes to comment symbols
comment_symbols = {
    'sh': '#', 'c': '//', 'python': '#',
    'js': '//', 'javascript': '//', 'java': '//', 'vim': '"'
}

ft = vim.eval('&filetype')
comment_char = comment_symbols.get(ft, '#')
line = vim.current.line

# Regex to detect a comment at start of line (optional space after symbol)
pattern = re.compile(r'^\s*' + re.escape(comment_char) + r'\s?')

if pattern.match(line):
    # Remove the comment symbol (preserve indentation)
    newline = re.sub(r'^(\s*)' + re.escape(comment_char) + r'\s?', r'\1', line)
    vim.current.line = newline
else:
    # Insert comment symbol after leading indent
    leading_ws_len = len(line) - len(line.lstrip())
    newline = line[:leading_ws_len] + comment_char + ' ' + line[leading_ws_len:]
    # Set the line with comment
    vim.current.line = newline
    # Adjust cursor: if it was after indent, shift it right by length of inserted comment symbol + space
    row, col = vim.current.window.cursor
    if col >= leading_ws_len:
        vim.current.window.cursor = (row, col + len(comment_char) + 1)
