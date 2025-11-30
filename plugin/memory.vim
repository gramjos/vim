vim9script

## 
## if &cp || exists('g:loaded_memory')
##     finish
## endif
## g:loaded_memory = 1
## 
## # Import the namespace
## import autoload 'memory.vim'
## 
## # --- User Commands ---
## # command! ConversationModeStatus      call conversationmode.ConversationModeStatus()
## # command! ConversationModeToggle      call conversationmode.ConversationModeToggle()
## command! AskFile      call memory.AskCurrentFile()
## command! AskAll       call memory.AskMultipleFiles()
## command! -range AskSelection call memory.AskSelection()
## 
## # --- Mappings ---
## 
## # 1. Ask File: <leader>af
## nnoremap <silent> <leader>af <Cmd>AskFile<CR>
## 
## # 2. Ask Selection: <leader>as
## # We use <Esc> to update the '< and '> marks before calling the function
## vnoremap <silent> <leader>as <Esc><Cmd>AskSelection<CR>
## 
## # 3. Ask All (Fuzzy): <leader>aa
## nnoremap <silent> <leader>aa <Cmd>AskAll<CR>
