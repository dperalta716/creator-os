#!/bin/bash

# DataForSEO Related Keywords Script
# Returns semantically related keywords from Google's "searches related to" feature
# Includes search volume, CPC, and competition data
#
# Usage: ./dataforseo-related.sh "keyword" "language_code" "location" [limit] [depth]
# Example: ./dataforseo-related.sh "sleep supplements" "en" "United States" 20 2
#
# Depth: 0-4 (higher = more results, more related terms)
#   0 = direct related searches only
#   1 = one level deep (default)
#   2 = two levels deep
#   3-4 = very broad, many results

# Check minimum arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 \"keyword\" \"language_code\" \"location\" [limit] [depth]"
    echo "Example: $0 \"sleep supplements\" \"en\" \"United States\" 20 2"
    echo ""
    echo "Depth levels:"
    echo "  0 = direct related searches only"
    echo "  1 = one level deep (default)"
    echo "  2 = two levels deep"
    echo "  3-4 = very broad exploration"
    exit 1
fi

# DataForSEO API credentials (from environment or ~/.env)
if [[ -z "$DATAFORSEO_USER" || -z "$DATAFORSEO_PASS" ]]; then
  [[ -f "$HOME/.env" ]] && source "$HOME/.env"
fi
USERNAME="${DATAFORSEO_USER:?Set DATAFORSEO_USER in environment or ~/.env}"
PASSWORD="${DATAFORSEO_PASS:?Set DATAFORSEO_PASS in environment or ~/.env}"

# Parameters
KEYWORD="$1"
LANGUAGE_CODE="$2"
LOCATION="$3"
LIMIT="${4:-20}"  # Default to 20 results
DEPTH="${5:-1}"   # Default depth of 1

# API endpoint (using .ai for token optimization)
ENDPOINT="https://api.dataforseo.com/v3/dataforseo_labs/google/related_keywords/live.ai"

# Request payload
PAYLOAD="[{
    \"keyword\": \"$KEYWORD\",
    \"language_code\": \"$LANGUAGE_CODE\",
    \"location_name\": \"$LOCATION\",
    \"include_seed_keyword\": true,
    \"depth\": $DEPTH,
    \"limit\": $LIMIT,
    \"order_by\": [\"keyword_data.keyword_info.search_volume,desc\"]
}]"

echo "🔍 Fetching related keywords for: \"$KEYWORD\""
echo "📍 Location: $LOCATION | Language: $LANGUAGE_CODE"
echo "📊 Limit: $LIMIT | Depth: $DEPTH"
echo ""
echo "KEYWORD | VOLUME | CPC | COMPETITION"
echo "--------|--------|-----|------------"

# Make the API request and format results
# .ai endpoint returns flatter structure: .items[] directly
curl -s -u "$USERNAME:$PASSWORD" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$PAYLOAD" \
    "$ENDPOINT" | \
jq -r '
.items // [] |
.[] |
"\(.keyword_data.keyword) | \(.keyword_data.keyword_info.search_volume // 0) | $\(.keyword_data.keyword_info.cpc // 0 | . * 100 | floor / 100) | \(.keyword_data.keyword_info.competition // 0 | . * 100 | floor)%"
'

echo ""
echo "✅ Related keywords retrieved."
echo "💡 Increase depth (1-4) for broader keyword exploration."
