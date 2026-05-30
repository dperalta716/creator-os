---
name: setup
description: Interactive guided setup for Creator OS. Explains the entire system, then walks through identity, content pillars, research sources, voice calibration, API keys, and first run. Start here.
user-invocable: true
---

# Setup — Creator OS

Welcome to the guided setup. This skill walks through the entire system first, then configures it for your niche interactively.

## Usage

```
/setup
```

---

## Part 1: System Overview

Before any configuration, explain what this system is and how all the pieces fit together. Present this conversationally — don't dump a wall of text. Pause after each section to check if they have questions before moving on.

### 1.1 What This Vault Is

Explain the core concept:

This is a complete content-to-products system built on Obsidian + Claude Code. The pipeline works like this: you find what people are struggling with, validate that there's search demand, write articles that rank on Medium (or your own site), and that organic traffic becomes your distribution channel for digital products, email signups, or whatever you want to build.

Every step of that pipeline is automated through Claude Code skills — from research to writing to review. You tell Claude what to do, and the skills handle the how.

### 1.2 The Content Pipeline

Walk through the end-to-end flow:

```
Topic Discovery → find what people are actually asking about
       ↓
Keyword Research → validate there's real search demand (DataForSEO)
       ↓
SERP Clustering → decide article boundaries (which keywords = one article vs. separate articles)
       ↓
Article Generation → competitive analysis + drafting with voice enforcement
       ↓
Review Pipeline → unique value check, claims verification, internal linking
       ↓
Image Generation → whiteboard-style diagrams for visual learners
       ↓
Publishing → Medium (manual for now, automatable later)
```

Explain each step briefly — what it does and why it matters. The key insight: this isn't just "AI writes articles." The system does competitive research first, enforces your authentic voice, verifies every factual claim, and ensures you're adding real value beyond what's already ranking.

### 1.3 The Skill System

Explain what each skill does, when to use it, and how they chain together:

**Discovery & Research:**
- `/topic-discovery` — The orchestrator. Dispatches reddit + twitter research in parallel, surfaces pain points by content pillar, then walks you through keyword validation and SERP clustering. This is how you decide what to write next.
- `/reddit-research [keyword]` — Searches Reddit for posts and questions. Used by topic-discovery automatically, but you can also run it standalone for a specific topic.
- `/hn-research [keyword]` — Searches Hacker News. Good for technical angles and builder perspectives. Optional — included by default for tech niches.
- `/twitter-research [topic]` — Searches Twitter/X via Grok API. Finds trending discussions and pain points. Used by topic-discovery.
- `/medium-research [keyword]` — Finds top-ranking Medium articles for a keyword. Used during competitive analysis.
- `/dataforseo-research` — Keyword data toolkit: suggestions, search volume, SERP analysis, related keywords, autocomplete. The backbone of keyword research.
- `/firecrawl-scraper` — Scrapes web pages to markdown. Used to read competitor articles during article generation.

**Content Creation:**
- `/generate-article` — End-to-end article creation. Takes a topic from the queue, does competitive analysis (scrapes top-ranking articles), finds content gaps, then drafts an article in your voice that fills those gaps. Produces a `v1-draft.md`.
- `/review-article` — Post-draft review pipeline. Runs unique value analysis against competitors, quality/SEO checks, internal linking, claims verification against official documentation, and a personal experience interview. Produces versioned files through `v4-final.md`.
- `/generate-article-images` — Creates whiteboard-style diagram images for articles. Runs as a background task during review, or standalone. Generates A/B pairs for you to pick from.

### 1.4 The Vault Structure

Explain what each folder is for:

```
00-Dashboard/       — Your home base. Overview and quick links.
01-Topic-Discovery/ — Research reports and the Topic Queue (what to write next)
02-Articles/        — In-Progress drafts and Published articles, each in numbered folders
03-Products/        — Digital product development, ideas, and performance tracking
04-Strategy/        — Content pillars, competitor analysis, monthly reviews, learnings
05-Learnings/       — Personal brain dumps and notes from external content
Reference/          — Voice guide, Medium SEO notes, source tier framework
```

The flow: Topics start in `01-Topic-Discovery/`, move to `02-Articles/In-Progress/` during writing, then to `02-Articles/Published/` when done. Product ideas live in `03-Products/`.

### 1.5 The Voice System

Explain how quality enforcement works:

Two files control how your articles sound:
- `Reference/Voice-Guide.md` — Defines your writing voice: tone, sentence patterns, what to do and what to avoid. The article generation and review skills read this file and enforce it.
- `Reference/Source-Tiers.md` — Defines how claims should be sourced. Tier 1 is official docs, Tier 4 is community signals. The review pipeline verifies every factual claim against these standards.

