#!/bin/bash

# Firecrawl Crawl Status - Check async crawl job progress
# Usage: ./firecrawl-crawl-status.sh <job_id>
# Example: ./firecrawl-crawl-status.sh abc123

if [ $# -lt 1 ]; then
    echo "Usage: $0 <job_id>"
    echo "Example: $0 abc123"
    echo ""
    echo "Check the status and retrieve results of a crawl job."
    exit 1
fi

# Firecrawl API credentials (from environment or ~/.env)
if [[ -z "$FIRECRAWL_API_KEY" ]]; then
  [[ -f "$HOME/.env" ]] && source "$HOME/.env"
fi
API_KEY="${FIRECRAWL_API_KEY:?Set FIRECRAWL_API_KEY in environment or ~/.env}"

# Parameters
JOB_ID="$1"
ENDPOINT="https://api.firecrawl.dev/v2/crawl/$JOB_ID"

echo "📊 Checking crawl job status..."
echo "🆔 Job ID: $JOB_ID"
echo ""

# Make API request
curl -s -X GET "$ENDPOINT" \
    -H "Authorization: Bearer $API_KEY" \
    -H "Content-Type: application/json" | jq -r '
if .status then
    "Status: \(.status)",
    if .total then "Total pages: \(.total)" else empty end,
    if .completed then "Completed: \(.completed)" else empty end,
    if .creditsUsed then "Credits used: \(.creditsUsed)" else empty end,
    "\n",

    # If completed, show results
    if .status == "completed" and .data then
        "=== CRAWL RESULTS ===\n",
        (.data | length | "\nScraped \(.) pages:\n"),
        (.data[] | "\n--- Page: \(.metadata.url // "Unknown") ---", "\n\(.markdown // .html // "No content")\n")
    elif .status == "scraping" then
        "⏳ Crawl still in progress. Check again in 30-60 seconds."
    elif .status == "failed" then
        "❌ Crawl failed: \(.error // "Unknown error")"
    else
        "Status: \(.status)"
    end
else
    "❌ Error: " + (.error // "Unknown error or invalid job ID")
end
'

echo ""
echo "✅ Status check complete"
