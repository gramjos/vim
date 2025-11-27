vim9script

if &cp || exists('g:loaded_askaboutfile')
    finish
endif
g:loaded_askaboutfile = 1

# Import the namespace
import autoload 'askaboutfile.vim'

# --- User Commands ---
command! AskFile      call askaboutfile.AskCurrentFile()
command! AskAll       call askaboutfile.AskMultipleFiles()
command! -range AskSelection call askaboutfile.AskSelection()

# --- Mappings ---

# 1. Ask File: <leader>af
nnoremap <silent> <leader>af <Cmd>AskFile<CR>

# 2. Ask Selection: <leader>as
# We use <Esc> to update the '< and '> marks before calling the function
vnoremap <silent> <leader>as <Esc><Cmd>AskSelection<CR>

# 3. Ask All (Fuzzy): <leader>aa
nnoremap <silent> <leader>aa <Cmd>AskAll<CR>
