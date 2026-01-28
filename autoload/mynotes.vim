vim9script

# Define the directory where your notes live
const NOTES_DIR = expand('~/.vim/doc/')

# Export the function so the plugin can import it
export def Toggle(): void
    # --- SAFETY GUARD ---
    # Check if the current file is actually in your notes directory.
    # If not, stop immediately to prevent locking random files.
    if expand('%:p') !~# NOTES_DIR
        echo "⚠️  Ignored: This is not a note file."
        return
    endif

    # --- TOGGLE LOGIC ---
    if &buftype == 'help'
        # 1. SWITCH TO EDIT MODE
        setlocal buftype=       # Make it a normal file
        setlocal modifiable     # Allow typing
        setlocal noreadonly     # Allow saving
        echo " -- ✏️  EDIT MODE -- "
    
    else
        # 2. SWITCH TO VIEW MODE
        # Save changes first if needed
        if &modified
            write
        endif
        
        # Restore special help behavior
        setlocal buftype=help   # Enable Ctrl-] jumping
        setlocal nomodifiable   # Prevent accidental edits
        setlocal readonly
        
        # Force reload to apply help syntax highlighting immediately
        edit! 
        
        echo " -- 📖 VIEW MODE (Saved & Indexed) -- "
    endif
enddef
