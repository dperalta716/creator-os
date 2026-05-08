#!/bin/bash

# Hacker News Search Script
# Searches HN via Algolia API for stories and comments
# API docs: https://hn.algolia.com/api
#
# Usage: ./hn-search.sh "keyword" ["story"|"comment"] ["search_by_date"|"search"] [limit]
# Example: ./hn-search.sh "claude code" "story" "search" 10

if [ $# -lt 1 ]; then
    echo "Usage: $0 \"keyword\" [type] [sort] [limit]"
    echo "  keyword: Search term (required)"
    echo "  type: 'story' or 'comment' (optional, default: story)"
    echo "  sort: 'search' (relevance) or 'search_by_date' (newest) (optional, default: search)"
    echo "  limit: Number of results (optional, default: 15)"
    exit 1
fi

KEYWORD="$1"
TYPE="${2:-story}"
SORT="${3:-search}"
LIMIT="${4:-15}"

# URL-encode the keyword (safe for apostrophes and special chars)
ENCODED_KEYWORD=$(python3 -c "import urllib.parse, sys; print(urllib.parse.quote(sys.argv[1]))" "$KEYWORD")

# Set tags filter based on type
if [ "$TYPE" == "story" ]; then
    TAGS="story"
elif [ "$TYPE" == "comment" ]; then
    TAGS="comment"
else
    TAGS="(story,comment)"
fi

echo "=== HACKER NEWS RESEARCH ==="
echo "Keyword: $KEYWORD"
echo "Type: $TYPE"
echo "Sort: $SORT"
echo "Limit: $LIMIT"
echo ""

# HN Algolia API
curl -s "https://hn.algolia.com/api/v1/${SORT}?query=${ENCODED_KEYWORD}&tags=${TAGS}&hitsPerPage=${LIMIT}" | \
jq -r '
.hits[] |
if .story_text != null or .url != null then
    "[\(.points // 0) pts | \(.num_comments // 0) comments]
Title: \(.title // "N/A")
URL: \(.url // "https://news.ycombinator.com/item?id=\(.objectID)")
HN: https://news.ycombinator.com/item?id=\(.objectID)
Date: \(.created_at[:10])
---"
else
    "[\(.points // 0) pts | comment on: \(.story_title // "N/A")]
Text: \(.comment_text[:300] // "N/A" | gsub("<[^>]*>"; ""))
HN: https://news.ycombinator.com/item?id=\(.objectID)
Date: \(.created_at[:10])
---"
end'

echo ""
echo "=== SEARCH COMPLETE ==="
