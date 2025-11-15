# AskBot v4 - Architecture Documentation

## Overview

Version 4 represents a complete redesign of the AskBot system with a focus on:
- **Modularity**: Clear separation of concerns
- **Extensibility**: Easy to add new features
- **Reliability**: Robust error handling
- **User Experience**: Multi-file selection with FZF
- **Multi-modal**: Support for both text and images

## Design Principles

### 1. Vim9script Native
- All code uses modern Vim9script syntax
- Type-safe with proper type annotations
- Compiled functions for better performance
- No legacy VimL constructs

### 2. Modular Architecture
The code is organized into distinct functional modules:
- Configuration
- Utilities
- File Selection
- API Payload Construction
- Streaming Handler
- Entry Points

### 3. Separation of Concerns
Each module has a single, well-defined responsibility:
- **Config**: Constants and settings
- **Utils**: Reusable helper functions
- **File Selection**: FZF integration
- **API**: Payload building and streaming
- **UI**: Buffer management and display

## Architecture Components

### Configuration Module
```vim9script
const CONFIG = {
    api_key_file: string,
    model: string,
    api_base: string,
    supported_images: list<string>
}
```

**Purpose**: Centralized configuration management
**Benefits**:
- Single source of truth
- Easy to modify settings
- No hardcoded values scattered in code

### Utility Functions

#### `GetApiKey(): string`
- Reads and validates API key from secure location
- Returns empty string on error
- Provides clear error messages

#### `IsImageFile(filepath: string): bool`
- Determines if file is an image
- Checks against supported formats
- Used for multi-modal handling

#### `EncodeImageBase64(filepath: string): string`
- Encodes images to base64
- Required for Gemini Vision API
- Uses system `base64` command

#### `GetImageMimeType(filepath: string): string`
- Maps file extensions to MIME types
- Supports PNG, JPEG, GIF, WebP
- Returns proper Content-Type

### File Selection Module

#### `SelectFilesWithFzf(current_file: string): list<string>`
**Flow**:
1. Generate file list (git or find)
2. Pipe to FZF with multi-select enabled
3. Parse user selection
4. Convert to absolute paths
5. Validate file readability
6. Include current file if not selected

**Features**:
- Multi-select with TAB
- Preview pane shows file content
- Git-aware (uses git ls-files if available)
- Fallback to find command
- Auto-includes current file for context

### API Integration Module

#### `BuildMultiFilePrompt(files: list<string>, question: string): dict<any>`
**Structure**:
```
{
    contents: [{
        parts: [
            {text: "intro"},
            {text: "File: path\n```\ncontent\n```"},
            {inline_data: {mime_type: "...", data: "base64..."}},
            {text: "Question: ..."}
        ]
    }]
}
```

**Features**:
- Mixed text and image support
- Proper JSON structure for Gemini
- Clear file separation
- Context-aware prompting

### Streaming Handler Module

#### `CreateOutputBuffer(question: string, files: list<string>): number`
**Creates formatted output**:
- Markdown-formatted header
- Lists question and files
- Separator before response
- Returns buffer number for streaming

#### `StartStreamingRequest(payload: dict<any>, output_bufnr: number)`
**SSE Streaming Flow**:
1. Encode payload as JSON
2. Start curl with `-N` (no buffering)
3. Parse SSE format: `data: {json}`
4. Extract text chunks from response
5. Append to output buffer in real-time
6. Handle errors gracefully

**Callback Architecture**:
- `On_stdout`: Processes streaming data chunks
- `On_stderr`: Captures error output
- `On_exit`: Finalizes response or reports errors

**State Management**:
```vim9script
var stream_state = {
    data_buffer: "",  # Accumulates partial data
    bufnr: number     # Target buffer
}
```

### Entry Points

#### `AskAboutFiles()` - Multi-file Mode
**User Flow**:
1. User presses `<leader>aa`
2. Prompted for question
3. FZF opens for file selection
4. Selected files displayed
5. Streaming response begins

#### `AskAboutCurrentFile()` - Single-file Mode  
**User Flow**:
1. User presses `<leader>af`
2. Prompted for question
3. Current file used automatically
4. Streaming response begins

## Data Flow

```
User Input (Question)
    ↓
FZF File Selection
    ↓
File Processing
    ├─→ Text Files → Read Content
    └─→ Images → Base64 Encode
    ↓
Build API Payload
    ↓
Create Output Buffer
    ↓
Start Async Job (curl)
    ↓
Stream Chunks (SSE)
    ↓
Parse JSON Chunks
    ↓
Append Text to Buffer
    ↓
Complete Response
```

