---
name: hn-research
description: Search Hacker News for trending stories and discussions about AI tools. Use for topic discovery (what's the tech community discussing?) and identifying angles that resonate with builders/developers.
argument-hint: keyword (e.g., "claude code")
user-invocable: true
---

# Hacker News Research

Search Hacker News via Algolia API for stories and comments matching a keyword. Returns titles, points, comment counts, and links.

## Usage

```
/hn-research claude code
```

## How It Works

1. Queries HN Algolia API (free, no auth, no rate limits for reasonable use)
2. Returns stories or comments sorted by relevance or date
3. Extracts: title, points, comment count, URL, date

## Script

```bash
./.claude/skills/hn-research/scripts/hn-search.sh "keyword" "story|comment" "search|search_by_date" limit
```

**Parameters:**
- `keyword` (required): Search term
- `type` (optional): `story` or `comment`. Default: `story`
- `sort` (optional): `search` (relevance) or `search_by_date` (newest). Default: `search`
- `limit` (optional): Number of results, 1-50. Default: `15`

## Recommended Searches for Topic Discovery

Run these to find what the tech community is discussing:
```bash
./hn-search.sh "Claude" "story" "search_by_date" 10
./hn-search.sh "Claude Code" "story" "search" 10
./hn-search.sh "AI workflow" "story" "search" 10
./hn-search.sh "Suno" "story" "search" 5
./hn-search.sh "speech to text" "story" "search_by_date" 10
```

## Interpreting Results

- **High points (100+)** = strong community interest, worth writing about
- **Many comments (50+)** = contentious or deeply interesting topic
- **Recent + high engagement** = time-sensitive opportunity
- **Comments > story views** = people have opinions/questions (great for "here's what I think" articles)

## Output Format

For stories:
```
[Points | Comments]
Title: [story title]
URL: [external URL]
HN: [discussion link]
Date: [YYYY-MM-DD]
```

For comments:
```
[Points | comment on: story title]
Text: [first 300 chars of comment, HTML stripped]
HN: [comment link]
Date: [YYYY-MM-DD]
```
