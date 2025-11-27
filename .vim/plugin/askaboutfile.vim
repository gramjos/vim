vim9script

if &cp || exists('g:loaded_askaboutfile')
    finish
endif
g:loaded_askaboutfile = 1

# Import the namespace
import autoload 'askaboutfile.vim'

# --- User Commands ---
command! LstMod      call askaboutfile.ListModels()
command! SelMod      call askaboutfile.SelectModel()
command! SetMod      call askaboutfile.SetModel()
command! TogMod      call askaboutfile.ToggleModel()
command! AskFile     call askaboutfile.AskCurrentFile()
command! AskAll      call askaboutfile.AskMultipleFiles()
command! -range AskSelection call askaboutfile.AskSelection()

# --- Mappings ---

# Ask File: <leader>af
nnoremap <silent> <leader>af <Cmd>AskFile<CR>

# Ask Selection: <leader>as
# We use <Esc> to update the '< and '> marks before calling the function
vnoremap <silent> <leader>as <Esc><Cmd>AskSelection<CR>

# Ask All (Fuzzy): <leader>aa
nnoremap <silent> <leader>aa <Cmd>AskAll<CR>

# Change Model
nnoremap <silent> <leader>tm <Cmd>TogMod<CR>
nnoremap <silent> <leader>sm <Cmd>SelMod<CR>
