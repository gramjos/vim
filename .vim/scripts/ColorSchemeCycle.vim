vim9script

# Declare state variables at the script level.
var colors: list<string> = []
var color_idx: number = -1

# The function will now display the message in a popup window.
def NextColor()
    # Lazy initialization: This block runs only once on the first call.
    if empty(colors)
        colors = globpath(&runtimepath, 'colors/*.vim', true, true)->map(
            (_, f) => fnamemodify(f, ':t:r'))

        if exists('g:colors_name')
            color_idx = colors->index(g:colors_name)
        else
            color_idx = -1
        endif

        if color_idx < 0
            color_idx = 0
        endif
    endif

    # Increment the index.
    color_idx = (color_idx + 1) % len(colors)
    var next_scheme = colors[color_idx]

    # Execute the command and provide feedback via a popup.
    execute 'colorscheme ' .. next_scheme
    echowindow next_scheme
enddef

# This mapping style is robust and works well with the echowindow command.
nnoremap <silent> <leader>x <ScriptCmd>call NextColor()<CR>

# A "getter" function to safely expose data
def g:GetCycleInfo(): string
    return $"Found {len(colors)} colors. Current index: {color_idx}"
enddef
