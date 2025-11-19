# ~/.vim/scripts/comment_line.py
"""
A script to prepend a hash (#) to each line of text received from stdin.

This script is intended to be called from an external program like Vim.
It reads all input lines, processes each one, and prints the modified lines
to standard output.
"""
import sys

def prepend_hash(line: str) -> str:
    """Adds a '#' character to the beginning of a string."""
    # We strip the trailing newline character that stdin includes,
    # prepend the hash, and then the print() function will add a newline back.
    return f"#{line.rstrip()}"

if __name__ == "__main__":
    # Read all lines from standard input.
    for input_line in sys.stdin:
        modified_line = prepend_hash(input_line)
        # Print the result to stdout.
        # The print() function automatically adds a newline.
        print(modified_line)
