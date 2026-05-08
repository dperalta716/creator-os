---
name: product-research
description: Run the full product research pipeline — pain point validation, keyword demand, competitor scan, and deep content research across Reddit, Twitter, HN, YouTube, GitHub, official docs, and web directories. Outputs a master catalog and synthesis document ready for drafting.
---

# Product Research Pipeline

End-to-end research pipeline for Gumroad digital products. Takes a product topic and produces a validated, deduplicated master catalog of everything relevant — organized for knowledge workers.

## Usage

```
/product-research [product topic]
```

Example: `/product-research claude code skills`

## Prerequisites

- Product folder must exist at `03-Products/Active/[product-slug]/`
- Product spec must exist at `03-Products/Active/[product-slug]/product-spec.md` with at minimum: positioning, target audience, and core pain points
- Research subfolder will be created automatically

## Pipeline Overview

```
Phase A: Validation Research (can we sell this?)
  A1: Reddit pain points
  A2: Twitter/X pulse
  A3: Hacker News signals
  A4: Keyword demand (DataForSEO)
  A5: Gumroad competitor scan
  A6: Synthesis → CHECK-IN WITH THE USER

Phase B: Deep Content Research (what goes in the product?)
  B1: Official documentation
  B2: GitHub repository mining
  B3: YouTube transcript research
  B4: Reddit community deep dive
  B5: Hacker News deep dive
  B6: Twitter discovery
  B7: Web directories & compilations
  B8: Your own setup audit
  B9: Master catalog compilation → CHECK-IN WITH THE USER
```

## Phase A: Pain Point & Product Validation

**Goal:** Confirm the product angle has demand and identify specific pain points to address.

### A1: Reddit Pain Points
**Tool:** `/reddit-research`
Search r/ClaudeAI and related subreddits with `time_filter=month`, `limit=25`.

Construct 5-7 search queries from the product topic. Focus on:
- The topic itself (e.g., "claude code skills")
- Related concepts (e.g., "plugins", "MCP server", "setup")
- Configuration/setup terms (e.g., "CLAUDE.md", "hooks")

**Extract:** Frustrated questions = product content needs. "I built X" posts = catalog entries. Upvote/comment counts = demand signal.

**Output:** `research/A1-reddit-pain-points.md`

### A2: Twitter/X Pulse
**Tool:** `/twitter-research`
Run 3 Grok queries:
1. Pain points and frustrations around [topic]
2. Tools/configs/repos people are sharing around [topic]
3. Power users and their setups

**Output:** `research/A2-twitter-pulse.md`

### A3: Hacker News Signals
**Tool:** `/hn-research` (script: `.claude/skills/hn-research/scripts/hn-search.sh`)
Run story searches (search_by_date) and comment searches (search by relevance) for 4-6 topic-related keywords.

HN comments are especially valuable — people share exact configurations and setups.

**Output:** `research/A3-hn-signals.md`

### A4: Keyword Demand Validation
**Tool:** `/dataforseo-research`
- Run `dataforseo-suggestions.sh` for 4-5 seed keywords
- Run `dataforseo-search-volume.sh` for bulk volume on 8-12 product-relevant keywords

**Decision gate:** Combined volume > 5K/mo = validated. < 2K/mo = consider pivoting to broader topic.

**Output:** `research/A4-keyword-demand.md`

### A5: Gumroad & Product Competitor Scan
**Tools:** WebSearch + WebFetch
Search for competing products on:
- Gumroad (`site:gumroad.com "[topic]"`)
- Udemy, Teachable, Coursera
- General web (`"[topic]" guide product buy`)
- Travis Nicholson's store (strategy model reference)

For each product found, capture: title, price, format, description, ratings, what's included.

**Output:** `research/A5-gumroad-competitors.md`

### A6: Phase A Synthesis
Combine all findings into a synthesis document:
- Pain points ranked by cross-source frequency
- Keyword demand summary table
- Competitive landscape breakdown
- Product angle recommendation + pricing + format
- Risks and mitigations

**Output:** `research/A-synthesis.md`

**⚠️ CHECK-IN WITH THE USER before proceeding to Phase B.** Present the synthesis and get go/no-go.

---

## Phase B: Deep Content Research

**Goal:** Systematically catalog everything relevant to the product topic from all available sources.

### B1: Official Documentation
**Tools:** Firecrawl (map + scrape), WebFetch
- Map docs.anthropic.com and support.claude.com for topic-related pages
- Scrape each relevant page
- Check github.com/anthropics for related repos
- Document: features, formats, specifications, compatibility rules

**Critical:** Verify installation/setup workflows for both Claude Code AND Claude CoWork.

**Output:** `research/B1-official-docs.md`

