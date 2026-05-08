---
name: generate-article
description: End-to-end SEO article generation for Medium. Runs competitor analysis, then generates a voice-calibrated draft optimized for Medium SEO with Gumroad CTAs. Use when ready to write an article from the Topic Queue.
argument-hint: keyword from Topic Queue (e.g., "what is claude cowork")
user-invocable: true
---

# Generate Article

Generate a complete SEO-optimized Medium article draft. Runs a three-phase pipeline: topic context → competitor analysis → draft generation.

## Usage

```
/generate-article what is claude cowork
```

The keyword argument is required. It should match an entry in `01-Topic-Discovery/Topic-Queue.md`.

---

## PHASE 0: Topic Context

### Step 0.1: Read Topic Queue & Discovery Data

1. Read `01-Topic-Discovery/Topic-Queue.md` and find the matching topic entry
2. Read the most recent intel report in `01-Topic-Discovery/Reports/` for SERP overlap notes, keyword data, and clustering decisions
3. Read `Reference/Voice-Guide.md` (voice and tone rules)
4. Read `Reference/Medium-SEO-Notes.md` (platform-specific SEO)
5. Read `Reference/Source-Tiers.md` (citation framework and source tier rules)

### Step 0.2: Establish Article Parameters

From the topic queue entry and intel report, determine:
- **Primary keyword** and secondary keywords to target
- **H2 sections** already determined by SERP overlap analysis (e.g., "pricing" as H2 inside "what is" article)
- **FAQ candidates** from PAA questions discovered during SERP analysis
- **Article depth tier:**
  - **In-depth guide** (explainers, "what is", "how to use"): 1500-2500 words
  - **Comparison** ("vs" articles): 1000-1800 words
  - **Focused topic** (plugins, skills, pricing): 1000-1500 words

---

## PHASE 1: Pre-Draft Competitor Analysis

### Step 1.1: Fetch SERP Data

Run the DataForSEO script to get organic results and PAA questions:

```bash

./.claude/skills/dataforseo-research/scripts/dataforseo-filtered.sh "$KEYWORD" "en" "United States"
```

Parse the response:
- Extract top 5 organic URLs (filter organic results, take first 5)
- Extract all PAA questions

### Step 1.2: Create Article Folder

Create the article folder early so competitor articles can be saved during scraping:

```bash

HIGHEST=$(ls -1 02-Articles/In-Progress 2>/dev/null | grep -E '^[0-9]{3}-' | sed 's/-.*//' | sort -n | tail -1)
NEXT=$(printf "%03d" $((10#${HIGHEST:-0} + 1)))
SLUG=$(echo "$KEYWORD" | tr '[:upper:]' '[:lower:]' | tr ' ' '-')
ARTICLE_DIR="02-Articles/In-Progress/${NEXT}-${SLUG}"
mkdir -p "${ARTICLE_DIR}/competitors"
```

Store the `ARTICLE_DIR` path for use in subsequent steps.

### Step 1.3: Scrape & Analyze Top 5 Articles

Spawn up to 5 parallel sub-agents. Each sub-agent:

1. Scrapes one article using Firecrawl:
```bash
./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "[URL]" "markdown" "true" "2000"
```

   **Medium paywall fallback chain:** If the URL is a Medium article (`medium.com` or `*.medium.com`) and Firecrawl returns truncated content (under ~800 words for an article the SERP indicates is a longer read):

   **Fallback 1 — Freedium:** Re-scrape via Firecrawl using the Freedium proxy URL:
   ```bash
   ./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "https://freedium.cfd/[ORIGINAL_URL]" "markdown" "true"
   ```
   If Freedium returns the full article, use that. If it fails (connection error, empty response, or still truncated), proceed to Fallback 2.

   **Fallback 2 — Playwright:** Use the authenticated Medium scraper:
   ```bash
   cd ./.claude/skills/medium-scraper/scripts && node scrape-medium.mjs "[ORIGINAL_URL]"
   ```
   This uses a saved Medium session to get the full paywalled article via a real browser. Requires `auth.json` to exist (created via `node login.mjs` one-time setup).

