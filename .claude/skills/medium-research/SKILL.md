---
name: medium-research
description: Find top-performing Medium articles in the AI tools niche. Uses DataForSEO site:medium.com search to discover what's ranking, then optionally scrapes articles via Firecrawl for deeper analysis.
argument-hint: keyword (e.g., "claude code workflow")
user-invocable: true
---

# Medium Research

Find top-performing Medium articles for a given keyword using Google site:medium.com search. Identifies what's already ranking and performing well — direct competitor intelligence.

## Usage

```
/medium-research claude code tips
```

## How It Works

1. Runs `site:medium.com [keyword]` search via DataForSEO
2. Returns top-ranking Medium articles with titles, URLs, and descriptions
3. Optionally: scrape specific articles via Firecrawl for full content analysis

## Scripts

### Find top Medium articles
```bash
./.claude/skills/medium-research/scripts/medium-search.sh "keyword" [limit]
```

**Parameters:**
- `keyword` (required): Topic to search for on Medium
- `limit` (optional): Number of results, default 10

### Scrape a specific article (follow-up)
```bash
./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "[medium_url]" "markdown" "true"
```

## Two-Step Workflow

**Step 1 — Find articles:**
```bash
./.claude/skills/medium-research/scripts/medium-search.sh "suno ai prompts"
```

**Step 2 — Scrape top performers for analysis:**
```bash
./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "https://medium.com/@author/article-slug" "markdown" "true"
```

## Interpreting Results

- **Top 3 positions** = strong articles with proven SEO — study their structure, headlines, and angles
- **Multiple articles on same topic** = validated demand (good keyword to target)
- **Thin/low-quality top results** = easy to outrank with better content
- **No results** = either no demand or opportunity to be first

## Recommended Searches for Topic Discovery

```bash
./medium-search.sh "claude code" 10
./medium-search.sh "suno ai" 10
./medium-search.sh "ai workflow automation" 10
./medium-search.sh "wispr flow" 5
./medium-search.sh "groq whisper" 5
./medium-search.sh "chatgpt image generation" 10
./medium-search.sh "nano banana gemini" 5
```
