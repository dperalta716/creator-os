#!/bin/bash

# Reddit Search Script
# Searches Reddit for posts matching a keyword in specified subreddits
# Uses Reddit's public JSON API (no auth required)
#
# Usage: ./reddit-search.sh "keyword" ["subreddit1,subreddit2"] ["time_filter"] [limit]
# Example: ./reddit-search.sh "claude code" "ClaudeAI,artificial" "month" 10

if [ $# -lt 1 ]; then
    echo "Usage: $0 \"keyword\" [\"subreddit1,subreddit2\"] [\"time_filter\"] [limit]"
    echo "  keyword: Search term (required)"
    echo "  subreddits: Comma-separated list (optional, default: all)"
    echo "  time_filter: hour, day, week, month, year, all (optional, default: week)"
    echo "  limit: Number of results per subreddit (optional, default: 10, max: 25)"
    exit 1
fi

KEYWORD="$1"
SUBREDDITS="${2:-all}"
TIME_FILTER="${3:-week}"
LIMIT="${4:-10}"

# URL-encode the keyword (safe for apostrophes and special chars)
ENCODED_KEYWORD=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$KEYWORD")

echo "=== REDDIT RESEARCH ==="
echo "Keyword: $KEYWORD"
echo "Subreddits: $SUBREDDITS"
echo "Time filter: $TIME_FILTER"
echo "Limit: $LIMIT"
echo ""

# If specific subreddits provided, search each one
if [ "$SUBREDDITS" != "all" ]; then
    IFS=',' read -ra SUBS <<< "$SUBREDDITS"
    for SUB in "${SUBS[@]}"; do
        SUB=$(echo "$SUB" | xargs)  # trim whitespace
        echo "--- r/$SUB ---"
        curl -s -A "Mozilla/5.0 (Personal Research Bot)" \
            "https://www.reddit.com/r/${SUB}/search.json?q=${ENCODED_KEYWORD}&restrict_sr=1&sort=relevance&t=${TIME_FILTER}&limit=${LIMIT}" | \
        jq -r '
        .data.children[]?.data |
        "[\(.score) pts | \(.num_comments) comments]
Title: \(.title)
URL: https://reddit.com\(.permalink)
Created: \(.created_utc | todate)
Preview: \(.selftext[:200] // "link post")
---"'
        echo ""
        sleep 1  # Rate limiting courtesy
    done
else
    # Search all of Reddit
    echo "--- All Reddit ---"
    curl -s -A "Mozilla/5.0 (Personal Research Bot)" \
        "https://www.reddit.com/search.json?q=${ENCODED_KEYWORD}&sort=relevance&t=${TIME_FILTER}&limit=${LIMIT}" | \
    jq -r '
    .data.children[]?.data |
    "[\(.score) pts | \(.num_comments) comments | r/\(.subreddit)]
Title: \(.title)
URL: https://reddit.com\(.permalink)
Created: \(.created_utc | todate)
Preview: \(.selftext[:200] // "link post")
---"'
fi

echo ""
echo "=== SEARCH COMPLETE ==="