2. **Saves the cleaned article** to the competitors folder. Strip everything before the first `# ` (H1) heading and everything after the article's concluding statement (remove footers, author bios, related article lists, newsletter signup copy, etc.). Keep:
   - The full article body from H1 through conclusion
   - All markdown formatting (headings, bold, italics, lists)
   - All working links (both inline and reference-style)
   - All images (preserve markdown image syntax with original URLs)

   **Add the source URL as the first line** of the file, before the H1:
   ```
   **Source:** [original URL]

   # Article Title...
   ```

   Save as: `${ARTICLE_DIR}/competitors/[slugified-article-title].md`

   Use the article's H1 as the filename, slugified (lowercase, hyphens, no special chars). If no H1 exists, derive from the URL path.

3. Extracts structured analysis:
   - **Topics covered** with depth assessment (light/medium/deep)
   - **Structure**: H2 headings, word count estimate, format (listicle, guide, review, etc.)
   - **Notable angles**: Unique perspectives, personal experience, data points
   - **Weaknesses**: Thin sections, generic advice, outdated info, behind paywall
   - **Author authority**: Follower count, publication size (if visible)

### Step 1.4: Consolidate Findings

After all sub-agents complete, synthesize:

1. **Primary user search intent** — what does the searcher actually want to know/do?
2. **Competitive baseline requirements** — topics covered by 3+ articles = must-cover
3. **PAA selection** — choose 3-4 best questions for the FAQ section
4. **Gaps & opportunities** — what are competitors missing that you can provide from real experience?
5. **Beatable competitors** — which top results are thin, generic, or low-authority?

### Step 1.5: Create Analysis Document

Save to: `${ARTICLE_DIR}/stage1_analysis.md`

```markdown
---
date: [TODAY]
keyword: "[keyword]"
analyzed_articles: 5
---

# Pre-Draft Analysis: [Keyword]

## 1. User Search Intent
## 2. Competitive Baseline (Must-Cover Topics)
## 3. PAA Questions (Selected for FAQs)
## 4. Article-by-Article Breakdown
## 5. Gaps & Opportunities
## 6. Recommended Outline
```

---

## PHASE 2: Draft Generation

After Phase 1 completes, read the stage1_analysis document and generate the article.

### Step 2.1: Internal Processing (Think, Don't Write Yet)

**A. Extract from stage1_analysis:**
- User intent and core questions
- Must-cover topics (competitive baseline)
- Selected PAA questions (for FAQs)
- Gaps where your real experience adds value

**B. Identify your unique angles:**
- What do you actually know from daily use that competitors are missing?
- What practical, tested advice can you give that generic articles can't?
- Where can you show, not tell? (specific steps, exact results, real workflows)

**C. Build outline:**
- H1 (benefit-oriented, keyword included)
- Overview bullets (3-5 standalone takeaways a scanner can absorb without reading the article — NOT a table of contents. Each bullet should convey a useful insight or conclusion, not just signpost a section. Bad: "The best skills to install right now." Good: "The best skills to install cover content creation, marketing, and research, with most taking under five minutes to set up.")
- Introduction (hook → direct answer → nuance)
- 3-6 H2 body sections (based on competitive baseline + your angles)
- The Key Takeaway (closing insight)
- FAQs (from PAA questions)
- Include any H2 sections mandated by SERP overlap analysis (e.g., pricing inside "what is")

### Step 2.2: Write the Article

#### Sources & Citations

Read and follow `Reference/Source-Tiers.md`. Every factual claim, statistic, or data point must trace to a Tier 1-3 source. Key rules:

**Citation capsules (answer-first H2 openers):**
Every H2 section must open with a 40-60 word passage that:
1. Directly answers the heading's question
2. Includes at least one specific data point with source attribution
3. Works as a standalone quote (an AI system could extract and cite it without context)

Lead with the sourced answer, then expand with your take and personal experience.