The voice guide ships with a default voice (knowledgeable, practical, direct). We'll calibrate it to YOUR voice during setup.

### 1.6 Check for Questions

Ask: "That's the full system. Any questions before we start configuring it for you?"

Answer any questions, then transition to Part 2.

---

## Part 2: Interactive Setup

After the overview, transition to interactive configuration. The order is deliberate — identity and niche first, technical setup last. Each step builds on the previous one.

### Step 1: Identity

Ask the user and update `CLAUDE.md` with their answers:

1. "What's your name?"
2. "What's your Medium profile URL?" (or "Do you have one yet?" — it's fine if they don't)
3. "Tell me about yourself — what do you do, what are you known for, what's your background?"

Update `CLAUDE.md`:
- Replace `[Your Name]` with their actual name
- Replace `[your niche]` with their niche/topic area
- Add their Medium URL if they have one

### Step 2: Content Pillars

This is the most important step. Do NOT start with "what tools do you use." Start with understanding their world.

**Round 1 — What do you want to write about?**
- "What topics might you want to focus on? What is it that you'd want to write about?"
- "Do you already have an audience anywhere — YouTube, blog, newsletter, social media?"
- "What do people come to you for? What do you know that most people in your space don't?"

**Round 2 — Drill into topics:**
Based on their answers, ask follow-up questions specific to their niche. Examples:
- If they say "ADHD" → "Are you focused on diagnosis, coping strategies, productivity hacks, parenting, medication, workplace accommodations? What's your angle?"
- If they say "fitness" → "Strength training, nutrition, recovery, specific populations? What's your unique take?"
- If they say "AI tools" → "Which ones do you actually use daily? What workflows have you built?"
- If they say "personal finance" → "Investing, budgeting, debt payoff, side income? What's your situation — are you a practitioner or a coach?"

The goal is to move from vague topics to specific angles where they have genuine expertise or experience.

**Round 3 — Define 3-8 pillars:**
Help them articulate distinct content pillars from their niche. For each pillar, identify:
- The topic area
- Their unique angle or expertise
- Seed keywords to explore later

Ask: "Which one is your PRIMARY pillar — the one you could write 20 articles about?"

**Save:** Generate `04-Strategy/Content-Pillars.md` with their answers, following the existing format (replace the example pillars entirely). Also update the skill commands in CLAUDE.md if the pillar keywords differ significantly from the defaults.

### Step 3: Research Sources

Reddit is nearly universal — always include it. Beyond that, don't assume.

**Ask:**
- "Reddit is a great source for almost any niche. Do you know which subreddits are relevant to your topics?"
- "Beyond Reddit, where do people in your niche ask questions and share problems? Forums, Discord servers, specific online communities?"
- "What newsletters or publications cover your space?"
- "Do you follow any specific creators or thought leaders in this area?"

**Offer to research on their behalf:**
- "I can do some quick research to find forums, communities, and discussion platforms relevant to [their niche]. Want me to look?"
- If yes, use WebSearch to find niche-specific forums, communities, subreddits, and sources
- Present findings and ask which ones resonate

**Based on their answers, update `01-Topic-Discovery/Sources.md`:**
- Reddit: always included, with their specific subreddits
- HN: keep available but mark as optional if their niche isn't tech-adjacent
- Twitter: keep if relevant to their niche
- Add any new sources they identify

**Custom research subskills:**
If you identify a platform that's technically feasible to search (has a public API, public JSON endpoints, or scrapable pages), offer to create a research subskill for it:
- Create `.claude/skills/[source]-research/SKILL.md` following the reddit-research pattern
- Create `.claude/skills/[source]-research/scripts/[source]-search.sh`
- Add `Bash(./.claude/skills/[source]-research/scripts/*)` to `.claude/settings.json`
- Update the skills list in `CLAUDE.md`

Do NOT promise skills for platforms that require authenticated access or are technically blocked (e.g., Facebook groups, private Discord servers).

**Also update `/topic-discovery`:**
If new sources are added, update the topic-discovery SKILL.md to include the new research commands in Phase 1. Update the default search keywords to match their content pillars.

### Step 4: Voice

Present the current voice guide and calibrate to their actual writing.

1. Read `Reference/Voice-Guide.md`
2. Present a summary of the key traits: knowledgeable but accessible, confident but not arrogant, practical, direct
3. Ask: "Does this match how you naturally write, or would you want a different tone?"

