# Source Tiers for AI Tools Content

Tiered framework for citing statistics, data points, and factual claims. Higher tiers = stronger E-E-A-T signal. Every stat in the article must trace to T1-T3.

## Tier 1: Official Sources

First-party documentation, changelogs, pricing pages, and official announcements from the tool maker.

**Examples:** Anthropic docs, Suno release notes, Wispr Flow docs, OpenAI blog, Google AI announcements, official GitHub repos, product pricing pages, official API documentation.

**Signal in prose:** "Cowork launched as a research preview in early 2026 and hit enterprise GA by April ([changelog](URL))."

**When to use:** Default tier for any claim about a specific tool's features, pricing, capabilities, or limitations. If an official source exists, use it.

## Tier 2: Primary Data

Named research studies with disclosed methodology, verified benchmarks, and authoritative industry reports.

**Examples:** State of AI Report, GitHub Developer Survey, Stack Overflow Developer Survey, Ahrefs/Semrush research studies (with methodology), McKinsey/Gartner reports (with sample sizes), academic papers, platform usage statistics with named methodology.

**Signal in prose:** "44% of developers now use AI coding tools daily. That's from [Stack Overflow's 2026 survey](URL) of 65,000 devs."

**When to use:** Market-level claims, adoption statistics, industry trends. The source must have a named methodology or sample size. Round numbers without methodology = reject.

## Tier 3: Practitioner Authority

Established voices with demonstrated, verifiable expertise. Known builders and researchers whose work is public and cited by others.

**Examples:** Simon Willison (AI/LLM tooling), Ethan Mollick (AI adoption research), Andrej Karpathy (AI/ML), Swyx (AI engineering), official team/engineering blogs from tool companies, well-known open-source maintainers writing about their tools.

**Signal in prose:** "Simon Willison [tested this across 15 prompt patterns](URL) and hit diminishing returns after the third."

**When to use:** Expert takes, technical analysis, nuanced opinions grounded in demonstrated expertise. The person must have a public track record in the specific domain.

## Tier 4: Community Signal

Reddit, Hacker News, Twitter/X consensus. Volume and consistency of reports, not individual authority.

**Signal in prose:** "Users on [r/ClaudeAI](https://www.reddit.com/r/ClaudeAI/) consistently report hitting usage limits faster than expected."

**When to use:** Patterns of user experience that no single official source captures. Useful for "what real users actually experience" vs. what the docs say. Never cite a single Reddit comment as fact. Look for consistent reports across multiple threads/users.

**NOT a source for:** Hard statistics, feature claims, pricing, or capabilities. Community signal corroborates or contextualizes, it doesn't establish facts.

## Reject

Never cite these. They hurt E-E-A-T rather than help it.

- Generic "Top 10 AI tools" roundup articles
- Content mill posts (no named author, no methodology)
- AI-generated listicles
- Unsourced claims or statistics
- Stats that only appear on one low-authority site
- "Suspiciously precise" numbers for broad claims (e.g., "AI improves productivity by 47.3%")
- Affiliate review sites with no disclosed testing methodology

## Citation Format (Medium-native, the author's voice)

Citations must sound like you wrote them, not like an SEO blog or research paper. The data point is woven into conversational prose. You state the fact directly, then the source attribution is a natural aside or inline link — never the grammatical subject of the sentence.

### The Voice Rule

The author states things. They don't defer to authorities. They tell you what's true based on what they've found, and the source is there if you want to check.

**NEVER start a sentence with:**
- "According to..."
- "Research shows..."
- "Studies indicate..."
- "Anthropic describes X as..."
- "[Source] found that..."
- "A 2026 study by [X] reveals..."

These are academic/Ahrefs patterns. They're formal, they're deferential, and they don't sound like a person talking.

**INSTEAD, state the fact directly. Attach the source as an inline link on a natural noun:**