**Example:**
```
## Does Claude Code actually save time on real projects?
Claude Code hits a 72% success rate on SWE-bench tasks per
[Anthropic's May 2026 benchmarks](URL). But benchmarks aren't real work.
The actual time savings depend on how you structure your workflow. I've seen
tasks go from 45 minutes to under 5 when the approach is dialed in.
```

**Inline attribution style:**
State facts directly in the author's voice. The source is always an inline link on a natural noun, never a parenthetical citation or the grammatical subject.
- Good: "Claude Code hits 72% on SWE-bench per [Anthropic's May 2026 benchmarks](URL)."
- Good: "44% of developers now use AI coding tools daily. That's from [Stack Overflow's 2026 survey](URL), and it matches what I see in the communities I follow."
- Good: "Users on [r/ClaudeAI](URL) consistently report hitting usage limits faster than expected."
- Bad: "According to Anthropic's model card..." — defers to authority, not the author's voice
- Bad: "A 2026 Stack Overflow survey found that..." — the survey is talking, not the author
- Bad: "(Source: Anthropic, 2026)" — parenthetical citations look academic
- Bad: "Studies show..." — no named source

**Citation density:**
At least one sourced data point per H2 opener. Additional sources every 200-300 words where they strengthen a claim. Personal experience and practitioner observation fill the space between. The article should not read like a research paper.

**Source tier enforcement:**
- T1 (Official docs/changelogs) for tool-specific claims about features, pricing, capabilities
- T2 (Named research with methodology) for market-level claims and industry trends
- T3 (Practitioner authority) for expert analysis and nuanced technical takes
- T4 (Community signal) only for "what real users experience" context, never for hard facts
- Reject: unsourced stats, content mill roundups, "suspiciously precise" numbers without methodology

#### Voice & Tone

Read and follow `Reference/Voice-Guide.md`. The core identity:

**[Your Name] on Medium** — Read the Identity section of `Reference/Voice-Guide.md` for the author's voice and positioning. The `/setup` skill configures this during initial setup.

