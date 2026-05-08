---
name: review-article
description: Post-draft review pipeline for Medium articles. Runs unique value analysis (against competitor research), quality/SEO checks, internal linking, and claims verification. Use after /generate-article produces a v1 draft, or on any draft in 02-Articles/In-Progress/. Trigger on "review the draft", "review article", "run the review pipeline", "check the draft", or when a v1-draft.md exists and needs review.
argument-hint: article folder name or number (e.g., "001-what-is-claude-cowork" or "001")
user-invocable: true
---

# Review Article

Post-draft review pipeline. Takes a v1 draft (from `/generate-article`) through three phases: unique value & quality review, internal linking, and claims verification. Each phase produces a new versioned file — originals are never modified.

## Usage

```
/review-article 001-what-is-claude-cowork
/review-article 001
```

The argument identifies the article folder inside `02-Articles/In-Progress/`.

---

## Step 0: Apply Learnings

Read the `## Rules` section below (already in context). If `learnings.md` exists in this skill's directory, read it too. Apply all rules during this execution.

## Step 0.5: Locate Files

1. Resolve the article folder path: `02-Articles/In-Progress/[argument]/`
   - If the argument is just a number (e.g., "001"), glob for the matching folder
2. Find the latest draft version in the folder (highest `vN-*.md` file)
3. Read the draft
4. Read `stage1_analysis.md` from the same folder (this is the competitor analysis — essential for the unique value assessment)
5. Read `Reference/Voice-Guide.md`
6. Read `Reference/Source-Tiers.md` (citation framework and source tier rules)

If `stage1_analysis.md` doesn't exist, warn and proceed without the unique value comparison — but flag that the review will be weaker without it.

---

## PHASE 0.75: Competitive Coverage Audit

Re-read the actual competitor drafts — not just the stage1 summary — to build a detailed picture of what the draft must beat.

### Step 0.75.1: Read Competitor Drafts

Read all `.md` files in the article's `competitors/` subfolder. If the folder is empty or missing, warn and skip to Phase 1 (the review proceeds using only `stage1_analysis.md`, but flag that the competitive audit was skipped).

### Step 0.75.2: Build Coverage Matrix

For each must-cover topic from `stage1_analysis.md`, note:
- **Which competitors cover it** and at what depth (brief mention / partial section / full section with examples)
- **Specific details** each competitor provides — exact examples, numbers, workflows, use cases
- **Best-in-class treatment** — which competitor handles this topic best, and what makes it good

### Step 0.75.3: Identify Synthesis Opportunities

Look for points that appear across multiple competitors but are never connected:
- Competitor A covers X, Competitor B covers Y, but nobody links X → Y
- Multiple competitors mention the same limitation but none offer a workaround
- Several competitors describe a feature differently — the draft should give the clearest explanation

### Step 0.75.4: Gap Check Against Draft

For each row in the coverage matrix, check the current draft:
- **Covered and exceeds** — draft goes deeper or adds real examples competitors lack
- **Covered but shallow** — draft mentions the topic but a competitor goes deeper. Flag for expansion in Phase 1.
- **Missing entirely** — a substantive point from competitors that the draft doesn't address. Flag as a gap for Phase 1 to fill.

The coverage matrix and gap check feed directly into Phase 1A below. Do not produce a separate file — hold the analysis in context.

---

## PHASE 1: Unique Value & Quality Review

This phase has two lenses: (A) is the article actually adding something beyond what competitors wrote, and (B) does it meet quality and SEO standards.

### A. Unique Value Assessment

Using both `stage1_analysis.md` and the Phase 0.75 coverage matrix, evaluate:

**1. Competitive gaps addressed.** The stage1 analysis identifies what competitors miss. Does this draft actually fill those gaps with substance, or does it just cover the same ground?

**2. No competitor beats us on depth.** Using the Phase 0.75 coverage matrix: for every topic flagged as "covered but shallow" or "missing entirely," expand or add content so the draft matches or exceeds the best-in-class competitor treatment. Apply synthesis opportunities identified in Step 0.75.3.

**3. Personal experience present.** Does the draft include real-world specifics — actual workflows, exact results, personal observations? Or is it rephrased competitor content? Look for "I use this for...", "Here's what I found...", specific numbers, named tools/settings.

**4. Practical and actionable.** Can the reader DO something after reading each section? Specific steps, real examples, concrete workflows — not vague advice.

