vim9script

export def GfCreate(): void
    var raw_path = expand('<cfile>')
    if empty(raw_path)
        echoerr "No file path under cursor."
        return
    endif
    var full_path = fnamemodify(raw_path, ':p')
    var dir_path = fnamemodify(full_path, ':h')

    if !isdirectory(dir_path)
        if !mkdir(dir_path, 'p')
            echoerr "Failed to create directory: " .. dir_path
            return
        endif
    endif
    execute 'edit ' .. fnameescape(full_path)
enddef
