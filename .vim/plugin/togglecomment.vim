vim9script

#
# plugin/togglecomment.vim
#
# This script is loaded on startup. It sets up the mappings and commands
# for the comment toggling plugin by importing from the autoload script.
#

# Don't load if the plugin is already loaded or in compatible mode
if &cp || exists('g:loaded_togglecomment')
    finish
endif
g:loaded_togglecomment = 1

# Import the main function from our autoload script.
# The 'togglecomment' name is derived from 'autoload/togglecomment.vim'.
import autoload 'togglecomment.vim'

# Define a user command that can take a range.
# This command calls the imported function.
command! -range ToggleCommentRange call togglecomment.ToggleComment(<line1>, <line2>)

# --- Mappings ---
# The mappings now call our command or function via the imported namespace.
# Use the command for both mappings to ensure autoloading works correctly.
nnoremap <silent> <leader>c :ToggleCommentRange<CR>
vnoremap <silent> <leader>c :ToggleCommentRange<CR>
