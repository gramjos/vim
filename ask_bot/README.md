# AskBot - AI Assistant for Vim

AI-powered file analysis using Google Gemini API with streaming responses.

## Version History

### Version 1 - Basic Synchronous API
**Features:**
- Send current file and question to Gemini API
- Synchronous (blocking) operation
- Display response in new split window

**Limitations:**
- Missing `vim9script` declaration
- Blocks Vim during API call
- No streaming support

---

### Version 2 - Async Implementation
**Features:**
- Asynchronous (non-blocking) API calls using `job_start()`
- Proper Vim9script with capitalized function references
- Vim remains responsive during requests

**Improvements over v1:**
- Added `vim9script` declaration
- Non-blocking async jobs
- Better error handling

---

### Version 3 - Streaming Responses
**Features:**
- Real-time streaming of AI responses
- SSE (Server-Sent Events) support
- Pipeline: `curl -N | awk | jq` for parsing

**Improvements over v2:**
- Live streaming effect as response arrives
- Better UX with immediate feedback
- Creates output buffer before streaming

**Limitations:**
- Missing `vim9script` declaration
- External dependency on `jq`
- Complex shell pipeline

---

### Version 4 - Multi-file with Images (New Architecture)
**Features:**
- ✨ **FZF-based multi-file selection**
- 📷 **Image support** (PNG, JPG, GIF, WebP) via Gemini Vision API
- 🔄 **Streaming responses** with clean SSE parsing
- 🏗️ **Modular architecture** with clear separation of concerns
- 🎯 **Two modes:**
  - `<leader>aa` - Multi-file mode with FZF selector
  - `<leader>af` - Quick single-file mode

**Architecture Highlights:**

1. **Configuration Module**
   - Centralized config with constants
   - Easy model switching
   - Supported file types defined in one place

2. **Utility Functions**
   - `GetApiKey()` - Secure API key handling
   - `IsImageFile()` - Smart file type detection
   - `EncodeImageBase64()` - Image encoding
   - `GetImageMimeType()` - MIME type mapping

3. **File Selection**
   - `SelectFilesWithFzf()` - Multi-select with preview
   - Fallback to current file if no selection
   - Auto-includes current file in context

4. **API Integration**
   - `BuildMultiFilePrompt()` - Constructs multi-modal payloads
   - Handles both text files and images
   - Proper JSON structure for Gemini API

5. **Streaming Handler**
   - `CreateOutputBuffer()` - Pre-formatted output with metadata
   - `StartStreamingRequest()` - Clean SSE parsing without external tools
   - Live text appending as chunks arrive

**Key Improvements:**
- ✅ Proper `vim9script` declaration
- ✅ No external dependencies (no `jq` needed)
- ✅ Image support for visual content
- ✅ Clean, maintainable code structure
- ✅ Better error handling
- ✅ Modular design for easy extension

## Installation

1. **Set up API key:**
   ```bash
   mkdir -p ~/.config/gemini_key_4_vim
   echo "YOUR_API_KEY_HERE" > ~/.config/gemini_key_4_vim/g.key
   chmod 600 ~/.config/gemini_key_4_vim/g.key
   ```

2. **Install FZF (for v4 only):**
   ```bash
   # Ubuntu/Debian
   sudo apt install fzf
   
   # macOS
   brew install fzf
   
   # Or from source
   git clone https://github.com/junegunn/fzf.git ~/.fzf
   ~/.fzf/install
   ```

3. **Source the desired version in your `.vimrc`:**
   ```vim
   " Load version 4 (recommended)
   source ~/path/to/vim/ask_bot/v4.vim
   
   " Or load specific version
   " source ~/path/to/vim/ask_bot/v3.vim
   ```

## Usage

### Version 4 Usage

**Multi-file mode:**
1. Open any file in Vim
2. Press `<leader>aa` (default: `\aa`)
3. Enter your question
4. FZF opens - use TAB to select multiple files
5. Press ENTER to confirm
6. Watch the streaming response appear

**Single-file mode:**
1. Open a file in Vim
2. Press `<leader>af` (default: `\af`)
3. Enter your question
4. Watch the streaming response

**Example scenarios:**
- Analyze multiple related source files together
- Ask about code with accompanying screenshots
- Compare implementations across files
- Get explanations with visual diagrams

## Technical Details

### Gemini API Model
- Default: `gemini-2.0-flash-exp`
- Supports: Text and Vision (images)
- Streaming via SSE (Server-Sent Events)

### Supported Image Formats
- PNG (`.png`)
- JPEG (`.jpg`, `.jpeg`)
- GIF (`.gif`)
- WebP (`.webp`)

### Error Handling
- API key validation
- File readability checks
- Network error handling
- JSON parsing with fallbacks
- Job failure detection

## Troubleshooting

**FZF not found:**
- Install FZF (see Installation section)
- Or use single-file mode (`<leader>af`)

**API errors:**
- Check API key is valid
- Ensure internet connection
- Verify file permissions

**Streaming issues:**
- Check `curl` is installed
- Test network connectivity
- Review Vim job system support
