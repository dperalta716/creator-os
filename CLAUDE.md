# Content SEO Vault -- Claude Code Instructions

## Project Overview

This is [Your Name]'s personal content-to-products system. Medium articles about [your niche] -> organic traffic -> Gumroad digital product sales.

## Vault Structure

- `00-Dashboard/` -- Overview and links
- `01-Topic-Discovery/` -- Intelligence reports and topic queue
- `02-Articles/` -- Research, drafts, and published article tracking
- `03-Products/` -- Digital product development and performance
- `04-Strategy/` -- Content pillars, competitor analysis, monthly reviews
- `05-Learnings/` -- Personal notes (brain dumps) and external learnings (videos, etc.)
- `Reference/` -- Voice guide, Medium SEO notes

## Skills Available

- `/topic-discovery` -- Run full intelligence pipeline (Reddit + HN + Medium + Twitter)
- `/reddit-research [keyword]` -- Search Reddit for posts/questions
- `/hn-research [keyword]` -- Search Hacker News for stories/discussions
- `/medium-research [keyword]` -- Find top-ranking Medium articles
- `/twitter-research [topic]` -- Search Twitter/X via Grok API
- `/dataforseo-research` -- SERP analysis and keyword data (see skill for sub-scripts)
- `/firecrawl-scraper` -- Web scraping for competitor articles

## Key Conventions

- All research outputs go to the vault as markdown files, never just in conversation
- Article folders are numbered sequentially: `001-slug/`, `002-slug/`, etc.
- Topic Queue is the single source of truth for "what to write next"
- Intelligence reports are dated: `YYYY-MM-DD-intel.md`
- Voice and tone: see `Reference/Voice-Guide.md`

## Content Pillars

See `04-Strategy/Content-Pillars.md` for your content pillars. Run `/setup` to configure these for your niche.
