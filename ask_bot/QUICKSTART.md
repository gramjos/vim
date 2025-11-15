# AskBot v4 - Quick Start Guide

Get up and running with the AI-powered Vim assistant in 5 minutes!

## Prerequisites

- Vim 9.0 or later
- Google Gemini API key (free tier available)
- `curl` (usually pre-installed)
- `base64` (usually pre-installed)
- `fzf` (optional, for multi-file selection)

## Step 1: Get API Key

1. Visit https://makersuite.google.com/app/apikey
2. Click "Create API Key"
3. Copy the key

## Step 2: Configure API Key

```bash
# Create config directory
mkdir -p ~/.config/gemini_key_4_vim

# Save API key (replace YOUR_API_KEY with actual key)
echo "YOUR_API_KEY" > ~/.config/gemini_key_4_vim/g.key

# Secure the file
chmod 600 ~/.config/gemini_key_4_vim/g.key
```

## Step 3: Install FZF (Optional)

FZF is needed for multi-file selection. Skip this if you only want single-file mode.

### Ubuntu/Debian:
```bash
sudo apt install fzf
```

### macOS:
```bash
brew install fzf
```

### From source:
```bash
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
```

## Step 4: Add to Vim Config

Add this line to your `.vimrc`:

```vim
" Load AskBot v4
source ~/path/to/vim/ask_bot/v4.vim
```

Or if you cloned this repo:

```vim
source ~/.vim/pack/plugins/start/vim/ask_bot/v4.vim
```

## Step 5: Restart Vim

```bash
vim
```

## Usage

### Single-File Mode (Quick)

1. Open any file: `vim myfile.txt`
2. Press `<leader>af` (usually `\af`)
3. Type your question: "What does this code do?"
4. Press ENTER
5. Watch the AI response stream in!

**Example:**
```
# In Vim, editing script.py
\af
Ask about current file: Explain this Python script_

# Output buffer opens and streams:
This Python script appears to be...
[response continues streaming]
```

### Multi-File Mode (Advanced)

1. Open any file: `vim README.md`
2. Press `<leader>aa` (usually `\aa`)
3. Type your question: "How do these files work together?"
4. FZF opens showing file list
5. Use ↑↓ to navigate
6. Press TAB to select multiple files
7. Press ENTER to confirm
8. Watch the AI response stream in!

**Example:**
```
# In Vim, editing main.py
\aa
Ask a question about files: How do these modules interact?_

# FZF opens:
> Select files (TAB to select multiple, ENTER to confirm):
  main.py
  utils.py
  config.py
  [use TAB to select, ENTER to confirm]

# Output buffer opens and streams:
Based on the three files you've selected:
1. main.py serves as the entry point...
[response continues streaming]
```

### With Images

1. Open any file in a directory with images
2. Press `<leader>aa`
3. Type your question: "Describe this diagram"
4. In FZF, select the image file (diagram.png)
5. Press ENTER
6. Watch the AI analyze the image!

**Supported formats:** PNG, JPG, JPEG, GIF, WebP

## Examples

### Code Review
```
Question: "Review this code for security issues"
Files: auth.py, database.py
Result: AI analyzes both files and identifies potential vulnerabilities
```

### Documentation Generation
```
Question: "Write documentation for this module"
Files: api.py
Result: AI generates comprehensive docs
```

### Architecture Analysis
```
Question: "Explain the system architecture"
Files: main.py, server.py, client.py, architecture.png
Result: AI explains using both code and diagram
```

### Bug Investigation
```
Question: "Why is this test failing?"
Files: test_user.py, user.py, error_screenshot.png
Result: AI correlates code with error output
```

## Tips & Tricks

### 1. Change Leader Key
If `\` is inconvenient, remap in `.vimrc`:

```vim
let mapleader = ","
" Now use ,aa and ,af
```

### 2. Custom Mappings
Don't like the defaults? Remap:

```vim
" Unmap defaults
nunmap <leader>aa
nunmap <leader>af

" Use your own
nnoremap <F9> :call g:AskAboutCurrentFile()<CR>
nnoremap <F10> :call g:AskAboutFiles()<CR>
```

### 3. Switch Models
Edit `v4.vim` and change the model:

```vim
const CONFIG = {
    model: 'gemini-2.0-flash-exp',  # Fast, cheap
    # Or: 'gemini-1.5-pro'          # More capable
    # Or: 'gemini-1.5-flash'         # Balanced
}
```

### 4. Git-Aware File Selection
FZF automatically uses `git ls-files` if you're in a git repo, showing only tracked files. Very useful!

### 5. File Preview
In FZF, you can see file contents in the preview pane. Navigate with arrow keys to preview before selecting.

### 6. Cancel Operations
- During question input: Press ESC or CTRL-C
- During FZF selection: Press ESC
- During streaming: Close the output buffer (`:q`)

## Troubleshooting

### "API key file not found"
```bash
# Check file exists
ls -la ~/.config/gemini_key_4_vim/g.key

# Should show: -rw------- (permissions 600)
```

### "FZF command not found"
Either install FZF or use single-file mode (`<leader>af`) which doesn't need it.

### "Failed to start async job"
Check curl is installed:
```bash
which curl
curl --version
```

### Response is empty or error
- Verify API key is valid
- Check internet connection
- Try a different model in CONFIG

### Streaming is slow
- Normal! AI generation takes time
- Larger models are slower but better
- Try `gemini-2.0-flash-exp` for speed

## Performance

**Typical response times:**
- First token: 1-3 seconds
- Full response: 5-15 seconds (depends on length)
- Streaming starts immediately

**API limits (free tier):**
- 60 requests per minute
- 1,500 requests per day
- More than enough for daily use!

## Next Steps

1. **Read full documentation:**
   - `README.md` - Feature overview
   - `ARCHITECTURE_v4.md` - Technical details
   - `VERSION_COMPARISON.md` - Version differences

2. **Explore use cases:**
   - Code review and security audit
   - Documentation generation
   - Bug investigation
   - Learning unfamiliar codebases
   - Diagram/screenshot analysis

3. **Customize:**
   - Change model in CONFIG
   - Add custom key mappings
   - Modify prompt templates

4. **Share feedback:**
   - Open issues for bugs
   - Suggest features
   - Share your use cases!

## Common Questions

**Q: Is it free?**
A: Yes! Google Gemini has a generous free tier.

**Q: Does it send my code to Google?**
A: Yes, when you ask questions. Don't use with proprietary/secret code unless you have appropriate agreements with Google.

**Q: Can I use other AI models?**
A: This version is designed for Gemini API. For other models, you'd need to modify the API integration.

**Q: Does it store conversation history?**
A: No, each request is independent. Future versions may add this.

**Q: Can it write code?**
A: Yes! It can suggest code, explain code, review code, and more.

**Q: What about privacy?**
A: Your API key is stored locally. Requests go to Google's servers. See Google's privacy policy for details.

## Happy Coding! 🚀

Now you're ready to use AI assistance right in Vim. Start with simple questions and explore from there!

**Quick reference:**
- `\af` - Ask about current file
- `\aa` - Ask about multiple files (with FZF)
- ESC - Cancel at any time
- `:q` - Close output buffer

Enjoy your enhanced Vim experience!
