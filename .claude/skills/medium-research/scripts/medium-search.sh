#!/bin/bash

# Medium Article Search Script
# Uses DataForSEO to find top-ranking Medium articles for a keyword
# This is effectively a Google "site:medium.com" search
#
# Usage: ./medium-search.sh "keyword" [limit]
# Example: ./medium-search.sh "claude code tutorial" 10

if [ $# -lt 1 ]; then
    echo "Usage: $0 \"keyword\" [limit]"
    echo "  keyword: Topic to search for on Medium (required)"
    echo "  limit: Number of results (optional, default: 10)"
    exit 1
fi

KEYWORD="site:medium.com $1"
LIMIT="${2:-10}"

# DataForSEO API credentials (from environment or ~/.env)
if [[ -z "$DATAFORSEO_USER" || -z "$DATAFORSEO_PASS" ]]; then
  [[ -f "$HOME/.env" ]] && source "$HOME/.env"
fi
USERNAME="${DATAFORSEO_USER:?Set DATAFORSEO_USER in environment or ~/.env}"
PASSWORD="${DATAFORSEO_PASS:?Set DATAFORSEO_PASS in environment or ~/.env}"

# API endpoint
ENDPOINT="https://api.dataforseo.com/v3/serp/google/organic/live/advanced.ai"

# Request payload
PAYLOAD="[{
    \"keyword\": \"$KEYWORD\",
    \"language_code\": \"en\",
    \"location_name\": \"United States\",
    \"depth\": $LIMIT
}]"

echo "=== MEDIUM RESEARCH ==="
echo "Searching Medium for: $1"
echo "Results: $LIMIT"
echo ""

curl -s -u "$USERNAME:$PASSWORD" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$PAYLOAD" \
    "$ENDPOINT" | \
jq -r '
.items[] |
select(.type == "organic") |
"--- ARTICLE #\(.rank_absolute) ---
Title: \(.title // "N/A")
URL: \(.url // "N/A")
Description: \(.description // "N/A")
"'

echo "=== SEARCH COMPLETE ==="
echo ""
echo "To scrape a specific article, use Firecrawl:"
echo "  ./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh \"[URL]\" \"markdown\" \"true\""
