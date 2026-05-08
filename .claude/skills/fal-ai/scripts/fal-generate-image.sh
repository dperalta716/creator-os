#!/bin/bash
# Generate images using fal.ai
# Usage: fal-generate-image.sh "prompt" [model] [size] [quality] [format] [num_images]

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
source "${SCRIPT_DIR}/lib/fal-common.sh"
load_fal_key

if [[ $# -lt 1 ]]; then
  cat <<'USAGE'
Usage: fal-generate-image.sh "prompt" [model] [size] [quality] [format] [num_images]

Models:
  gpt2        GPT Image 2 (default) — best text rendering, $0.006-$0.21/img
  banana      Nano Banana (original) — artistic/experimental, ~$0.04/img
  banana2     Nano Banana 2 — fast production work, ~$0.08/img
  banana-pro  Nano Banana Pro — highest quality compositions, ~$0.15/img

Size:     1024x1024 (default), WxH, or aspect ratio (16:9, 4:3, etc.)
Quality:  low (default), medium, high — GPT Image 2 only
Format:   png (default), jpeg, webp
USAGE
  exit 1
fi

PROMPT="$1"
MODEL="${2:-gpt2}"
SIZE="${3:-1024x1024}"
QUALITY="${4:-low}"
FORMAT="${5:-png}"
NUM_IMAGES="${6:-1}"

ENDPOINT=$(resolve_endpoint "$MODEL" "generate")

echo "fal.ai Image Generation" >&2
echo "Prompt: ${PROMPT:0:80}$([ ${#PROMPT} -gt 80 ] && echo '...')" >&2
echo "Model: $MODEL ($ENDPOINT)" >&2
echo "Size: $SIZE | Quality: $QUALITY | Format: $FORMAT" >&2
echo "" >&2

PAYLOAD_FILE=$(mktemp)
trap 'rm -f "$PAYLOAD_FILE"' EXIT

if [[ "$ENDPOINT" == "openai/gpt-image-2" ]]; then
  if [[ "$SIZE" == *"x"* ]]; then
    W="${SIZE%%x*}"
    H="${SIZE##*x}"
    SIZE_JSON="{\"width\": $W, \"height\": $H}"
  else
    SIZE_JSON="\"$SIZE\""
  fi

  PROMPT_ESCAPED=$(printf '%s' "$PROMPT" | jq -Rs .)

  cat > "$PAYLOAD_FILE" <<EOF
{
  "prompt": $PROMPT_ESCAPED,
  "image_size": $SIZE_JSON,
  "quality": "$QUALITY",
  "num_images": $NUM_IMAGES,
  "output_format": "$FORMAT"
}
EOF

else
  # Nano Banana models use aspect_ratio + resolution
  if [[ "$SIZE" == *"x"* ]]; then
    W="${SIZE%%x*}"
    H="${SIZE##*x}"
    if [[ $W -eq $H ]]; then
      ASPECT="1:1"
    elif [[ $((W * 9)) -eq $((H * 16)) ]]; then
      ASPECT="16:9"
    elif [[ $((W * 16)) -eq $((H * 9)) ]]; then
      ASPECT="9:16"
    elif [[ $((W * 3)) -eq $((H * 4)) ]]; then
      ASPECT="4:3"
    elif [[ $((W * 4)) -eq $((H * 3)) ]]; then
      ASPECT="3:4"
    else
      ASPECT="auto"
    fi
    if [[ $W -le 600 && $H -le 600 ]]; then
      RES="0.5K"
    elif [[ $W -le 1200 && $H -le 1200 ]]; then
      RES="1K"
    elif [[ $W -le 2400 && $H -le 2400 ]]; then
      RES="2K"
    else
      RES="4K"
    fi
  elif [[ "$SIZE" == *":"* ]]; then
    ASPECT="$SIZE"
    RES="1K"
  else
    ASPECT="1:1"
    RES="1K"
  fi

  PROMPT_ESCAPED=$(printf '%s' "$PROMPT" | jq -Rs .)

  # Nano Banana original has no resolution param
  if [[ "$ENDPOINT" == "fal-ai/nano-banana" ]]; then
    cat > "$PAYLOAD_FILE" <<EOF
{
  "prompt": $PROMPT_ESCAPED,
  "aspect_ratio": "$ASPECT",
  "num_images": $NUM_IMAGES,
  "output_format": "$FORMAT"
}
EOF
  else
    cat > "$PAYLOAD_FILE" <<EOF
{
  "prompt": $PROMPT_ESCAPED,
  "aspect_ratio": "$ASPECT",
  "resolution": "$RES",
  "num_images": $NUM_IMAGES,
  "output_format": "$FORMAT",
  "safety_tolerance": 6
}
EOF
  fi
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
echo "Generated $IMAGE_COUNT image(s)" >&2

for i in $(seq 0 $((IMAGE_COUNT - 1))); do
  IMG_URL=$(echo "$RESULT" | jq -r ".images[$i].url")
  DOWNLOADED=$(fal_download "$IMG_URL" "fal-${MODEL}" "$FORMAT")
  echo "Downloaded: $DOWNLOADED" >&2
  echo "$DOWNLOADED"
done

echo "" >&2
echo "Done!" >&2