**5. Competitive baseline covered.** Topics covered by 3+ competitors (identified in stage1 analysis) are must-cover. Verify they're all present.

**5. No phantom links.** Check `02-Articles/Published/` — any internal link must point to an article that actually exists there. Flag and remove any links to unpublished articles.

### B. Quality & SEO Checks

**Structure:**
- Word count meets tier target (guide: 1500-2500, comparison: 1000-1800, focused: 1000-1500)
- Has Overview section with 3-5 bullets. **Each bullet must be a standalone takeaway, NOT a table of contents entry.** A takeaway conveys a useful insight or conclusion a scanner walks away with ("The best skills cover content creation, marketing, and research, with most taking under five minutes to set up"). A table of contents entry just signposts a section ("The best skills to install right now"). If any bullet reads like a TOC entry, rewrite it as a takeaway.
- Has Key Takeaway section
- Has FAQ section with 3 questions (from PAA data in stage1 analysis)
- Proper H2/H3 hierarchy
- Each H2 section: 200-500 words (not bloated or thin)

**Medium formatting (critical — check every section):**
- No blank line between any header (`##`, `###`) and the content below it. Header flows directly into text.
- Bold inline labels (pricing tiers, feature lists, limitation callouts, use case categories) must be on their own line with no trailing period, colon, or em dash. The description starts on the next line as regular text. Example:
  ```
  **Desktop app required**
  Cowork only runs in the Claude Desktop app.
  ```
  NOT: `**Desktop app required.** Cowork only runs in...`
  NOT: `**Desktop app required** — Cowork only runs in...`
- This applies whenever a section lists distinct items with bold labels. It does NOT apply to inline emphasis within flowing prose.

**Tone & AI tells (full enforcement — read `Reference/Voice-Guide.md` before grading):**

Run two passes on the draft:

*Pass 1 — Voice.* Check for what AI drafts tend to miss:
- Does the draft include actual opinions, not just descriptions?
- Is there rhythm variation (short punchy sentences mixed with longer ones), or is it medium-medium-medium?
- Is first person used where it fits?
- Are details specific (exact numbers, tool names, results) or abstract ("significantly improved")?
- Are mixed feelings expressed where the topic is genuinely mixed?

*Pass 2 — AI tells.* Scan for all four families from the Voice Guide:
- **Family 1 (Inflated importance):** Check for banned words (seamless, unlock, empower, pivotal, etc.) and vague attribution ("experts say").
- **Family 2 (Fake depth):** Check for -ing words doing fake work, copula avoidance ("serves as"), rule-of-three padding, "not just X but also Y."
- **Family 3 (Cosmetic tells):** Count em dashes (aim for zero or near-zero). Check for unnecessary bold, title case headings (H2+ must be sentence case), curly quotes, elegant variation, false ranges.
- **Family 4 (Conversational artifacts):** Check for chatbot framing, hedging ("may potentially"), filler phrases ("in order to"), sycophancy, generic conclusions.

Grade each family as PASS / NEEDS WORK. Auto-fix everything flagged. After fixing, run a one-line audit: "What would still tip a reader off that this is AI?" Revise once more based on the answer.

Basic checks (still enforced):
- **Whitespace / paragraph breaks:** 2-3 sentences max per paragraph, but break at idea boundaries not sentence counts. Each distinct idea gets its own paragraph. Punchy payoff lines stand alone. Quoted examples get isolated from setup and consequence. If a paragraph has 4+ sentences, it almost certainly needs a break. Flag and fix any dense blocks.
- Active voice predominant
- No preambles, no generic filler, no competitor callouts, no emoji
- Conversational, not academic

**Sources & citations (per `Reference/Source-Tiers.md`):**

*Source tier audit.* For every statistic, data point, or factual claim in the draft:
- Identify the source. Is it named? Is the year/timeframe specified?
- Classify by tier: T1 (official docs), T2 (named research), T3 (practitioner authority), T4 (community signal), or unsourced.
- Flag and fix: unsourced stats ("studies show..."), vague attribution ("experts say..."), and any stat that traces to Reject-tier sources (content mills, unsourced roundups).
- For T4 community citations, verify they're used only for user experience patterns, never for hard facts about features or pricing.

*Citation capsule audit.* For each H2 section:
- Does the section open with a 40-60 word answer-first passage?
- Does that passage contain at least one specific data point with source attribution?
- Would the passage make sense extracted in isolation (could an AI system quote it without surrounding context)?
- If any H2 opener lacks a citation capsule, add one. The source should be T1-T2 where possible.

