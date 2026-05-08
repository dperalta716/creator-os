#!/bin/bash
# Shared functions for fal.ai API scripts

# Look for key in vault first, then home directory
if [[ -f "./.claude/skills/fal-ai/fal-api-key" ]]; then
  FAL_API_KEY_FILE="./.claude/skills/fal-ai/fal-api-key"
else
  FAL_API_KEY_FILE="$HOME/.claude/skills/fal-api-key"
fi

load_fal_key() {
  if [[ ! -f "$FAL_API_KEY_FILE" ]]; then
    echo "Error: API key not found. Save your fal.ai key to ./.claude/skills/fal-ai/fal-api-key" >&2
    exit 1
  fi
  FAL_KEY=$(cat "$FAL_API_KEY_FILE" | tr -d '[:space:]')
}

# Submit to queue, poll until complete, return result JSON
# Args: endpoint, payload_file
# Prints: result JSON to stdout, progress to stderr
fal_submit_and_wait() {
  local ENDPOINT="$1"
  local PAYLOAD_FILE="$2"

  local SUBMIT_RESP
  SUBMIT_RESP=$(curl -s -X POST "https://queue.fal.run/${ENDPOINT}" \
    -H "Authorization: Key ${FAL_KEY}" \
    -H "Content-Type: application/json" \
    -d @"$PAYLOAD_FILE")

  local REQUEST_ID
  REQUEST_ID=$(echo "$SUBMIT_RESP" | jq -r '.request_id // empty')

  if [[ -z "$REQUEST_ID" ]]; then
    echo "Error submitting request:" >&2
    echo "$SUBMIT_RESP" | jq '.' >&2
    exit 1
  fi

  echo "Request ID: $REQUEST_ID" >&2

  # fal.ai status/result URLs use the base model path, not the operation-specific path
  # e.g. openai/gpt-image-2 not openai/gpt-image-2/edit
  local BASE_ENDPOINT
  BASE_ENDPOINT=$(echo "$ENDPOINT" | sed 's|/edit$||; s|/generate$||')

  local STATUS=""
  local POLL_COUNT=0
  local MAX_POLLS=200

  while [[ "$STATUS" != "COMPLETED" && $POLL_COUNT -lt $MAX_POLLS ]]; do
    sleep 3
    POLL_COUNT=$((POLL_COUNT + 1))

    local STATUS_RESP
    STATUS_RESP=$(curl -s "https://queue.fal.run/${BASE_ENDPOINT}/requests/${REQUEST_ID}/status" \
      -H "Authorization: Key ${FAL_KEY}")

    STATUS=$(echo "$STATUS_RESP" | jq -r '.status // empty')

    case "$STATUS" in
      IN_QUEUE)
        local POS
        POS=$(echo "$STATUS_RESP" | jq -r '.queue_position // "?"')
        echo "In queue (position: ${POS})..." >&2
        ;;
      IN_PROGRESS)
        echo "Generating..." >&2
        ;;
      FAILED)
        echo "Generation failed:" >&2
        echo "$STATUS_RESP" | jq '.' >&2
        exit 1
        ;;
    esac
  done

  if [[ $POLL_COUNT -ge $MAX_POLLS ]]; then
    echo "Timed out waiting for result" >&2
    exit 1
  fi

  curl -s "https://queue.fal.run/${BASE_ENDPOINT}/requests/${REQUEST_ID}" \
    -H "Authorization: Key ${FAL_KEY}"
}

# Download file from URL to ~/Downloads/
# Args: url, filename_prefix, extension
# Prints: downloaded file path
fal_download() {
  local URL="$1"
  local PREFIX="${2:-fal}"
  local EXT="${3:-png}"
  local TIMESTAMP
  TIMESTAMP=$(date +%Y%m%d-%H%M%S)

  local OUTFILE="$HOME/Downloads/${PREFIX}-${TIMESTAMP}.${EXT}"
  curl -s -L -o "$OUTFILE" "$URL"
  echo "$OUTFILE"
}

# Convert local file to base64 data URI
# Args: file_path
# Prints: data URI string
file_to_data_uri() {
  local FILE="$1"
  if [[ ! -f "$FILE" ]]; then
    echo "Error: File not found: $FILE" >&2
    exit 1
  fi

  local MIME
  case "${FILE##*.}" in
    jpg|jpeg) MIME="image/jpeg" ;;
    png)      MIME="image/png" ;;
    webp)     MIME="image/webp" ;;
    gif)      MIME="image/gif" ;;
    *)        MIME="application/octet-stream" ;;
  esac

  echo "data:${MIME};base64,$(base64 -i "$FILE")"
}

# Resolve model alias to endpoint
# Args: model_alias, mode (generate|edit)
# Prints: endpoint string
resolve_endpoint() {
  local MODEL="$1"
  local MODE="${2:-generate}"

  local BASE
  case "$MODEL" in
    gpt2|gpt-image-2|chatgpt)   BASE="openai/gpt-image-2" ;;
    banana|banana1|nb1)          BASE="fal-ai/nano-banana" ;;
    banana2|nb2)                 BASE="fal-ai/nano-banana-2" ;;
    banana-pro|nbpro|pro)        BASE="fal-ai/nano-banana-pro" ;;
    *)
      echo "Unknown model: $MODEL" >&2
      echo "Available: gpt2, banana, banana2, banana-pro" >&2
      exit 1
      ;;
  esac

  if [[ "$MODE" == "edit" ]]; then
    echo "${BASE}/edit"
  else
    echo "$BASE"
  fi
}
