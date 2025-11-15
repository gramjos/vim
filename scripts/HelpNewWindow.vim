vim9script

#
# Help in a new Terminal window (Vim9script, no Python)
#
# This script provides a command to open a Vim help topic in a new terminal
# window. It is designed for macOS and uses AppleScript to interact with the
# Terminal.app.
#

# Define the function that will open the new terminal
def OpenHelpInNewTerminal(topic: string)
  # Construct the vim command to be executed in the new terminal.
  # This command starts vim, opens the help for the given topic, and then
  # makes that help buffer the only window.
  var vim_command = $"vim -c 'help {topic}' -c 'only'"

  # Construct the AppleScript command.
  # We use shellescape() on the vim_command to ensure that any special
  # characters in the topic (like spaces or quotes) are properly handled
  # by the shell.
  var apple_script = $'tell application "Terminal" to do script {shellescape(vim_command)}'

  # Construct the final shell command to be executed.
  # This command runs 'osascript' to execute the AppleScript string.
  var shell_command = ['osascript', '-e', apple_script]

  # Execute the command using Vim's built-in system() function.
  # This is the modern, Python-free way to run external shell commands.
  system(shell_command)

  # Redraw the screen. Creating the new terminal window can sometimes leave
  # visual artifacts on the original Vim window, and this cleans them up.
  redraw!
enddef

# Define the user-facing command :Hw
# -nargs=1 means it accepts exactly one argument.
# <q-args> passes the argument to the function.
# The 'def' keyword creates the command in the current script's scope.
command -nargs=1 Hw def OpenHelpInNewTerminal(<q-args>)