### B2: GitHub Repository Mining
**Tool:** WebSearch + WebFetch/Firecrawl
Run 8-10 `site:github.com` searches with topic-related queries. For each repo found: name, URL, stars, description, contents, setup instructions, last updated, CoWork compatibility.

**Output:** `research/B2-github-repos.md`

### B3: YouTube Transcript Research
**Tools:** WebSearch (find videos), yt-dlp (grab transcripts)

**Priority creators:** Nate Herk, Chase AI, Simon Scrapes, Alex Finn, Matthew Berman, plus any topic-specific creators.

**Process per creator:**
1. WebSearch `site:youtube.com "[Creator]" [topic]`
2. Download transcript: `yt-dlp --write-auto-sub --sub-lang en --skip-download --convert-subs srt -o "research/transcripts/%(uploader)s-%(title)s" "URL"`
3. If no auto-subs, use `/watch` skill (Whisper fallback)
4. Extract: items mentioned, repos linked, setup demos, recommendations

**Output:** Transcripts to `research/transcripts/`, insights to `research/B3-youtube-insights.md`

### B4: Reddit Community Deep Dive
**Tool:** `/reddit-research`
Different from A1 — looking for actual shared items, not pain points:
- "I built", "sharing", "open source", "SKILL.md", "plugin", etc. in r/ClaudeAI

Follow any links to repos/configs and catalog them.

**Output:** `research/B4-reddit-community.md`

### B5: Hacker News Deep Dive
**Tool:** `/hn-research`
Search both stories and comments. HN comments contain real configs and setups. Search for topic-specific terms plus "Show HN" posts.

Follow any GitHub links mentioned.

**Output:** `research/B5-hn-community.md`

### B6: Twitter Discovery
**Tool:** `/twitter-research`
3 Grok queries focused on discovering shared tools, repos, and creators specific to the topic.

**Output:** `research/B6-twitter-discovery.md`

### B7: Web Directories & Compilations
**Tools:** WebSearch, WebFetch, Firecrawl
Search for existing curated lists, directories, marketplaces, and compilations. Cross-reference against items already cataloged.

**Output:** `research/B7-web-compilations.md`

### B8: Your own setup audit
**Tool:** Read vault files
Catalog your own setup as a real-world practitioner example:
- Skills in `.claude/skills/`
- Configuration in `CLAUDE.md` and `.claude/settings.json`
- How components chain together into workflows
- APIs and dependencies

**Output:** `research/B8-own-setup-audit.md`

### B9: Master Catalog Compilation
Read all B1-B8 files. Deduplicate and organize into a single catalog.

**Organization:** By knowledge worker use cases, NOT by source or alphabetically. Categories should match the target audience defined in the product spec.

**Entry format:**
```
### [Item Name]
- **What it does:** [1-2 sentences, jargon-free]
- **Category:** [from product-spec categories]
- **CoWork compatible:** Yes | No | Unknown
- **Setup:** Easy | Medium | Advanced
- **Where to get it:** [URL or "Built-in" or "Marketplace"]
- **Stars/Popularity:** [if applicable]
- **Maintained:** [Yes/No]
- **Source:** [which B files found it]
- **Your take:** [blank — the user fills in]
```

**Additional sections in the catalog:**
- Directories & marketplaces found
- Top 20 most popular items
- Starter packs by persona (from product spec target audience)
- Items that reduce token costs

**Output:** `research/B9-master-catalog.md`

**⚠️ CHECK-IN WITH THE USER before proceeding to drafting.** Present the catalog and get approval.

---

## Parallelization Strategy

**Phase A:** A1 + A2 + A3 run as parallel agents. A4 + A5 run in parallel after.

**Phase B:** B1 + B3 + B4 + B5 run in parallel (first wave). B6 + B7 run in parallel (second wave). B8 can run with either wave. B9 runs last (needs all inputs).

---

## Output Structure

All outputs go under the product folder:
```
03-Products/Active/[product-slug]/
  product-spec.md
  research/
    A1 through A5 + A-synthesis.md
    B1 through B9 + master catalog
    transcripts/
```

## Completion Criteria

The research is complete when:
- Official documentation fully scraped
- All 5+ named YouTube creators checked
- At least 3 community sources searched (Reddit, HN, Twitter)
- GitHub repos mined with 8+ search queries
- Web directories cross-referenced
- Your own setup audited
- Master catalog compiled with 20+ unique entries minimum
- New searches return >80% items already cataloged (diminishing returns)
- Every catalog entry has a working link

## Rules

- All research outputs go to the vault as markdown files, never just in conversation
- Items outside the product scope get noted in `03-Products/future-product-notes.md`
- CoWork compatibility must be flagged for every catalog entry
- Installation workflows (Code vs CoWork) must be verified and documented
- Check in with the user at both decision gates (after A6 and after B9)
