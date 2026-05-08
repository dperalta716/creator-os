# Claims Verification Reference

Detailed process for Phase 3 of the review pipeline. Read this file when entering Phase 3.

## What Counts as a Claim

A claim is any sentence that asserts a factual statement about a tool — something that could be checked against official documentation and found to be right or wrong.

**Verify these (factual assertions):**
- Feature existence: "Claude Code supports MCP servers"
- Pricing and plans: "The Pro plan costs $20/month"
- Capability limits: "Supports up to 200k tokens"
- Version numbers and dates: "Released in January 2025"
- Integration/compatibility: "Works with VS Code, Neovim, and JetBrains"
- Technical requirements: "Requires Node.js 18+"
- Comparison claims: "Claude Code is faster than Cursor at multi-file edits"
- How something works: "Claude Code uses git worktrees for parallel tasks"

**Don't verify (opinions, experience, methodology):**
- Personal experience: "I find this workflow faster"
- Subjective assessments: "This is the best tool for content creators"
- General observations: "Most developers prefer terminal-based tools"
- How-to instructions: steps in a tutorial describe a process, not a claim
- Descriptions of personal workflows: "I use this every morning to..."
- Qualitative comparisons based on experience: "It feels snappier than..."

## Identifying Claims (Without Citations)

There are no academic citations to flag claims. Instead, scan for sentences containing:

1. **A tool or product name** (Claude, Claude Code, Suno, Wispr Flow, Groq, etc.)
2. **Combined with a factual assertion verb:** supports, costs, includes, allows, requires, works with, is available, was released, can, cannot, enables, integrates with, ships with, comes with, runs on, uses

This heuristic won't catch every claim, but it catches the high-risk ones — the factual assertions that would damage credibility if wrong.

**Examples of extracted claims:**
- "Claude Code **supports** MCP servers for extending its capabilities" → verify
- "Suno **allows** up to 10 free songs per day" → verify
- "The Groq API **costs** nothing for the free tier" → verify
- "I **find** Claude Code faster for multi-file edits" → skip (personal experience)

## Where to Verify: Official Documentation Sources

Go to the official source for whatever tool the article discusses. The tool determines the source, not a fixed list.

### Known Tools and Their Documentation

| Tool / Product | Primary Documentation Source |
|---|---|
| Claude / Claude Code / Claude CoWork | docs.anthropic.com, anthropic.com/claude |
| Anthropic API | docs.anthropic.com/en/docs |
| Suno AI | suno.com/faq, suno.com/blog |
| Wispr Flow | wispr.com, wispr.com/flow |
| Groq API | console.groq.com/docs |
| GPT Image / OpenAI | platform.openai.com/docs |
| Nano Banana | Check their official site at time of verification |

### For Any Other Tool

If the article discusses a tool not listed above:
1. Identify the tool's official website
2. Look for: /docs, /documentation, /faq, /pricing, /changelog, /blog
3. Prefer official sources over third-party reviews or blog posts

### Source Hierarchy (most to least authoritative)

1. **Official documentation** — the tool's own docs site
2. **Official changelogs / release notes** — GitHub releases, blog announcements
3. **Pricing pages** — current at time of fetch
4. **Official social media** — announcements from the company's verified accounts
5. **Community sources with official responses** — GitHub issues where a maintainer responded

Never use: Reddit posts, Medium articles by other authors, StackOverflow answers, or AI-generated summaries as authoritative sources for factual claims.

## Verification Process

For each identified claim:

### Step 1: Determine the Source
What specific page would confirm or deny this claim?
- Feature claim → docs page for that feature
- Pricing claim → pricing page
- Release date → changelog or announcement blog post
- Capability limit → docs page on limits/quotas

### Step 2: Fetch the Source
```
WebFetch the URL
  ↓ if blocked or JS-heavy
Firecrawl the URL
  ↓ if still inaccessible
Mark as UNVERIFIABLE with note
```

### Step 3: Compare
Read what the source actually says. Compare against what the article claims. Be precise — "up to 200k tokens" is different from "200k tokens".

### Step 4: Grade

| Grade | Meaning | Action |
|---|---|---|
| VERIFIED | Source confirms the claim as stated | No change needed |
| OUTDATED | Claim was once true but source shows it's changed | Correct with current info |
| INACCURATE | Claim doesn't match what the source says | Correct or remove |
| UNVERIFIABLE | Source is inaccessible or claim can't be checked against any official source | Flag for the user — note what you tried |

### Step 5: Correct (if needed)

When rewriting a correction:
- Match the tone and voice of the surrounding text
- Use contractions, short sentences, conversational style
- Don't paste documentation language — translate it into the author's voice
- Keep the same paragraph structure and flow
- If the correction changes the meaning significantly, flag it for the user rather than silently rewriting

**Bad correction (docs voice):**
> "Claude Code supports context windows of up to 200,000 tokens as specified in the model documentation."

**Good correction (the author's voice):**
> "Claude Code gives you up to 200k tokens of context — enough to hold your entire codebase in a single conversation."

## Output Format

After verification, produce a claims report:

```
Claims Verification Report: [article name]

Total claims checked: N
  VERIFIED: N
  OUTDATED: N — corrected in v3-final.md
  INACCURATE: N — corrected in v3-final.md
  UNVERIFIABLE: N — flagged below

Corrections applied:
1. Line ~[N]: "[original claim]" → "[corrected claim]"
   Source: [URL]
   
2. ...

Unverifiable claims (the user to review):
1. Line ~[N]: "[claim]" — [what was tried, why it couldn't be verified]
```

## When the Tool Changes Fast

AI tools change constantly. A claim that was accurate last week might be outdated today. When verifying:

- Check the date on the documentation page if visible
- If the docs page shows a recent update, note this in the report
- For pricing claims, always re-verify — pricing changes frequently
- For feature claims about beta/preview features, note that these may change
