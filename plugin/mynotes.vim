vim9script

#
# plugin/mynotes.vim
#

# Guard against double loading
if exists('g:loaded_mynotes')
    finish
endif
g:loaded_mynotes = 1

# Import the autoload script to get the Toggle function
import autoload 'mynotes.vim'

# Define the target directory constant again for the autocommands
const NOTES_DIR = expand('~/.vim/doc/')

# --- AUTOMATION ---
augroup PersonalNotesSync
    autocmd!
    
    # 1. Auto-Index on Save
    # Only run helptags if the file saved is strictly inside ~/.vim/doc/
    autocmd BufWritePost * if expand('<afile>:p') =~# NOTES_DIR
        | execute 'silent! helptags ' .. NOTES_DIR
        | echo "Tags Indexed"
        | endif

    # 2. Auto-Lock on Open
    # When opening a note file, force it into "View Mode" (Help Type) by default.
    # The check ensures we don't accidentally make your code files read-only.
    autocmd BufReadPost * if expand('<afile>:p') =~# NOTES_DIR
        | setlocal buftype=help
        | setlocal readonly
        | setlocal nomodifiable
        | endif
augroup END

# --- MAPPINGS ---
# Create the command that calls the imported function
command! NoteToggle call mynotes.Toggle()

# Map Leader+e to toggle between Edit/View modes
nnoremap <silent> <leader>e :NoteToggle<CR>
