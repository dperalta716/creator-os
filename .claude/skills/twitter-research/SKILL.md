---
name: twitter-research
description: Search Twitter/X for AI tool discussions via Grok (xAI) API. Use for topic discovery — what's trending, what questions people are asking, what features are generating buzz.
argument-hint: topic (e.g., "claude code" or "What are people saying about Suno AI this week?")
user-invocable: true
---

# Twitter/X Research (via Grok)

Search Twitter/X for trending discussions about AI tools using Grok's real-time X access. Returns a structured summary of what people are talking about.

## Usage

```
/twitter-research claude code
```

## Prerequisites

Requires `XAI_API_KEY` environment variable. Get one at https://console.x.ai/

Set it:
```bash
export XAI_API_KEY='your-key-here'
```

Or save to `~/.config/xai/.env`:
```
XAI_API_KEY=your-key-here
```

## How It Works

1. Sends query to Grok API (grok-4-1-fast-non-reasoning) via `/v1/responses` endpoint with `x_search` tool
2. Grok searches real-time X posts with semantic and keyword search
3. Returns structured brief with citations to specific posts

## Script

```bash
./.claude/skills/twitter-research/scripts/grok-search.sh "query"
```

**Parameters:**
- `query` (required): Natural language question about Twitter discourse

## Recommended Queries for Topic Discovery

```bash
./grok-search.sh "What are people discussing about Claude Code on Twitter this week? What questions are they asking, what frustrations do they have, what tips are they sharing?"
./grok-search.sh "What's trending on AI Twitter about image generation with ChatGPT and Gemini this week?"
./grok-search.sh "What are indie hackers and builders saying about AI tools on Twitter? Any new workflows or products people are excited about?"
./grok-search.sh "What complaints or frustrations are people expressing about Suno AI on Twitter?"
./grok-search.sh "What AI tool announcements or releases are generating the most buzz on Twitter this week?"
```

## Interpreting Results

Grok returns a synthesized brief. Look for:
- **Repeated themes** = sustained interest (not just one viral post)
- **Questions without good answers** = article opportunity
- **Feature announcements + confusion** = "How to use X" article opportunity
- **Frustration patterns** = "Here's how to solve X" article opportunity
- **Builder showcases** = "How I built X with Y" article angle
