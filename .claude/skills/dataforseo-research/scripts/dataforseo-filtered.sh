#!/bin/bash

# DataForSEO Filtered SERP Research Script
# Fallback method for when MCP server exceeds token limits
# 
# Usage: ./dataforseo-filtered.sh "keyword" "language_code" "location"
# Example: ./dataforseo-filtered.sh "ultra processed foods" "en" "United States"

# Check if all arguments are provided
if [ $# -ne 3 ]; then
    echo "Usage: $0 \"keyword\" \"language_code\" \"location\""
    echo "Example: $0 \"ultra processed foods\" \"en\" \"United States\""
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

# API endpoint (using .ai for token reduction)
ENDPOINT="https://api.dataforseo.com/v3/serp/google/organic/live/advanced.ai"

# Request payload
PAYLOAD="[{
    \"keyword\": \"$KEYWORD\",
    \"language_code\": \"$LANGUAGE_CODE\",
    \"location_name\": \"$LOCATION\",
    \"depth\": 10
}]"

echo "🔍 Fetching filtered SERP data for: $KEYWORD"
echo "📍 Location: $LOCATION | Language: $LANGUAGE_CODE"
echo "🚀 Using .ai endpoint for token optimization..."
echo ""

# Make the API request and filter results
curl -s -u "$USERNAME:$PASSWORD" \
    -H "Content-Type: application/json" \
    -X POST \
    -d "$PAYLOAD" \
    "$ENDPOINT" | \
jq -r '
# Extract the items array (AI endpoint uses different structure)
.items[] |

# Filter to only include desired SERP types
select(.type == "organic" or 
       .type == "people_also_ask" or 
       .type == "related_searches" or 
       .type == "top_stories" or 
       .type == "ai_overview" or 
       .type == "discussions_and_forums" or 
       .type == "featured_snippet") |

# Format the output nicely
if .type == "organic" then
    "=== ORGANIC RESULT #\(.rank_absolute) ===
Title: \(.title // "N/A")
URL: \(.url // "N/A") 
Domain: \(.domain // "N/A")
Description: \(.description // "N/A")
"
elif .type == "people_also_ask" then
    "=== PEOPLE ALSO ASK ===
Questions: \(.items[]?.title // "N/A")
"
elif .type == "related_searches" then
    "=== RELATED SEARCHES ===
Terms: \(.items[]? // "N/A")
"
elif .type == "top_stories" then
    "=== TOP STORIES ===
Story: \(.items[]?.title // "N/A") - \(.items[]?.source // "N/A")
"
elif .type == "ai_overview" then
    "=== AI OVERVIEW ===
Text: \(.text // "N/A")
"
elif .type == "discussions_and_forums" then
    "=== DISCUSSIONS & FORUMS ===
Title: \(.title // "N/A")
URL: \(.url // "N/A")
"
elif .type == "featured_snippet" then
    "=== FEATURED SNIPPET ===
Title: \(.title // "N/A")
Description: \(.description // "N/A")
URL: \(.url // "N/A")
"
else
    empty
end'

echo ""
echo "✅ Filtered results complete. Token count significantly reduced."
echo "🔧 This fallback method keeps only essential SERP types:"
echo "   • organic, people_also_ask, related_searches"
echo "   • top_stories, ai_overview, discussions_and_forums, featured_snippet"