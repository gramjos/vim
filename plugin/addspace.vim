vim9script

# vim/plugin/commands.vim

if exists('g:addspaceplug') | finish | endif
g:addspaceplug = 1

# Import the autoload script
import autoload 'addspace.vim'

command! -nargs=1 AddSpace call addspace.AddSpace(<f-args>)
noremap <unique> <script> <Plug>(AddSpaceAbove) <ScriptCmd>AddSpace O<CR>
noremap <unique> <script> <Plug>(AddSpaceBelow) <ScriptCmd>AddSpace o<CR>

if !hasmapto('<Plug>(AddSpaceAbove)')
    nmap <unique> <Leader>k <Plug>(AddSpaceAbove)
    nmap <unique> <Leader>j <Plug>(AddSpaceBelow)
endif
