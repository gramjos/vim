# AskBot Evolution: Version Comparison

## Quick Reference Table

| Feature | v1 | v2 | v3 | v4 |
|---------|----|----|----|----|
| **vim9script declaration** | ✅ | ✅ | ✅ | ✅ |
| **Async/Non-blocking** | ❌ | ✅ | ✅ | ✅ |
| **Streaming responses** | ❌ | ❌ | ✅ | ✅ |
| **Multi-file support** | ❌ | ❌ | ❌ | ✅ |
| **Image support** | ❌ | ❌ | ❌ | ✅ |
| **FZF integration** | ❌ | ❌ | ❌ | ✅ |
| **External dependencies** | curl | curl | curl, jq | curl, base64 |
| **Code organization** | Basic | Good | Good | Excellent |
| **Error handling** | Basic | Good | Good | Comprehensive |
| **User experience** | Wait → Show | Background → Show | Live streaming | Interactive + Live |
| **Lines of code** | ~100 | ~145 | ~100 | ~380 |

## Detailed Comparison

### Version 1: The Foundation
**File**: `v1.vim`

**What it does:**
- Sends current file + question to Gemini API
- Shows response in new split window

**User flow:**
1. Press `<leader>af`
2. Enter question
3. **Wait** (Vim is blocked)
4. Response appears in new window

**Pros:**
- Simple and straightforward
- Easy to understand
- Minimal code

**Cons:**
- ❌ Blocks Vim during API call (bad UX)
- ❌ No visual feedback while waiting
- ❌ Can't work on other files during request
- ❌ Missing vim9script declaration (now fixed)

**Key code:**
```vim9script
var response = system($'curl -s -X POST ... {shellescape(api_url)}')
g:DisplayApiResponse(response)
```

---

### Version 2: Going Async
**File**: `v2.vim`

**What it does:**
- Asynchronous API calls using Vim's job system
- Vim remains responsive during requests

**User flow:**
1. Press `<leader>af`
2. Enter question
3. Continue working in Vim
4. Response appears when ready

**Improvements over v1:**
- ✅ Non-blocking - Vim stays responsive
- ✅ Proper Vim9script with capitalized Funcrefs
- ✅ Better async architecture

**Pros:**
- Doesn't block editor
- Can queue multiple requests
- Proper job management

**Cons:**
- Still waits for complete response before displaying
- No progress indication
- All-or-nothing response display

**Key code:**
```vim9script
var On_exit = (job: any, status: number) => {
    var final_response = response_data->join('')
    g:DisplayApiResponse(final_response)
}
var job = job_start(cmd, job_options)
```

---

### Version 3: Live Streaming
**File**: `v3.vim`

**What it does:**
- Streams response in real-time as it arrives
- Uses SSE (Server-Sent Events) from Gemini
- Shell pipeline: curl → awk → jq

**User flow:**
1. Press `<leader>af`
2. Enter question
3. Output buffer appears immediately
4. **Watch response stream in** word-by-word

**Improvements over v2:**
- ✅ Immediate feedback (buffer opens right away)
- ✅ Streaming text as it arrives
- ✅ Much better perceived performance
- ✅ See progress in real-time

**Pros:**
- Live streaming creates great UX
- Can see answer forming
- Lower perceived latency

**Cons:**
- ❌ Complex shell pipeline (`curl | awk | jq`)
- ❌ Dependency on `jq` (not always installed)
- ❌ Missing vim9script declaration (now fixed)
- No multi-file support
- No image support

**Key code:**
```vim9script
var pipeline = join([
    'curl -N -s -X POST ...',
    "awk '/^data: / { print substr($0, 7); fflush() }'",
    'jq --unbuffered -r ".candidates[0].content.parts[0].text // empty"'
], ' | ')
```

---

### Version 4: Complete Redesign
**File**: `v4.vim`

**What it does:**
- Multi-file selection with FZF
- Supports both text files AND images
- Streaming responses with clean SSE parsing
- Modular, maintainable architecture

**User flow (Multi-file mode):**
1. Press `<leader>aa`
2. Enter question
3. **FZF opens** - TAB to select multiple files/images
4. Press ENTER to confirm
5. Output buffer appears with metadata
6. **Watch response stream in** with full context

**User flow (Single-file mode):**
1. Press `<leader>af`
2. Enter question
3. Output buffer appears
4. Watch response stream in

**Improvements over v3:**
- ✅ **Multi-file selection** - analyze multiple files together
- ✅ **Image support** - Gemini Vision API integration
- ✅ **No jq dependency** - pure Vim9script SSE parsing
- ✅ **Modular architecture** - easy to maintain/extend
- ✅ **Two modes** - quick single or rich multi-file
- ✅ **Better error handling** - comprehensive checks
- ✅ **Proper configuration** - centralized settings

**Architecture highlights:**
```vim9script
# Clean module organization
const CONFIG = { ... }           # Configuration
def GetApiKey()                  # Utilities
def SelectFilesWithFzf()         # File selection
def BuildMultiFilePrompt()       # API payload
def StartStreamingRequest()      # Streaming handler
export def AskAboutFiles()       # Entry points
```

