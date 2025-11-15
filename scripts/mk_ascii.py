#!/usr/bin/env python3
# -*- coding: utf-8 -*-

"""
mk_ascii.py: A command-line utility for converting alphanumeric strings
into multi-line bubble letter ASCII art.

Data Structure:
A dictionary, BUBBLE_MAP, maps characters to their ASCII representations.
Using raw, triple-quoted strings (r\"\"\"...\"\"\") allows for direct
embedding of ASCII art without character escaping.

Algorithm:
1.  Input string is received via command-line arguments.
2.  For each character in the input string, its corresponding multi-line
    ASCII art is retrieved from BUBBLE_MAP.
3.  Each character's art is split into a list of lines.
4.  The lines are transposed: the first line of the output is a
    concatenation of the first line of each character's art, the second
    line is a concatenation of all second lines, and so on.
5.  The resulting list of concatenated lines is joined into a single
    multi-line string and printed to standard output.
"""

import sys

# Data mapping for alphanumeric characters to bubble font representation.
# All characters are designed with a consistent height (5 lines) and
# a consistent width (6 columns) for predictable alignment.

BUBBLE_MAP = {
    ' ': r"""
 


""",
    '_default': r"""
 ??
 ??
""",
    'a': r"""
 ▗▄▖
▐▌ ▐▌
▐▛▀▜▌
▐▌ ▐▌
""",
'b':r"""
▗▄▄▖
▐▌ ▐▌
▐▛▀▚▖
▐▙▄▞▘
""",
'c':r"""
 ▗▄▄▖
▐▌
▐▌
▝▚▄▄▖
""",
'd':r"""
▗▄▄▄
▐▌  █
▐▌  █
▐▙▄▄▀
""",
'e':r"""
▗▄▄▄▖
▐▌
▐▛▀▀▘
▐▙▄▄▖
""",
'f':r"""
▗▄▄▄▖
▐▌
▐▛▀▀▘
▐▌
""",
'g':r"""
 ▗▄▄▖
▐▌
▐▌▝▜▌
▝▚▄▞▘
""",
'h':r"""
▗▖ ▗▖
▐▌ ▐▌
▐▛▀▜▌
▐▌ ▐▌
""",
'i':r"""
▗▄▄▄▖
  █
  █
▗▄█▄▖
""",
'j':r"""
   ▗▖
   ▐▌
   ▐▌
▗▄▄▞▘
""",
'k':r"""
▗▖ ▗▖
▐▌▗▞▘
▐▛▚▖
▐▌ ▐▌
""",
'l':r"""
▗▖
▐▌
▐▌
▐▙▄▄▖
""",
'm':r"""
▗▖  ▗▖
▐▛▚▞▜▌
▐▌  ▐▌
▐▌  ▐▌
""",
'n':r"""
▗▖  ▗▖
▐▛▚▖▐▌
▐▌ ▝▜▌
▐▌  ▐▌
""",
'o':r"""
 ▗▄▖
▐▌ ▐▌
▐▌ ▐▌
▝▚▄▞▘
""",
'p':r"""
▗▄▄▖
▐▌ ▐▌
▐▛▀▘
▐▌
""",
'q':r"""
▗▄▄▄▖
▐▌ ▐▌
▐▌ ▐▌
▐▙▄▟▙▖
""",
'r':r"""
▗▄▄▖
▐▌ ▐▌
▐▛▀▚▖
▐▌ ▐▌
""",
's':r"""
 ▗▄▄▖
▐▌
 ▝▀▚▖
▗▄▄▞▘
""",
't':r"""
▗▄▄▄▖
  █
  █
  █
""",
'u':r"""
▗▖ ▗▖
▐▌ ▐▌
▐▌ ▐▌
▝▚▄▞▘

""",
'v':r"""
▗▖  ▗▖
▐▌  ▐▌
▐▌  ▐▌
 ▝▚▞▘
""",
'w':r"""
▗▖ ▗▖
▐▌ ▐▌
▐▌ ▐▌
▐▙█▟▌
""",
'x':r"""
▗▖  ▗▖
 ▝▚▞▘
  ▐▌
▗▞▘▝▚▖
""",
'y':r"""
▗▖  ▗▖
 ▝▚▞▘
  ▐▌
  ▐▌
""",
'z':r"""
▗▄▄▄▄▖
   ▗▞▘
 ▗▞▘
▐▙▄▄▄▖
""",
'0':r"""
▄▀▀▚▖
█  ▐▌
█  ▐▌
▀▄▄▞▘
""",
'0':r"""
█
█
█
█
""",
'2':r"""
▄▄▄▄
   █
█▀▀▀
█▄▄▄
""",
'2':r"""
▄▄▄▄
   █
▀▀▀█
▄▄▄█
""",
'4':r"""
▄  ▗▖
█  ▐▌
▀▀▀▜▌
   ▐▌
""",
'5':r"""
▄▄▄▄
█
▀▀▀█
▄▄▄█
""",
'6':r"""
▄▄▄▄
█
█▀▀█
█▄▄█
""",
'7':r"""
▗▄▄▄▖
   ▐▌
   ▐▌
   ▐▌
""",
'8':r"""
▄▄▄▄
█  █
█▀▀█
█▄▄█
""",
'9':r"""
▄▄▄▄
█  █
▀▀▀█
▄▄▄█
""",
'.':r"""



▄
""",
',':r"""



▄
▞
"""
}


def generate_bubble_text(text: str) -> str:
    """
    Converts an input string to a multi-line ASCII bubble letter string.

    Args:
        text: The string to convert.

    Returns:
        A multi-line string containing the ASCII art.
    """
    # Normalize input to lowercase
    text = text.lower()

    # Split each character's ASCII art into lines.
    # Use a default character for any unsupported characters.
    # The initial strip() removes leading/trailing whitespace from the map definition.
    lines_by_char = [
        BUBBLE_MAP.get(char, BUBBLE_MAP['_default']).strip('\n').split('\n')
        for char in text
    ]

    # Find the maximum height required for any character.
    # This ensures proper alignment if characters have different heights.
    max_height = max(len(lines) for lines in lines_by_char) if lines_by_char else 0

    # Pad each character's lines to the max_height.
    # Find the width of each character to pad shorter lines correctly.
    for i, lines in enumerate(lines_by_char):
        width = max(len(line) for line in lines) if lines else 0
        while len(lines) < max_height:
            lines.append(' ' * width)
        lines_by_char[i] = [line.ljust(width) for line in lines]


    # Transpose the data: group by line number.
    # The result is a list where each element is a complete line of the final output.
    output_lines = [
        " ".join(char_lines[i] for char_lines in lines_by_char)
        for i in range(max_height)
    ]

    return "\n".join(output_lines)


def main():
    """
    Entry point for the script.
    Processes command-line arguments and prints the bubble text.
    """
    # Ensure at least one argument (the text to convert) is provided.
    if len(sys.argv) < 2:
        print("Usage: python mk_ascii.py \"<text to convert>\"", file=sys.stderr)
        sys.exit(1)

    # Join all arguments into a single string.
    input_text = " ".join(sys.argv[1:])
    bubble_output = generate_bubble_text(input_text)
    print(bubble_output)


if __name__ == "__main__":
    main()
