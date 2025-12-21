vim9script

export def ToggleLineNumber(): void
    # Check if both are true (Relative mode is ON)
    if &relativenumber && &number
        set norelativenumber
        set number
    # Check if only number is true (Absolute mode is ON)
    elseif !&relativenumber && &number
        set nonumber
        set norelativenumber
    # Otherwise (both are off), switch to Relative mode
    else
        set relativenumber
        set number
    endif
enddef