**The voice in practice:**
- Use "you" and "your" frequently — talking directly to the reader
- Contractions always (don't, it's, you're)
- Short paragraphs (2-3 sentences max — Medium readers scan)
- Mix sentence lengths (punchy followed by explanatory)
- Occasional personal aside: "I discovered this by accident when..."
- Lead with the practical, follow with the why
- Be specific — exact steps, exact tools, exact results

**Never do:**
- No preambles ("In this article, I'll show you...")
- No generic filler ("AI is transforming the way we work...")
- No listicles without substance ("Top 10 AI tools...")
- No emoji in body text
- No over-promising ("make $10K overnight")
- No academic tone
- No "I'm an expert" posturing — demonstrate it through specifics
- No "most articles skip this" or "other guides get this wrong" — just deliver the value without calling out competitors

**AI tells (critical — read the "AI tells to avoid" section of the Voice Guide):**

The Voice Guide defines four families of AI tells that must be avoided during drafting. The most common ones to watch for while writing:
- Zero or near-zero em dashes. Use commas or periods.
- No inflated words (seamless, unlock, empower, pivotal, testament).
- No fake-depth -ing constructions (highlighting, reinforcing, fostering).
- No "not just X but also Y" unless it genuinely earns its place.
- No hedging (may potentially, could possibly). Pick a position.
- No filler phrases (in order to, has the ability to, it should be noted).
- Sentence case for all H2+ headings.
- Opinions and mixed feelings where they exist, not just reporting.

**Sentence patterns to use:**
- "Here's what actually works..."
- "I've been using [tool] for [timeframe] and here's what I've found..."
- "You don't need [complex thing]. You need [simple thing]."
- "Let me show you exactly how I..."

#### Writing Mechanics

**Sentence-level:**
- Vary sentence length deliberately — short punchy for emphasis, medium for explanation
- Average under 25 words per sentence
- Active voice 90% of the time
- Occasional sentence fragments for conversational feel

**Paragraph-level (whitespace is critical for Medium):**
- Maximum 2-3 sentences per paragraph. Break at idea boundaries, not sentence counts.
- Each distinct idea or beat gets its own paragraph, even if that's a single sentence.
- Punchy payoff lines stand alone: "Cowork handled it in one session." gets its own paragraph.
- Quoted examples or task lists get isolated from their setup and consequence. Three separate paragraphs: setup, examples, result.
- When a sentence shifts topic or introduces a new thought, start a new paragraph even if the previous one was only one sentence.
- Medium readers scan. White space is your friend. Err on the side of more breaks, not fewer.

**Section-level:**
- Each H2 section: 200-500 words depending on depth needed
- **Introduction structure (this order):**
  1. Open with 1-2 sentences of relatable hook — a scenario, observation, or curiosity spark
  2. Deliver the direct short answer to the keyword question
  3. Expand with nuance — what's more complex, what most articles miss
- Body sections address baseline topics with your real-experience angle layered on
- The Key Takeaway closes with a grounding, practical line — not a summary

#### Word Count Targets

- **In-depth guide** ("what is", "how to use", comprehensive explainer): 1500-2500 words
- **Comparison article** ("vs" articles): 1000-1800 words
- **Focused topic** (plugins, skills, pricing, specific feature): 1000-1500 words

Never pad to hit word count. If the topic is fully covered in fewer words, that's fine. But in-depth guides should be genuinely in-depth — cover every angle a reader would need.

#### Medium Formatting Rules

These are critical for clean rendering when pasted into Medium:

- **No blank line between headers and content.** `## Header` is immediately followed by text on the next line (no empty line).
- **Bold inline labels on their own line.** When a section lists distinct items (pricing tiers, features, limitations, use case categories), the bold label goes on its own line with no trailing period, colon, or em dash. The description starts on the next line:
  ```
  **Claude Pro ($20/month)**
  Includes Cowork access. For occasional tasks, Pro works fine.

  **Desktop app required**
  Cowork only runs in the Claude Desktop app on macOS or Windows.
  ```
- This does NOT apply to inline emphasis within flowing prose (e.g., "the key difference is **chat is a conversation**").

#### Medium SEO Rules

From `Reference/Medium-SEO-Notes.md`:
- SEO-friendly title with primary keyword
- Keyword in first paragraph
- Use H2 subheadings with keyword variations
- Add relevant Medium tags (up to 5)
- No need for Medium Partner Program — articles drive traffic to Gumroad

#### Gumroad CTA Placement

When a relevant digital product exists, embed Gumroad links:
- **Early mention** (within first 300 words): Natural reference, not a hard sell
- **Mid-article**: After demonstrating value, mention the product as a deeper resource
- **End**: Clear CTA in the Key Takeaway or after FAQs

If no product exists yet for this topic, skip CTAs. Don't force it.

#### Internal Linking

Only link to articles that already exist in `02-Articles/Published/`. Never reference or link to articles that haven't been written yet — no "I cover this in my guide on X" unless that guide is actually published. Check the Published folder before adding any internal link.

When a published article is relevant, add a natural link. Build the content cluster through cross-references.

### Step 2.3: Article Structure

The complete draft file must contain, in order:

#### 1. SEO Metadata

```markdown
## SEO Metadata

- **Primary Keyword:** [exact keyword]
- **Secondary Keywords:** [2-3 related keywords to work in naturally]
- **SEO Title Options:**
  1. "[Title 1]" ([N] chars)
  2. "[Title 2]" ([N] chars)
  3. "[Title 3]" ([N] chars)
- **Slug:** [keyword-slug]
- **Meta Description:** "[description]" ([N] chars — target 140-156)
- **H1:** [Benefit-oriented, keyword included]
- **Medium Tags:** [up to 5 relevant tags]
```

**H1 Style Guide:**
- Include the primary keyword
- Make it benefit-oriented or curiosity-driven
- Good: "What is Claude Cowork? Everything You Need to Know (And What Nobody Tells You)"
- Good: "Claude Cowork vs Claude Code: Which One Should You Actually Use?"
- Avoid: generic "Ultimate Guide" or "Everything You Need to Know" without a hook

#### 2. The Article

```markdown
# [H1]

### Overview
- [Standalone takeaway 1 — a useful insight, not a section signpost]
- [Standalone takeaway 2]
- [Standalone takeaway 3]
- [Standalone takeaway 4 — optional]
- [Standalone takeaway 5 — optional]
<!-- IMPORTANT: Overview bullets must be standalone takeaways a scanner walks away with, NOT a table of contents. Each bullet conveys a conclusion or insight. "The best skills cover X, Y, and Z" is a takeaway. "The best skills to install right now" is a table of contents entry. -->

[Introduction — hook → direct answer → nuance, 150-250 words]

## [H2 Section 1 — addresses primary search intent]

## [H2 Section 2]

## [H2 Section 3]

## [H2 Sections 4-6 — as needed for depth]

## The Key Takeaway
[2-3 paragraphs, practical closing insight, Gumroad CTA if applicable]

## Frequently Asked Questions

### [PAA Question 1]
[80-150 words, direct answer]

### [PAA Question 2]
[80-150 words]

### [PAA Question 3]
[80-150 words]

## Sources

1. [Publisher — Document title](URL)
2. [Publisher — Document title](URL)
3. [Publisher — Document title](URL)
<!-- Numbered list of every source linked inline in the article body, in order of first appearance -->
```

### Step 2.4: Quality Self-Check

Before saving, verify:
- [ ] Primary keyword appears in H1, first paragraph, and at least 2 H2s
- [ ] Secondary keywords worked in naturally (not forced)
- [ ] No preambles, no filler, no generic openings
- [ ] Every paragraph is 2-3 sentences max
- [ ] Voice matches Voice-Guide.md (conversational, specific, practical)
- [ ] Personal experience or real-world specifics included (not just rephrased competitor content)
- [ ] All competitive baseline topics covered
- [ ] Introduction directly answers the search query within first 3 sentences
- [ ] Word count meets tier target
- [ ] Medium tags selected (up to 5)
- [ ] Meta description is 140-156 chars, compelling, includes keyword
- [ ] FAQs use actual PAA questions from SERP data
- [ ] Internal links to other cluster articles where natural
- [ ] Gumroad CTAs placed naturally (if applicable product exists)
- [ ] No emoji in body text
- [ ] No "In this article I'll show you" or similar preambles
- [ ] Overview bullets are standalone takeaways, NOT a table of contents (each conveys an insight a scanner walks away with, not just a section signpost)
- [ ] Read the draft out loud mentally — does it sound like a real person talking?
- [ ] Every H2 section opens with a citation capsule: 40-60 word answer-first passage with a sourced data point
- [ ] Every stat/data point traces to a Tier 1-3 source (per `Reference/Source-Tiers.md`)
- [ ] All sources use inline links on natural nouns (no parenthetical citations, no "According to...")
- [ ] No unsourced statistics or vague attribution ("studies show", "experts say", "research indicates")
- [ ] Article ends with a `## Sources` section: numbered list of every source linked inline, in order of first appearance

### Step 2.5: Save Draft

Save to: `${ARTICLE_DIR}/v1-draft.md`

Add YAML frontmatter:
```yaml
---
date: [TODAY]
keyword: "[keyword]"
version: v1
status: draft
word_count: [N]
tier: [in-depth-guide | comparison | focused-topic]
medium_tags: [tag1, tag2, tag3, tag4, tag5]
---
```

---

## Completion Output

After saving all files, confirm:

```
Phase 1 complete: stage1_analysis.md + competitors/
Phase 2 complete: v1-draft.md

Folder: 02-Articles/In-Progress/[NNN]-[slug]/
Competitors saved: [N] articles in competitors/
Word count: ~[N] words
Article type: [in-depth guide / comparison / focused topic]
FAQs: [N] questions
Gumroad CTAs: [yes/no]

Ready for your review.
```
