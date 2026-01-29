vim9script

# vim/plugin/commands.vim

if exists('g:loaded_custom_commands') | finish | endif
g:loaded_custom_commands = 1

# Import the autoload script
import autoload 'gfcreate.vim'

# --- GfCreate ---
# 1. Define Command
command! GfCreate call gfcreate.GfCreate()
# 2. Expose Plug
noremap <unique> <script> <Plug>(GfCreate) <ScriptCmd>GfCreate<CR>
# 3. Default Map
if !hasmapto('<Plug>(GfCreate)')
    nmap <unique> <Leader>gf <Plug>(GfCreate)
endif