*Freshness check.* For any sourced data point:
- Is the cited version/date still current? AI tools change fast. A stat from 2024 about a tool that's been through three major updates is misleading.
- Flag stats older than 12 months for tool-specific claims. Market-level trends can be older if no newer data exists.

Grade sources as: ALL T1-T3 / NEEDS WORK (has unsourced or Reject-tier stats) / MISSING (no sourced data points).

**SEO:**
- Primary keyword in H1, first paragraph, and at least 2 H2 headings
- 3 SEO title options (50-60 chars each)
- Meta description under 160 chars, includes keyword
- Medium tags selected (up to 5)
- Introduction directly answers the search query within first 3 sentences

### Applying Fixes

**Content Preservation Guardrail:** Fixes can ADD or MODIFY content. Never DELETE content except for violations of the Voice Guide "Don't" list (preambles, filler, competitor callouts, emoji). When a section is thin, expand it — don't flag it and move on.

Present findings as a graded report:
- List each check with PASS / NEEDS WORK
- For NEEDS WORK items, show the specific issue and the fix applied

**Auto-apply all fixes.** If a fix requires the user's real-world input (e.g., a personal anecdote Claude can't fabricate), insert an HTML comment placeholder (`<!-- TODO: [what's needed] -->`) in the draft. Phase 4 will collect these placeholders and ask the user targeted questions to fill them.

Save as the next version:
- Input: `v1-draft.md` (or latest version) → Output: `v2-reviewed.md`

---

## PHASE 1.5: Kick Off Image Generation (Background)

After Phase 1 completes and `v2-reviewed.md` is saved, the article structure and concepts are locked. Spawn a **background sub-agent** (using `Agent` with `run_in_background: true`) to run `/generate-article-images [article-folder]`.

The sub-agent follows the full process defined in the `generate-article-images` skill — all style rules, learnings, and preferences live there. Do not duplicate those instructions here.

**Why after Phase 1:** Phase 1 locks the article structure. Phases 2-4 only make minor edits (links, claim corrections, personal anecdotes) that don't change what concepts need illustration. Running image generation in parallel saves ~10-15 minutes of dead time.

---

## PHASE 2: Internal Linking

