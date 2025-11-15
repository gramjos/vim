vim9script

if &cp || exists('g:loaded_askaboutfile')
    finish
endif
g:loaded_askaboutfile = 1

# Import the main function from our autoload script.
# The 'togglecomment' name is derived from 'autoload/togglecomment.vim'.
import autoload 'askaboutfile.vim'

# Define a user command that can take a range.
# This command calls the imported function.
command! -range ASK call askaboutfile.AskAboutFile()

# --- Mappings ---
# The mappings now call our command or function via the imported namespace.
# Use the command for both mappings to ensure autoloading works correctly.
nnoremap <silent> <leader>af :ASK<CR>
