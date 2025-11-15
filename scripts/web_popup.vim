vim9script

# In Vim9, 'var' at the script level is script-local by default.
var url_popup_id = 0

def ToggleUrlPopup()
	echo "Calling the Webs"
    if popup_getpos(url_popup_id) != {}
        popup_close(url_popup_id)
        url_popup_id = 0
        return
    endif # --- If the popup does not exist, proceed to create it ---
    
    if !executable('curl')
        echohl ErrorMsg
        echo "Error: This functionality requires 'curl'. Please install it."
        echohl None
        return
    endif

    var url = 'https://gramjos.github.io/'
    var html_content_str = system($'curl -sL {url}')
    var content_lines = split(html_content_str, '\n')

    if empty(content_lines)
        echohl ErrorMsg
        echo $'Error: Failed to fetch or received empty content from {url}'
        echohl None
        return
    endif

    var current_width = winwidth(0)
    var current_height = winheight(0)
    var popup_width = float2nr(current_width * 0.8)
    var popup_height = float2nr(current_height * 0.85)

    var popup_options = {
        title: $' {url} ',
        pos: 'center',
        maxheight: popup_height,
        maxwidth: popup_width,
        border: [],
        padding: [0, 1, 0, 1],
        wrap: false,
        scrollbar: 1,
    }

    url_popup_id = popup_create(content_lines, popup_options)
enddef

command! UrlPopupToggle call ToggleUrlPopup()
nnoremap <silent> <leader>e :UrlPopupToggle<CR>

