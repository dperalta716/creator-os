---
name: topic-discovery
description: Run the topic discovery pipeline — a human-in-the-loop workflow that surfaces pain points, validates with keyword data, analyzes SERP overlap, and builds topic clusters. Requires check-ins with the user at each phase before proceeding.
user-invocable: true
---

# Topic Discovery

A multi-phase, human-in-the-loop workflow for finding article topics. Each phase ends with a check-in — the user decides what to pursue before the next phase begins.

## Usage

```
/topic-discovery
```

## The Workflow

### Phase 1: Surface Pain Points
**Goal:** Find what people are struggling with right now.
**Sources:** Reddit + Twitter (default). Add HN/Medium only on request.

Dispatch 2 parallel agents:

**Agent 1 — Reddit Research:**
Search each content pillar keyword across default subreddits:
```bash
./.claude/skills/reddit-research/scripts/reddit-search.sh "claude code" "ClaudeAI,artificial" "week" 10
./.claude/skills/reddit-research/scripts/reddit-search.sh "suno ai" "SunoAI" "week" 10
./.claude/skills/reddit-research/scripts/reddit-search.sh "ai workflow" "productivity,SideProject" "week" 10
./.claude/skills/reddit-research/scripts/reddit-search.sh "wispr flow" "productivity" "month" 5
./.claude/skills/reddit-research/scripts/reddit-search.sh "groq whisper" "artificial,SideProject" "month" 5
./.claude/skills/reddit-research/scripts/reddit-search.sh "chatgpt image" "ChatGPT" "week" 10
./.claude/skills/reddit-research/scripts/reddit-search.sh "ai tools" "artificial,productivity" "week" 10
```

**Agent 2 — Twitter/X Research:**
```bash
./.claude/skills/twitter-research/scripts/grok-search.sh "What are the most discussed AI tools and features on Twitter this week? Focus on Claude, Claude Code, Suno, image generation, and AI workflows. What pain points and frustrations are people expressing?"
./.claude/skills/twitter-research/scripts/grok-search.sh "What questions are people asking about AI tools on Twitter that nobody has answered well? What do they wish existed?"
```

**Output:** Pain points and frustrations grouped by content pillar. 3-5 per pillar. NOT article titles — raw problems people are having.

**Filter out:**
- Things the user doesn't use or know about
- News-cycle reactions without staying power
- Topics too niche to matter

### >>> CHECK-IN: Present pain points to the user. They pick which ones resonate with his experience.

---

### Phase 2: Keyword Research
**Goal:** Validate demand for the user's selected pain points.

For each selected pain point, run keyword suggestions:
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "[topic]" "en" "United States" 20
```

Also check broader parent keywords for volume context:
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-search-volume.sh "keyword1,keyword2,keyword3" "en" "United States"
```

**Output:** Table of keywords with volume, CPC, and competition. Highlight which keywords have real demand vs. which are too thin.

### >>> CHECK-IN: The user reviews keyword data. Picks which clusters to pursue. May ask for more keywords on specific topics.

---

### Phase 3: SERP Overlap Analysis (Keyword Clustering)
**Goal:** Determine which keywords need separate articles vs. which should be combined.

For each keyword the user is considering, run a SERP analysis:
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-filtered.sh "[keyword]" "en" "United States"
```

Then compare the organic results across related keywords:

**Decision criteria for SERP overlap:**
- **7+ same URLs across two keywords** = same article (Google sees them as the same intent)
- **4-6 same URLs** = could be one article, consider combining with the secondary keyword as an H2
- **<3 same URLs** = separate articles (different search intent)

**Output:** Overlap matrix showing which keywords share results and which don't.

### >>> CHECK-IN: The user reviews clustering. Decides final article list.

---

### Phase 4: Competitive Analysis (Optional)
**Goal:** Assess who's ranking and whether you can beat them.

For promising keyword clusters, check what's already ranking on Medium:
```bash
./.claude/skills/medium-research/scripts/medium-search.sh "[keyword]" 5
```

Scrape top-ranking competitor articles:
```bash
./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "[url]" "markdown" "true"
```

**Assess:**
- Author follower count and engagement
- Content quality (thin listicle vs. deep guide)
- Behind paywall or free?
- Can you write something better from real experience?

### >>> CHECK-IN: The user reviews competitive landscape. Finalizes topic queue.

---

### Phase 5: Save & Commit
**Goal:** Persist everything for future reference.

1. Save full report to `01-Topic-Discovery/Reports/YYYY-MM-DD-intel.md`
   - All phases: raw pain points, the user's selections, keyword data, SERP overlap, competitive analysis
2. Update `01-Topic-Discovery/Topic-Queue.md` with approved topics
3. Update `04-Strategy/Learnings.md` with what worked and what didn't
4. Git commit everything

---

## Report Structure

```markdown
---
date: YYYY-MM-DD
type: topic-discovery
sources: [reddit, twitter]
---

# Topic Discovery Report — YYYY-MM-DD

## Pain Points by Pillar
### [Pillar Name]
1. **[Pain point]** — [evidence and engagement signals]
...

## Questions People Are Asking
[Bulleted list from Reddit/Twitter]

## Keyword Validation
[Tables of keyword data for selected pain points]

## SERP Overlap Analysis
[Overlap matrices showing which keywords cluster together]

## Competitive Analysis
[SERP landscape and competitor assessment]

## Approved Topics
[Final topic queue additions with keywords, volume, and notes]

## Raw Data Summary
### Reddit Highlights
[Top posts by engagement]
### Twitter Pulse
[Key themes from Grok]
```

## On-Demand Sources

Not run by default. Use for specific needs:

**Medium Research** — Competitive analysis for a specific keyword:
```bash
./.claude/skills/medium-research/scripts/medium-search.sh "[keyword]" 5
```

**HN Research** — Builder/technical angles:
```bash
./.claude/skills/hn-research/scripts/hn-search.sh "[keyword]" "story" "search" 10
```

## Key Principles

- **Pain points first, not article titles** — Surface problems, let the user pick
- **Human-in-the-loop at every phase** — Never proceed to the next phase without check-in
- **Multiple options per pillar** — 3-5 pain points, not one pre-decided topic
- **Filter through the user's experience** — Only topics he actually uses daily
- **Validate before committing** — Keyword data confirms demand
- **SERP overlap determines article boundaries** — Let Google's results decide what's one article vs. two
- **Document learnings** — Every run teaches us something

## Workflow Summary

```
Pain Points (Reddit + Twitter)
    ↓
>>> The user picks which resonate
    ↓
Keyword Research (DataForSEO suggestions + volume)
    ↓
>>> The user picks which clusters to pursue
    ↓
SERP Overlap Analysis (compare top 10 results across keywords)
    ↓
>>> the user decides article boundaries
    ↓
Competitive Analysis (optional — Medium + Firecrawl)
    ↓
>>> The user finalizes topic queue
    ↓
Save report, update queue, commit
```
