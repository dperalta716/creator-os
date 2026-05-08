#!/bin/bash

# Firecrawl Scrape - Single Page Content Extraction
# Usage: ./firecrawl-scrape.sh "https://example.com" [format] [onlyMainContent]
# Example: ./firecrawl-scrape.sh "https://firecrawl.dev" "markdown" "true"

if [ $# -lt 1 ]; then
    echo "Usage: $0 <url> [format] [onlyMainContent]"
    echo "Example: $0 \"https://example.com\" \"markdown\" \"true\""
    echo ""
    echo "Parameters:"
    echo "  url: Target webpage to scrape (required)"
    echo "  format: Output format - markdown, html, or rawHtml (default: markdown)"
    echo "  onlyMainContent: Filter to main content only - true or false (default: true)"
    exit 1
fi

# Firecrawl API credentials (from environment or ~/.env)
if [[ -z "$FIRECRAWL_API_KEY" ]]; then
  [[ -f "$HOME/.env" ]] && source "$HOME/.env"
fi
API_KEY="${FIRECRAWL_API_KEY:?Set FIRECRAWL_API_KEY in environment or ~/.env}"
ENDPOINT="https://api.firecrawl.dev/v2/scrape"

# Parameters
URL="$1"
FORMAT="${2:-markdown}"
ONLY_MAIN="${3:-true}"

echo "🔥 Firecrawl Scrape"
echo "📄 URL: $URL"
echo "📋 Format: $FORMAT"
echo "🎯 Main content only: $ONLY_MAIN"
echo ""

# Build JSON payload
PAYLOAD=$(cat <<EOF
{
  "url": "$URL",
  "formats": ["$FORMAT"],
  "onlyMainContent": $ONLY_MAIN
}
EOF
)

# Make API request
curl -s -X POST "$ENDPOINT" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" \
    -d "$PAYLOAD" | jq -r '
if .success == true then
    if .data.markdown then
        "=== SCRAPED CONTENT (Markdown) ===\n\n" + .data.markdown
    elif .data.html then
        "=== SCRAPED CONTENT (HTML) ===\n\n" + .data.html
    else
        "=== SCRAPED CONTENT ===\n\n" + (.data | tostring)
    end
else
    "❌ Error: " + (.error // "Unknown error")
end
'

echo ""
echo "✅ Scrape complete"
