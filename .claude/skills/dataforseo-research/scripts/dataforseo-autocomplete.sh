#!/bin/bash

# DataForSEO Google Autocomplete Script
# Returns raw autocomplete suggestions from Google
# Perfect for "[Brand] vs" searches to find comparison keywords
#
# Usage: ./dataforseo-autocomplete.sh "keyword" "language_code" "location" [limit]
# Example: ./dataforseo-autocomplete.sh "Ritual vs" "en" "United States" 15
#
# Note: Does NOT include search volume - use dataforseo-autocomplete-with-volume.sh for that

# Check minimum arguments
if [ $# -lt 3 ]; then
    echo "Usage: $0 \"keyword\" \"language_code\" \"location\" [limit]"
    echo "Example: $0 \"Ritual vs\" \"en\" \"United States\" 15"
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
LIMIT="${4:-15}"  # Default to 15 results

# API endpoint (using .ai for token optimization)
ENDPOINT="https://api.dataforseo.com/v3/serp/google/autocomplete/live/advanced.ai"

# Request payload
PAYLOAD="[{
    \"keyword\": \"$KEYWORD\",
    \"language_code\": \"$LANGUAGE_CODE\",
    \"location_name\": \"$LOCATION\"
}]"

echo "🔍 Fetching Google Autocomplete suggestions for: \"$KEYWORD\""
echo "📍 Location: $LOCATION | Language: $LANGUAGE_CODE | Limit: $LIMIT"
echo ""

# Make the API request and format results
# .ai endpoint returns flatter structure: .items[] directly
curl -s -u "$USERNAME:$PASSWORD" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$PAYLOAD" \
    "$ENDPOINT" | \
jq -r --argjson limit "$LIMIT" '
.items // [] |
.[0:$limit] |
to_entries[] |
"\(.key + 1). \(.value.title // .value.suggestion // "N/A")"
'

echo ""
echo "✅ Autocomplete suggestions retrieved."
echo "💡 Tip: Use dataforseo-suggestions.sh for keywords with volume data."
