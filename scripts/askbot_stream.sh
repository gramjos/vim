#!/bin/sh
# POSIX-compliant shell script for AskBot streaming
# Usage: askbot_stream.sh <question> [--memory] [--stdin | file1 file2 ...]
#
# Architecture: Vim delegates all heavy processing to this script.
# - Reads file contents directly (Vim never sees the bytes)
# - Injects memory context from log.json using jq (not Vim)
# - Constructs JSON payload safely with jq -n
# - Streams the Gemini API response line by line
# - Atomically updates log.json using jq (write to .tmp then mv)

set -e

# === Configuration ===
API_KEY_FILE="$HOME/.config/gemini_key_4_vim/g.key"
LOG_DIR="$HOME/.vim/askbot_log"
LOG_FILE="$LOG_DIR/log.json"
BASE_URL="https://generativelanguage.googleapis.com/v1beta/models/"
MODEL="gemini-2.5-flash-lite"

# === Parse Arguments ===
QUESTION=""
USE_MEMORY=0
USE_STDIN=0
FILES=""

if [ $# -lt 1 ]; then
    echo "Usage: askbot_stream.sh <question> [--memory] [--stdin | file1 file2 ...]" >&2
    exit 1
fi

QUESTION="$1"
shift

while [ $# -gt 0 ]; do
    case "$1" in
        --memory)
            USE_MEMORY=1
            shift
            ;;
        --stdin)
            USE_STDIN=1
            shift
            ;;
        *)
            FILES="$FILES $1"
            shift
            ;;
    esac
done

# === Read API Key ===
if [ ! -f "$API_KEY_FILE" ]; then
    echo "Error: API key file not found at $API_KEY_FILE" >&2
    exit 1
fi
API_KEY=$(cat "$API_KEY_FILE" | tr -d '[:space:]')

# === Ensure Log Directory Exists ===
mkdir -p "$LOG_DIR"

# === Build Context ===
CONTEXT=""

# Read stdin if --stdin flag is set
if [ "$USE_STDIN" -eq 1 ]; then
    STDIN_CONTENT=$(cat)
    CONTEXT="$STDIN_CONTENT"
fi

# Read files if provided (shell reads them, not Vim)
for f in $FILES; do
    if [ -f "$f" ]; then
        FILE_CONTENT=$(cat "$f")
        CONTEXT="$CONTEXT
--- File: $f ---
$FILE_CONTENT"
    fi
done

# === Get Memory Context if enabled ===
MEMORY_CONTEXT=""
if [ "$USE_MEMORY" -eq 1 ] && [ -f "$LOG_FILE" ]; then
    # Use jq to extract last 5 interactions and format them
    MEMORY_CONTEXT=$(jq -r '
        .[-5:] | 
        if length > 0 then
            "--- CONVERSATION HISTORY ---\n" +
            (map("USER ASKED: \(.query)\nAI REPLIED: \(.response)\n---") | join("\n")) +
            "\n--- END HISTORY ---\n\n"
        else
            ""
        end
    ' "$LOG_FILE" 2>/dev/null || echo "")
fi

# === Build Final Prompt ===
if [ -n "$MEMORY_CONTEXT" ]; then
    FINAL_CONTEXT="${MEMORY_CONTEXT}CURRENT FILE CONTEXT:
$CONTEXT"
else
    FINAL_CONTEXT="Context:
$CONTEXT"
fi

PROMPT="${FINAL_CONTEXT}

Question: $QUESTION"

# === Display prompt header (for user feedback in Vim) ===
echo "$PROMPT"
echo "---"
if [ "$USE_MEMORY" -eq 1 ]; then
    echo "(Memory: ON)"
fi
echo ""

# === Construct JSON Payload with jq (safe escaping) ===
JSON_PAYLOAD=$(jq -n --arg text "$PROMPT" '{contents: [{parts: [{text: $text}]}]}')

# === Build API URL ===
API_URL="${BASE_URL}${MODEL}:streamGenerateContent?key=${API_KEY}&alt=sse"

# === Temporary file for collecting response (for logging) ===
RESPONSE_TMP=$(mktemp)
trap 'rm -f "$RESPONSE_TMP"' EXIT

# === Stream the API response ===
# curl streams to awk, which extracts data lines, then jq extracts text
curl -N -s -X POST \
    -H "Content-Type: application/json" \
    -d "$JSON_PAYLOAD" \
    "$API_URL" 2>/dev/null | \
    awk '/^data: / { print substr($0, 7); fflush() }' | \
    jq --unbuffered -r '.candidates[0].content.parts[0].text // empty' | \
    while IFS= read -r line; do
        echo "$line"
        printf '%s\n' "$line" >> "$RESPONSE_TMP"
    done

echo ""
echo "---"
echo "[Done]"

# === Atomically Update Log File ===
FULL_RESPONSE=$(cat "$RESPONSE_TMP")
TIMESTAMP=$(date '+%Y-%m-%d %H:%M:%S')

# Create new entry
NEW_ENTRY=$(jq -n \
    --arg query "$QUESTION" \
    --arg query_context "$CONTEXT" \
    --arg response "$FULL_RESPONSE" \
    --arg timestamp "$TIMESTAMP" \
    '{query: $query, query_context: $query_context, response: $response, timestamp: $timestamp}')

# Append to existing log (or create new one) atomically
if [ -f "$LOG_FILE" ]; then
    # Read existing, append new entry, write to tmp, then mv
    jq --argjson entry "$NEW_ENTRY" '. + [$entry]' "$LOG_FILE" > "${LOG_FILE}.tmp" 2>/dev/null && \
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
else
    # Create new log file with single entry
    echo "[$NEW_ENTRY]" | jq '.' > "${LOG_FILE}.tmp" && \
        mv "${LOG_FILE}.tmp" "$LOG_FILE"
fi