1. Check `02-Articles/Published/` for existing published articles
2. If the folder is empty or contains only `.gitkeep`, output: **"No internal links — no published articles yet."** and skip to Phase 3.
3. If published articles exist, read their frontmatter/titles to understand their topics
4. Only suggest links where there's genuine topical overlap — a Claude CoWork article links to another Claude article, not to Suno
5. For each suggested link: specify the exact sentence to add it to, the anchor text, and the target article
6. Apply forward links (new → old) automatically
7. List backward link recommendations in the completion output (don't modify existing published articles automatically — the user reviews those).

Internal links don't justify a separate version file — they're folded into the Phase 3 output.

---

## PHASE 3: Claims Verification

Read `references/claims-verification.md` for the detailed verification process.

**Summary:** Extract every factual assertion about a tool (features, pricing, capabilities, versions, integrations). For each claim, fetch the official documentation for that specific tool and compare. Grade as VERIFIED / OUTDATED / INACCURATE / UNVERIFIABLE. Propose corrections for anything that's wrong.

**Critical rule:** When a claim needs correction based on documentation, rewrite the corrected sentence in the author's voice — matching the tone and style of the surrounding text. Don't paste documentation language into the article. The correction should read like the author wrote it, not like a docs page was copied.

After claims verification, save an intermediate version:
- Output: `v3-verified.md`

---

## PHASE 4: Personal Experience Interview

After all automated review is complete, identify where the user's real-world experience would elevate the article beyond competitors. This runs last because the draft is now polished, gaps are identified, and the competitive coverage audit (Phase 0.75) provides specific context for what competitors do well that personal experience could beat.

### Step 4.1: Identify Experience Gaps

Re-read the current draft alongside the competitor articles in `competitors/` and the Phase 0.75 coverage matrix. For each H2 section, assess:
- Does this section rely on general knowledge that any AI could write, or does it contain specifics only a real user would know?
- Is there a competitor section that's stronger because they included personal experience?
- Would a concrete anecdote, workflow detail, or "here's what actually happened when I tried this" make this section meaningfully better?
- Are there any `<!-- TODO: ... -->` placeholders inserted during earlier phases?

Select the 3-5 highest-impact spots where personal experience would most differentiate the article from competitors. Include any `<!-- TODO -->` placeholders in the list.

### Step 4.2: Ask the User

Present the experience gaps as targeted questions. Be specific about what kind of input would help — not "tell me about your experience with X" but "have you done Y? What happened?" Reference the specific competitor treatment that personal experience would beat.

Format:

```
The review is complete. Before the final version, there are a few spots where
your real experience would make this article beat everything else out there:

1. [Section name]: [Specific question — e.g., "The Duke competitor has a real
   receipt-processing story here. Have you used Cowork for file organization?
   What folder did you point it at and what did it actually do?"]

2. [Section name]: [Specific question]

3. [Section name]: [Specific question]

You can answer any, all, or none. If you skip this, the current draft becomes
the final version as-is.
```

### Step 4.3: Weave In Responses

If the user provides answers:
1. Integrate their input into the relevant sections — rewrite in their voice, not as a quoted insert
2. Keep the surrounding structure intact; only expand or replace the generic content with their specifics
3. Remove any `<!-- TODO -->` placeholders that were addressed
4. Save as the final version: `v4-final.md`
5. Note in the completion output which sections were updated with personal experience

If the user skips or says "none," rename `v3-verified.md` to `v4-final.md` (or save a copy) and proceed to Phase 4.4.

---

## PHASE 4.4: Image Selection & Embedding

By now the background image generation sub-agent (Phase 1.5) should be complete. If it hasn't finished, wait for it.

### Step 4.4.1: Present Image Picks

Read `[article-folder]/assets/IMAGE-PICKS.md` and show the user each A/B pair. For each slot:
- Show image A and image B (using Read on the image files)
- State where in the article it would go
- Ask the user to pick A or B (or request a regeneration if neither works)

### Step 4.4.2: Embed Selected Images

For each pick:
1. Copy the selected image to a final filename (e.g., `01-hero-final.png`) or use it as-is
2. Insert a markdown image reference (`![alt text](assets/filename.png)`) at the correct location in `v4-final.md`
3. Save the updated file as `v5-draft.md`

If the user wants an image edited (e.g., remove an element, change text), use the fal-ai edit script on the selected image before embedding.

---

## Completion Output

```
Review complete: [article folder]

Phase 0.75 — Competitive Coverage Audit:
  Competitors read: [N]
  Gaps found: [N covered-but-shallow, N missing]
  Synthesis opportunities: [N]

Phase 1 — Unique Value & Quality:
  Unique value score: [X/6 checks passed]
  Quality/SEO: [X issues found, X fixed]
  
Phase 2 — Internal Links:
  [N links added / "No published articles yet"]
  Backward link suggestions: [list or "none"]

Phase 3 — Claims Verification:
  [N claims checked]
  Verified: N | Outdated: N | Inaccurate: N | Unverifiable: N
  [N corrections applied]

Phase 4 — Personal Experience:
  [N questions asked]
  [N sections enriched / "Skipped — draft unchanged"]

Phase 4.4 — Image Selection:
  [N image slots identified]
  [N A/B pairs generated]
  [N images embedded after the user's picks]

Files:
  v2-reviewed.md   (after Phase 1)
  v3-verified.md   (after Phases 2+3)
  v4-final.md      (after Phase 4)
  v5-draft.md      (after Phase 4.4 — with images)
  assets/          (all generated images + IMAGE-PICKS.md)

Ready for your review before publishing.
```

---

## Step Final: Collect Feedback

After delivering the completion output, add one line: "If anything was too aggressive, too lenient, or missed — let me know and I'll update the skill."

If feedback is given, trigger the Self-Update process below.

---

## Rules

*Updated when the user flags issues. Read before every run.*

<!-- Rules accumulate here as the skill is used. Keep each rule to 1-2 lines. -->

- **Verify every "built-in" claim.** If the draft says a feature/skill is built into a product, the claims verification phase must confirm it against official docs. Don't assume v1 draft claims about built-in features are accurate — they may be hallucinated.

---

## Self-Update

When the user provides feedback — missed issues, wrong fixes, bad tone in corrections, over/under-flagging — respond in this order:

1. **Fix the current output** based on the feedback
2. **Fix the source** — update the relevant SKILL.md step or reference file so it doesn't recur
3. **Add a Rule** to the `## Rules` section above if Claude might repeat the mistake in a future session (1-2 lines)
4. **Log to `learnings.md`** only if the failure story adds context the fix alone doesn't convey
