vim9script

# Declare state variables at the script level.
var colors: list<string> = []
var color_idx: number = -1

# The function will now display the message in a timed popup window.
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

    # Execute the command.
    execute 'colorscheme ' .. next_scheme

    call popup_create(next_scheme, {time: 1500, line: 'cursor-1', col: 'cursor'})
enddef

# This mapping style is robust and works well with popup commands.
nnoremap <silent> <leader>x <ScriptCmd>call NextColor()<CR>

# A "getter" function to return the list of discovered colorschemes.
def g:GetColorschemes(): list<string>
    return colors
enddef

# A "getter" function to safely expose data
def g:GetCycleInfo(): string
    return $"Found {len(colors)} colors. Current index: {color_idx}"
enddef
