# Creator OS

An Obsidian vault template powered by Claude Code skills that runs a complete content-to-products pipeline. Automated topic discovery, keyword research, competitive analysis, article generation with voice enforcement, post-draft review with claims verification, and image generation -- all from your terminal. Write Medium articles that drive organic traffic toward digital product sales or email signups.

## What's Included

12+ Claude Code skills covering the full pipeline from discovery through publishing. Automated competitive analysis via DataForSEO and Firecrawl. Voice enforcement that keeps every draft on-brand. A claims verification pass that flags unsupported statements. Ready-to-use Obsidian vault structure with numbered article folders, a topic queue, strategy docs, and a learning journal.

## Prerequisites

- **Claude Code** with a Max or Pro subscription (needed for the AI capabilities)
- **Obsidian** (free) for viewing and editing the vault
- **API keys** for DataForSEO and Firecrawl at minimum (see below)
- **macOS or Linux** -- the shell scripts use bash

## Quick Start

```
git clone [repo-url]
cd creator-os

# Open in Claude Code
claude

# Run the guided setup
/setup
```

The `/setup` skill explains everything and walks you through configuration interactively.

## API Keys

| Key | Required? | What It Powers | Sign Up |
|-----|-----------|----------------|---------|
| `DATAFORSEO_USER` + `DATAFORSEO_PASS` | Yes | Keyword research, SERP analysis, Medium search | https://dataforseo.com/ |
| `FIRECRAWL_API_KEY` | Yes | Scraping competitor articles | https://firecrawl.dev/ |
| `XAI_API_KEY` | Optional | Twitter/X research via Grok | https://console.x.ai/ |
| fal.ai key | Optional | AI image generation for articles | https://fal.ai/ |

Keys go in `~/.env` (see `.env.example`). The fal.ai key goes in `.claude/skills/fal-ai/fal-api-key`.

## The Pipeline

```
Topic Discovery (/topic-discovery)
  └─ Reddit + Twitter research → pain points by content pillar
       └─ Keyword Research (DataForSEO) → validate search demand
            └─ SERP Clustering → decide article boundaries
                 └─ Article Generation (/generate-article)
                      └─ Competitive analysis → content gaps → draft with voice enforcement
                           └─ Review Pipeline (/review-article)
                                └─ Unique value check → claims verification → internal linking
                                     └─ Image Generation (/generate-article-images)
                                          └─ Whiteboard-style diagrams with A/B picks
                                               └─ Publish to Medium
```

## Skills Reference

| Skill | Description |
|-------|-------------|
| `/setup` | Interactive guided setup (start here) |
| `/topic-discovery` | Full discovery pipeline: Reddit + Twitter, keywords, SERP clustering |
| `/reddit-research [keyword]` | Search Reddit for posts and questions |
| `/hn-research [keyword]` | Search Hacker News |
| `/twitter-research [topic]` | Twitter/X research via Grok API |
| `/medium-research [keyword]` | Find top-ranking Medium articles |
| `/dataforseo-research` | Keyword toolkit: suggestions, volume, SERP, related, autocomplete |
| `/firecrawl-scraper` | Web scraping to markdown |
| `/generate-article` | End-to-end article creation with competitive analysis |
| `/review-article` | Post-draft review: quality, SEO, claims verification, voice enforcement |
| `/generate-article-images` | Whiteboard-style diagram generation |
| `/product-research` | Market research for digital products |
| `/product-draft` | (Coming soon) Product drafting from research |

## Folder Structure

```
creator-os/
├── 00-Dashboard/          # Home base and overview
├── 01-Topic-Discovery/    # Research reports and topic queue
├── 02-Articles/
│   ├── In-Progress/       # Active drafts (numbered: 001-slug/)
│   └── Published/         # Completed articles
├── 03-Products/
│   └── Active/            # Products in development
├── 04-Strategy/           # Content pillars, competitor analysis, reviews
├── 05-Learnings/          # Personal notes and external learnings
├── Reference/             # Voice guide, SEO notes, source tiers
├── .claude/skills/        # All Claude Code skills
└── .env.example           # API key template
```

## Getting Started

Run `/setup` to get started. The guided setup explains everything and configures the vault for your niche.

The system creator's content pillars are included as worked examples in `04-Strategy/Content-Pillars.md` -- the setup wizard will replace them with yours.

---

Built by David Peralta.
