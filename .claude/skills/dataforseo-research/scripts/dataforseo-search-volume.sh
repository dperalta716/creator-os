#!/bin/bash

# DataForSEO Search Volume Script
# Returns search volume, CPC, and competition for a list of keywords
# Can accept up to 700 keywords in a single request
#
# Usage: ./dataforseo-search-volume.sh "keyword1,keyword2,keyword3" "language_code" "location"
# Example: ./dataforseo-search-volume.sh "ritual vs athletic greens,ritual vs seed,ritual vs care of" "en" "United States"
#
# Returns: keyword, search_volume, cpc, competition, monthly_searches trend

# Check minimum arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 \"keyword1,keyword2,keyword3\" \"language_code\" \"location\""
    echo "Example: $0 \"ritual vs athletic greens,ritual vs seed\" \"en\" \"United States\""
    echo ""
    echo "Keywords should be comma-separated (max 700 keywords)"
    exit 1
fi

# DataForSEO API credentials (from environment or ~/.env)
if [[ -z "$DATAFORSEO_USER" || -z "$DATAFORSEO_PASS" ]]; then
  [[ -f "$HOME/.env" ]] && source "$HOME/.env"
fi
USERNAME="${DATAFORSEO_USER:?Set DATAFORSEO_USER in environment or ~/.env}"
PASSWORD="${DATAFORSEO_PASS:?Set DATAFORSEO_PASS in environment or ~/.env}"

# Parameters
KEYWORDS_INPUT="$1"
LANGUAGE_CODE="$2"
LOCATION="$3"

# Convert comma-separated keywords to JSON array
KEYWORDS_JSON=$(echo "$KEYWORDS_INPUT" | tr ',' '\n' | sed 's/^[[:space:]]*//;s/[[:space:]]*$//' | jq -R . | jq -s .)

# API endpoint (using .ai for token optimization)
ENDPOINT="https://api.dataforseo.com/v3/dataforseo_labs/google/historical_search_volume/live.ai"

# Request payload
PAYLOAD=$(jq -n \
    --argjson keywords "$KEYWORDS_JSON" \
    --arg lang "$LANGUAGE_CODE" \
    --arg loc "$LOCATION" \
    '[{
        "keywords": $keywords,
        "language_code": $lang,
        "location_name": $loc
    }]')

# Count keywords
KEYWORD_COUNT=$(echo "$KEYWORDS_JSON" | jq 'length')

echo "🔍 Fetching search volume for $KEYWORD_COUNT keyword(s)"
echo "📍 Location: $LOCATION | Language: $LANGUAGE_CODE"
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
"\(.keyword) | \(.keyword_info.search_volume // 0) | $\(.keyword_info.cpc // 0 | . * 100 | floor / 100) | \(.keyword_info.competition // 0 | . * 100 | floor)%"
'

echo ""
echo "✅ Search volume data retrieved."
