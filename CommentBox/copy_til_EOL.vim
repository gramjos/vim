function! Copy_Til_eol()
  " yank the character the cursor is over
  yl
  let char_x = @0
  " copy char_x n_copy times
  let n_copy = col('.') -79
  let lin = repeat(char_x,ncopy)
  let @0 = lin
  p
endfunction


function! S_R_eol()
  " current line substitution ONLY
  .s/\s/#
endfunction
