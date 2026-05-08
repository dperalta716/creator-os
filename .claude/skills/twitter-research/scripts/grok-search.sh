#!/bin/bash

# Twitter/X Research via Grok (xAI) API
# Uses Grok's real-time X search to find AI tool discussions
#
# Usage: ./grok-search.sh "topic"
# Example: ./grok-search.sh "What are people saying about Claude Code on Twitter this week?"
#
# Requires: XAI_API_KEY environment variable

if [ $# -lt 1 ]; then
    echo "Usage: $0 \"topic/question about Twitter discourse\""
    echo "Example: $0 \"What are people discussing about Claude Code on Twitter this week?\""
    exit 1
fi

# Check for API key
if [ -z "$XAI_API_KEY" ]; then
    # Try loading from common locations
    [ -f ~/.config/xai/.env ] && source ~/.config/xai/.env
    [ -f ~/.env ] && export $(grep -i XAI_API_KEY ~/.env 2>/dev/null | xargs)
fi

if [ -z "$XAI_API_KEY" ]; then
    echo "ERROR: XAI_API_KEY not set."
    echo "Get an API key at https://console.x.ai/"
    echo "Then: export XAI_API_KEY='your-key-here'"
    exit 1
fi

QUERY="$1"

# Build JSON payload safely using jq to handle special characters
PAYLOAD=$(jq -n \
    --arg query "$QUERY" \
    '{
        "model": "grok-4-1-fast-non-reasoning",
        "input": [
            {
                "role": "system",
                "content": "You are a research assistant with real-time access to X/Twitter. Your job is to summarize what people are discussing about AI tools. Focus on: trending topics, common questions, frustrations, feature requests, and hot takes. Be specific — include approximate engagement levels and paraphrase actual posts. Format as a structured research brief."
            },
            {
                "role": "user",
                "content": $query
            }
        ],
        "tools": [{"type": "x_search"}]
    }')

echo "=== TWITTER/X RESEARCH (via Grok) ==="
echo "Query: $QUERY"
echo ""

curl -s "https://api.x.ai/v1/responses" \
    -H "Authorization: Bearer $XAI_API_KEY" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" | jq -r '.output[] | select(.type == "message") | .content[] | select(.type == "output_text") | .text'

echo ""
echo "=== SEARCH COMPLETE ==="
