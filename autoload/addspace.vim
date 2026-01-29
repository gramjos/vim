vim9script

export def AddSpace(direction: string): void
    # Get the count. v:count1 defaults to 1 if no count is given.
    var count = v:count1

    # Save cursor position
    var original_pos = getpos('.')

    # Create the new lines.
    # We use 'execute "normal!..."' to apply the count.
    if direction == 'O'
        execute $"normal! {count}O"
    else
        execute $"normal! {count}o"
    endif

    # Return cursor to its original position
    setpos('.', original_pos)
enddef
