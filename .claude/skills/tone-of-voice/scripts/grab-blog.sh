#!/bin/bash

# Grab Blog Article — Tone of Voice Skill
# Fetches a blog article as markdown. Tries WebFetch-friendly curl first,
# falls back to Firecrawl API for JS-heavy or anti-bot sites.
#
# Usage: ./grab-blog.sh "https://example.com/article"
# Output: Article content as markdown to stdout

if [ $# -lt 1 ]; then
    echo "Usage: $0 <article-url>"
    echo "Example: $0 \"https://example.com/my-blog-post\""
    exit 1
fi

URL="$1"
SKILL_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT_DIR="$(cd "$SKILL_DIR/../.." && pwd)"

echo "--- grab-blog: $URL ---" >&2

# Attempt 1: Simple fetch (works for most static blogs)
CONTENT=$(curl -sL -A "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36" \
    --max-time 15 \
    "$URL" 2>/dev/null)

# Check if we got meaningful HTML (more than just a shell/redirect)
CONTENT_LENGTH=${#CONTENT}
if [ "$CONTENT_LENGTH" -gt 2000 ]; then
    echo "$CONTENT"
    echo "--- grab-blog: success via curl ($CONTENT_LENGTH chars) ---" >&2
    exit 0
fi

echo "--- grab-blog: curl returned thin content ($CONTENT_LENGTH chars), trying Firecrawl ---" >&2

# Attempt 2: Firecrawl API
FIRECRAWL_SCRIPT="$PROJECT_DIR/.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh"
if [ -f "$FIRECRAWL_SCRIPT" ]; then
    CONTENT=$("$FIRECRAWL_SCRIPT" "$URL" "markdown" "true" 2>/dev/null)
    CONTENT_LENGTH=${#CONTENT}
    if [ "$CONTENT_LENGTH" -gt 500 ]; then
        echo "$CONTENT"
        echo "--- grab-blog: success via Firecrawl ($CONTENT_LENGTH chars) ---" >&2
        exit 0
    fi
fi

echo "--- grab-blog: all methods failed for $URL ---" >&2
exit 1