## Error Handling Strategy

### Levels of Error Handling

1. **Pre-flight Checks**
   - API key exists and readable
   - Current file is valid
   - User didn't cancel

2. **Runtime Validation**
   - File paths are absolute and readable
   - JSON encoding succeeds
   - Job starts successfully

3. **Network/API Errors**
   - HTTP errors captured in stderr
   - API errors in response JSON
   - Timeout handling via job exit

4. **Parsing Errors**
   - JSON parse failures silently ignored (partial chunks)
   - Malformed SSE handled gracefully
   - Buffer operations checked

## Performance Considerations

### Asynchronous Design
- Non-blocking API calls
- Vim remains responsive
- Background job processing

### Streaming Benefits
- Immediate feedback to user
- Lower perceived latency
- Progressive rendering

### Resource Management
- Minimal memory footprint
- No temporary file creation
- Efficient string concatenation

## Security Considerations

### API Key Protection
- Stored outside repository
- File permissions: 600 (user-only)
- Never logged or echoed
- Passed via command args (not env)

### Input Validation
- File paths validated
- JSON properly escaped
- Shell command safely constructed

### Network Safety
- HTTPS only
- No certificate validation bypass
- Proper error handling

## Extension Points

### Easy to Add:

1. **New File Types**
   - Add to `CONFIG.supported_images`
   - Update `GetImageMimeType()`

2. **Different Models**
   - Change `CONFIG.model`
   - Adjust API endpoint if needed

3. **Custom Prompts**
   - Modify `BuildMultiFilePrompt()`
   - Add prompt templates

4. **Output Formats**
   - Change `CreateOutputBuffer()` format
   - Add export functions

5. **File Filters**
   - Modify `SelectFilesWithFzf()` command
   - Add gitignore integration

## Comparison with Previous Versions

### vs Version 3
- ✅ Added multi-file support
- ✅ Added image support
- ✅ Removed `jq` dependency
- ✅ Better code organization
- ✅ Proper vim9script declaration

### vs Version 2
- ✅ Added streaming
- ✅ Better UX with live updates
- ✅ Multi-file capability
- ✅ Image support

### vs Version 1
- ✅ Non-blocking async
- ✅ Streaming responses
- ✅ Multi-file + images
- ✅ Better error handling
- ✅ Modern Vim9script

## Future Enhancements

### Potential Additions:
1. **Conversation History**
   - Save previous Q&A
   - Continue conversations
   - Reference history

2. **Custom Prompts**
   - Predefined prompt templates
   - User-configurable prompts
   - Role-based prompting

3. **Response Actions**
   - Apply code suggestions
   - Save to file
   - Copy to clipboard

4. **Progress Indicators**
   - Show tokens received
   - Estimated time remaining
   - Network status

5. **Configuration UI**
   - Interactive settings
   - Model selection
   - Key management

## Testing Strategy

### Manual Testing Checklist:
- [ ] Single file (text) works
- [ ] Multi-file selection works
- [ ] Image files work
- [ ] Mixed text + images work
- [ ] Error handling (no API key)
- [ ] Error handling (invalid file)
- [ ] Error handling (network failure)
- [ ] Streaming displays correctly
- [ ] Cancel operations work
- [ ] Large files handled
- [ ] Special characters in filenames

### Edge Cases:
- Empty files
- Binary files
- Very large files (>1MB)
- Special characters in paths
- Network interruption
- API rate limiting
- Invalid API key
- Malformed responses

## Maintenance Notes

### Code Quality:
- All functions have single responsibility
- Clear naming conventions
- Type annotations throughout
- No global state pollution
- Proper resource cleanup

### Documentation:
- Inline comments for complex logic
- Function-level documentation
- Architecture overview (this file)
- User guide in README

### Dependencies:
- Vim 9.0+ (vim9script support)
- curl (for API calls)
- base64 (for image encoding)
- fzf (optional, for multi-select)
- git (optional, for file listing)

## Conclusion

Version 4 represents a mature, production-ready AI assistant for Vim with:
- Clean architecture
- Multi-modal support
- Excellent user experience
- Robust error handling
- Easy maintenance and extension

The modular design allows for easy customization while maintaining code quality and reliability.