**Key innovations:**

1. **FZF Integration:**
```vim9script
var fzf_cmd = 'fzf --multi --prompt="..." --preview="head -50 {}"'
var selected = systemlist($'{list_cmd} | {fzf_cmd}')
```

2. **Multi-modal Support:**
```vim9script
if IsImageFile(filepath)
    parts->add({
        inline_data: {
            mime_type: GetImageMimeType(filepath),
            data: EncodeImageBase64(filepath)
        }
    })
else
    var content = readfile(filepath)->join("\n")
    parts->add({text: $"### File: {filepath}\n```\n{content}\n```"})
endif
```

3. **Clean SSE Parsing:**
```vim9script
# No jq needed - pure Vim9script
if trimmed =~ '^data: '
    var json_str = trimmed[6:]
    var chunk = json_decode(json_str)
    # Extract and append text...
endif
```

**Pros:**
- ✅ Multi-file analysis
- ✅ Image understanding
- ✅ Great user experience
- ✅ No external parsing tools
- ✅ Modular and maintainable
- ✅ Comprehensive features

**Cons:**
- Requires FZF for multi-select (optional)
- More complex codebase
- Larger file size

---

## Migration Guide

### From v1 to v4:
- Replace `source v1.vim` with `source v4.vim`
- Mapping stays the same: `<leader>af` still works
- Bonus: Now also have `<leader>aa` for multi-file

### From v2 to v4:
- Replace `source v2.vim` with `source v4.vim`
- Same mapping: `<leader>af`
- Gain: Streaming + multi-file support

### From v3 to v4:
- Replace `source v3.vim` with `source v4.vim`
- Remove `jq` dependency (no longer needed)
- Install `fzf` (optional, for multi-file)
- Same mapping for single-file: `<leader>af`
- New mapping for multi-file: `<leader>aa`

---

## Performance Comparison

### Response Time Perception:

**v1**: Request → **[WAIT 3-5s]** → Full response
- Feels: Slow, blocking

**v2**: Request → [work in background] → Full response
- Feels: Better, but still waiting for full response

**v3**: Request → Buffer opens → **[stream stream stream]** → Done
- Feels: Fast! Immediate feedback

**v4**: Request → **[FZF picker]** → Buffer opens → **[stream stream stream]** → Done
- Feels: Interactive and fast!

### Resource Usage:

| Version | Memory | CPU | Network | Dependencies |
|---------|--------|-----|---------|--------------|
| v1 | Low | Medium | Same | curl |
| v2 | Low | Low | Same | curl |
| v3 | Low | Low | Same | curl, jq |
| v4 | Low | Low | Same | curl, base64, (fzf) |

---

## Feature Matrix

### Capabilities:

| Capability | v1 | v2 | v3 | v4 |
|------------|----|----|----|----|
| Single text file | ✅ | ✅ | ✅ | ✅ |
| Multiple text files | ❌ | ❌ | ❌ | ✅ |
| Single image | ❌ | ❌ | ❌ | ✅ |
| Multiple images | ❌ | ❌ | ❌ | ✅ |
| Mixed text + images | ❌ | ❌ | ❌ | ✅ |
| Streaming output | ❌ | ❌ | ✅ | ✅ |
| File preview | ❌ | ❌ | ❌ | ✅ |
| Interactive selection | ❌ | ❌ | ❌ | ✅ |

### Code Quality:

| Metric | v1 | v2 | v3 | v4 |
|--------|----|----|----|----|
| Vim9script compliant | ✅ | ✅ | ✅ | ✅ |
| Modular design | ❌ | ❌ | ❌ | ✅ |
| Type annotations | Partial | Good | Partial | Complete |
| Error handling | Basic | Good | Good | Comprehensive |
| Documentation | None | Comments | Comments | Full docs |
| Testability | Low | Medium | Medium | High |

---

## Recommendations

### Use v1 if:
- You want absolute simplicity
- You don't mind blocking
- Single file is enough

### Use v2 if:
- You need non-blocking
- Simple async is sufficient
- Don't need streaming

### Use v3 if:
- You want streaming UX
- Have `jq` installed
- Single file is enough

### Use v4 if: ⭐ **RECOMMENDED**
- You want the best experience
- Need multi-file analysis
- Want to include images
- Care about code quality
- Want future-proof solution

---

## Summary

**Evolution path:**
```
v1: Sync → v2: Async → v3: Streaming → v4: Multi-modal + Interactive
```

**Version 4 represents:**
- ✅ Best user experience
- ✅ Most features
- ✅ Cleanest architecture
- ✅ Best maintainability
- ✅ Future-proof design

**Trade-offs:**
- More code complexity (but better organized)
- Additional optional dependency (FZF)
- Slightly larger file size

**Bottom line:** Version 4 is production-ready, feature-complete, and the recommended choice for serious use.
