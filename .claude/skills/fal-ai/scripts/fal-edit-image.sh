#!/bin/bash
# Edit images using fal.ai
# Usage: fal-edit-image.sh "prompt" "image_path_or_url" [model] [quality] [format]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/fal-common.sh"
load_fal_key

if [[ $# -lt 2 ]]; then
  cat <<'USAGE'
Usage: fal-edit-image.sh "prompt" "image_path_or_url" [model] [quality] [format]

Models:
  gpt2        GPT Image 2 (default) — mask-based editing, best text
  banana      Nano Banana (original) — artistic edits
  banana2     Nano Banana 2 — fast production edits
  banana-pro  Nano Banana Pro — highest quality edits

Quality:  low (default), medium, high — GPT Image 2 only
Format:   png (default), jpeg, webp
Image:    URL or local file path (jpg, png, webp)
USAGE
  exit 1
fi

PROMPT="$1"
IMAGE_INPUT="$2"
MODEL="${3:-gpt2}"
QUALITY="${4:-low}"
FORMAT="${5:-png}"

ENDPOINT=$(resolve_endpoint "$MODEL" "edit")

echo "fal.ai Image Editing" >&2
echo "Prompt: ${PROMPT:0:80}$([ ${#PROMPT} -gt 80 ] && echo '...')" >&2
echo "Model: $MODEL ($ENDPOINT)" >&2

# Handle local file vs URL
if [[ "$IMAGE_INPUT" == http* ]]; then
  IMAGE_URL="$IMAGE_INPUT"
  echo "Source: $IMAGE_URL" >&2
else
  echo "Source: $IMAGE_INPUT (local file)" >&2
  echo "Converting to data URI..." >&2
  IMAGE_URL=$(file_to_data_uri "$IMAGE_INPUT")
fi

echo "" >&2

PAYLOAD_FILE=$(mktemp)
trap 'rm -f "$PAYLOAD_FILE"' EXIT

PROMPT_ESCAPED=$(printf '%s' "$PROMPT" | jq -Rs .)

if [[ "$ENDPOINT" == "openai/gpt-image-2/edit" ]]; then
  # Write JSON, handling potentially large data URI via heredoc
  cat > "$PAYLOAD_FILE" <<EOF
{
  "prompt": $PROMPT_ESCAPED,
  "image_urls": ["${IMAGE_URL}"],
  "quality": "$QUALITY",
  "output_format": "$FORMAT"
}
EOF
else
  cat > "$PAYLOAD_FILE" <<EOF
{
  "prompt": $PROMPT_ESCAPED,
  "image_urls": ["${IMAGE_URL}"],
  "output_format": "$FORMAT",
  "safety_tolerance": 6
}
EOF
fi

echo "Submitting to queue..." >&2

RESULT=$(fal_submit_and_wait "$ENDPOINT" "$PAYLOAD_FILE")

IMAGE_COUNT=$(echo "$RESULT" | jq '.images | length')

if [[ "$IMAGE_COUNT" -eq 0 || "$IMAGE_COUNT" == "null" ]]; then
  echo "Error: No images in response" >&2
  echo "$RESULT" | jq '.' >&2
  exit 1
fi

echo "" >&2
echo "Edited $IMAGE_COUNT image(s)" >&2

for i in $(seq 0 $((IMAGE_COUNT - 1))); do
  IMG_URL=$(echo "$RESULT" | jq -r ".images[$i].url")
  DOWNLOADED=$(fal_download "$IMG_URL" "fal-edit-${MODEL}" "$FORMAT")
  echo "Downloaded: $DOWNLOADED" >&2
  echo "$DOWNLOADED"
done

echo "" >&2
echo "Done!" >&2