**Ask for writing samples:**
"Do you have any existing content I can look at to get a feel for your voice? This could be:
- Blog posts or articles you've written
- YouTube video scripts or descriptions
- Social media posts or threads
- A local file or document you've written"

**If they provide samples:**
Read the samples and identify voice patterns:
- Sentence length and rhythm
- Formality level
- Use of humor
- How they handle technical vs. casual content
- Personal anecdotes vs. authority
- Unique speech patterns or phrases

Then rewrite `Reference/Voice-Guide.md` to match their natural voice. Keep the structure (Do/Don't/AI tells to avoid) but adapt the content to describe THEIR voice, not the default.

**If no samples:**
Adjust based on their verbal description if they want changes. If the default voice works for them, leave it as-is but update the identity section at the top.

Always update the "Identity" section at the top of Voice-Guide.md with their actual background and positioning.

### Step 5: API Keys

Now that they understand the system and have configured their niche, set up the technical requirements.

**Explain the key distinction: required vs. optional.**

**Required keys (core pipeline):**

1. **DataForSEO** (`DATAFORSEO_USER` + `DATAFORSEO_PASS`)
   - Needed for: keyword research, SERP analysis, Medium article search
   - Powers: topic discovery keyword validation and article generation competitive analysis
   - Sign up: https://dataforseo.com/
   - Check: `grep DATAFORSEO ~/.env 2>/dev/null`

2. **Firecrawl** (`FIRECRAWL_API_KEY`)
   - Needed for: scraping competitor articles during article generation
   - Sign up: https://firecrawl.dev/
   - Check: `grep FIRECRAWL ~/.env 2>/dev/null`

**Optional keys (enhanced features — skip if not needed now):**

3. **XAI / Grok** (`XAI_API_KEY`)
   - Enables: Twitter/X research via Grok API for finding pain points and trending topics
   - If skipped: topic discovery still works using Reddit alone
   - Sign up: https://console.x.ai/
   - Check: `grep XAI ~/.env 2>/dev/null`

4. **fal.ai** (saved to `.claude/skills/fal-ai/fal-api-key`)
   - Enables: AI image generation for article diagrams (whiteboard-style)
   - If skipped: add images manually or enable later
   - Sign up: https://fal.ai/
   - Check: `cat .claude/skills/fal-ai/fal-api-key 2>/dev/null`

**For each key:**
- Check if it's already configured
- If present: confirm it's working (for DataForSEO/Firecrawl, you can do a quick test request)
- If missing: explain what it unlocks in context of THEIR workflow, link to signup, walk through saving it to `~/.env`
- If they want to skip an optional key: confirm that's fine, note which features won't be active

**Saving keys:**
```bash
# Check if ~/.env exists
cat ~/.env 2>/dev/null || echo "No ~/.env file yet"

# Create or append to ~/.env
# Walk them through adding each key
```

**Playwright setup:**
```bash
# Check if Playwright is available
npx playwright --version 2>/dev/null || echo "Playwright not installed"

# If not installed:
npx playwright install chromium
```
Playwright is needed for the medium-scraper skill and any custom browser-based research skills.

**medium-scraper dependencies:**
```bash
cd .claude/skills/medium-scraper/scripts && npm install && cd -
```

### Step 6: First Run

After setup is complete, offer to kick off their first topic discovery:

"Everything is configured. Want to run your first topic discovery now? I'll use `/topic-discovery` with your pillars and sources to find what people in your niche are struggling with."

If they say yes, invoke `/topic-discovery`. This gives them immediate value and validates the setup works end-to-end.

If they say no, summarize what's ready and what they can do next:
- "Run `/topic-discovery` whenever you want to find new article ideas"
- "Run `/generate-article` when you're ready to write (you'll need a topic in the queue first)"
- "Check `00-Dashboard/Dashboard.md` for an overview of everything"

---

## Completion Checklist

Before finishing setup, verify all of these:

- [ ] `CLAUDE.md` updated with their name and niche
- [ ] `04-Strategy/Content-Pillars.md` has their pillars (not the examples)
- [ ] `01-Topic-Discovery/Sources.md` has their subreddits and sources
- [ ] `Reference/Voice-Guide.md` calibrated to their voice
- [ ] Required API keys configured (DataForSEO + Firecrawl) or acknowledged as pending
- [ ] Optional API keys configured or consciously skipped
- [ ] Playwright installed (or noted as needed later)
- [ ] `/topic-discovery` updated if new sources or pillars were added

Report what's done and what's pending. If any required keys are missing, remind them which features won't work until they're added.
