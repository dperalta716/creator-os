---
name: reddit-research
description: Search Reddit for trending posts, questions, and discussions about AI tools. Use for topic discovery (what are people asking?) and per-article research (what does the community say about a specific keyword?).
argument-hint: keyword (e.g., "claude code custom commands")
user-invocable: true
---

# Reddit Research

Search Reddit for posts, questions, and discussions matching a keyword. Returns titles, scores, comment counts, and preview text — enough to identify trending topics and common questions.

## Usage

```
/reddit-research claude code tips
```

## How It Works

1. Searches specified subreddits (or all Reddit) via public JSON API
2. Returns posts sorted by relevance within the time window
3. Extracts: title, score, comment count, creation date, text preview

## Script

```bash
./.claude/skills/reddit-research/scripts/reddit-search.sh "keyword" "subreddit1,subreddit2" "time_filter" limit
```

**Parameters:**
- `keyword` (required): Search term
- `subreddits` (optional): Comma-separated list. Default: `ClaudeAI,ChatGPT,artificial,SEO,content_marketing,Blogging,SideProject`
- `time_filter` (optional): `hour`, `day`, `week`, `month`, `year`, `all`. Default: `week`
- `limit` (optional): Results per subreddit, 1-25. Default: `10`

## Default Subreddits (AI Tools Niche)

When called from topic-discovery without specific subreddits, search these:
- r/ClaudeAI — Claude and Claude Code discussions
- r/ChatGPT — ChatGPT usage, tips, image generation
- r/artificial — General AI news and tools
- r/SEO — search optimization and ranking discussions
- r/content_marketing — content strategy and distribution
- r/Blogging — blogging, traffic, and monetization
- r/SideProject — What people are building with AI

## Interpreting Results

- **High score + many comments** = hot topic, strong engagement signal
- **Questions in titles** = direct article topic candidates
- **Repeated themes across posts** = sustained demand (not just a spike)
- **Frustration/complaints** = opportunity for a "here's how to actually do X" article

## Output Format

For each post:
```
[Score | Comments | Subreddit]
Title: [post title]
URL: [permalink]
Created: [date]
Preview: [first 200 chars of post text]
```