**Good (the author's voice):**
- "Cowork tasks burn about 3.2x more tokens than a regular chat message — Anthropic confirmed this in their [usage documentation](URL) and I've seen it track in my own billing."
- "44% of developers now use AI coding tools daily. That's from [Stack Overflow's 2026 survey](URL) of 65,000 devs, and it matches what I'm seeing in the communities I follow."
- "Simon Willison [tested this across 15 prompt patterns](URL) and hit diminishing returns after the third. I've had a similar experience."
- "The skill ecosystem has over 91,000 entries on [skills.sh](URL) alone."
- "Users on [r/ClaudeAI](URL) consistently report hitting usage limits faster than expected."

**Bad (formal/academic/Ahrefs voice):**
- "According to Anthropic's documentation, Cowork is an agentic experience for knowledge work." (defers to authority)
- "A 2026 Stack Overflow survey of 65,000 developers found that..." (survey is the grammatical subject)
- "Research by Simon Willison demonstrates that..." (academic framing)
- "Anthropic's architecture docs confirm that Cowork executes tasks through..." (the docs are talking, not the author)
- "(Source: Anthropic, 2026)" — parenthetical citations look academic, not conversational

### How the source appears

**Always use inline links.** The source link goes on a natural noun in the sentence. No parenthetical citations, no trailing "(Source)" notation, no footnote-style numbers.

1. **Inline link on a noun:** "...in their [usage docs](URL)..."
2. **Inline link on a source name:** "...on [r/ClaudeAI](URL)..."
3. **Named person + link:** "Simon Willison [tested this](URL) and found..."
4. **Short aside with link:** "...that's from [Stack Overflow's 2026 survey](URL), and it matches what I see."

The source link is there for readers who want to verify. It shouldn't interrupt the reading flow.

If the source is behind a login or is ephemeral (a tweet, a Reddit thread), describe it specifically enough that a reader could find it: "A thread on [r/ClaudeAI](URL) with 200+ upvotes from April 2026 nailed this..."

### Sources Block (bottom of article)

Every article ends with a `## Sources` section after the FAQs. This is a numbered list of every source cited in the article. Each entry is a linked title with enough context to identify it.

**Format:**
```markdown
## Sources

1. [Anthropic — Claude Cowork documentation](URL)
2. [Anthropic — Pricing](URL)
3. [Stack Overflow — 2026 Developer Survey](URL)
4. [skills.sh — Community skill directory](URL)
5. [r/ClaudeAI — Reddit community](https://www.reddit.com/r/ClaudeAI/)
```

**Rules:**
- Number each source sequentially in the order it first appears in the article
- Use the format: `[Publisher/Author — Document title or description](URL)`
- Include every source that's linked inline in the article body
- No sources that aren't also linked inline — the block collects, it doesn't add
- This section goes after FAQs and before any Gumroad CTA footer

## Citation Density

**Target:** At least one sourced data point per H2 section opener. Additional sources woven naturally where they strengthen a claim.

**Not:** Every 75-100 words (that's academic). More like every 200-300 words for hard data, with practitioner experience and personal observation filling the space between.

The goal: every H2 section should have at least one moment where the reader thinks "oh, that's backed by something real" without the article reading like a research paper.

## Citation Capsules (for AI Citability)

Each H2 section opener should function as a self-contained 40-60 word passage that:
1. Directly answers the heading's question
2. Includes one specific data point with source attribution
3. Makes sense if extracted in isolation (an AI system could quote it without context)

This is the answer-first pattern. State the answer directly with a data point, then expand with your take.

**Example:**
```
## Does Claude Code actually save time on real projects?

Claude Code hits a 72% success rate on SWE-bench tasks per
[Anthropic's May 2026 benchmarks](URL). But benchmarks aren't real work.
The actual time savings depend on how you structure your workflow. I've seen
tasks go from 45 minutes to under 5 when the approach is dialed in.
```

The first two sentences are the citation capsule — direct, factual, self-contained. The source is an inline link on a natural noun, not the subject of the sentence. Then your personal take follows naturally.