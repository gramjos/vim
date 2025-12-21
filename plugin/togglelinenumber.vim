vim9script

#
# plugin/togglelinenumber.vim
#
# This script is loaded on startup. It sets up the mappings and commands
# for the line number toggling plugin by importing from the autoload script.
#

# Don't load if the plugin is already loaded or in compatible mode
if &cp || exists('g:loaded_togglelinenumber')
    finish
endif
g:loaded_togglelinenumber = 1

# Import the main function from our autoload script.
# The 'togglelinenumber' name is derived from 'autoload/togglelinenumber.vim'.
import autoload 'togglelinenumber.vim'

# Define a user command that can take a range.
# This command calls the imported function.
command! ToggleLineNumber call togglelinenumber.ToggleLineNumber()

# --- Mappings ---
# The mappings now call our command or function via the imported namespace.
# Use the command for both mappings to ensure autoloading works correctly.

nnoremap <silent> <leader>ln :ToggleLineNumber<CR>
