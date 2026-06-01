---
name: tone-of-voice
description: Discover your unique writing voice through adaptive interviewing and content analysis, then generate a personalized voice guide. Use when you need to create or refine a voice guide for any content project. Supports analyzing existing blog/YouTube content or building from scratch through conversation.
argument-hint: optional URL to blog or YouTube channel (e.g., "https://myblog.com")
user-invocable: true
---

# Tone of Voice

Discover a user's writing voice and generate a personalized voice guide through journey-based interviewing, content analysis, and iterative calibration with writing samples.

## Usage

```
/tone-of-voice
/tone-of-voice https://myblog.com
/tone-of-voice https://youtube.com/@channel
```

---

## Step 0: Initialize

1. Read `learnings.md` in this skill's directory for accumulated rules
2. Read `references/question-bank.md` for the interview question bank
3. Read `references/voice-guide-template.md` for the output format
4. Note the user's target format (from Step 1) — this determines which pre-built format template to use in Phase 2
5. Pre-seed perspective data from project context (see Step 0.5)

## Step 0.5: Pre-Seed from Project Context

If the project has a `CLAUDE.md` and/or `04-Strategy/Content-Pillars.md`, read them before interviewing. These often already hold the user's positioning from an earlier setup step.

From Content-Pillars.md (each pillar: name, 2-3 sentence description, seed keywords) and CLAUDE.md (name, niche), pre-seed the perspective data fields where the source is clear:
- `content_space` — from the niche and pillar topics
- `core_expertise` — from the pillar descriptions and unique angles
- `unique_insight` — from any "what they know that others don't" framing in the pillars
- `solution_approach` — from the positioning in the pillar descriptions
- `audience_pain_points` — partial, only if a pillar names them

Mark each pre-seeded field as "needs confirmation," not confident. Do NOT pre-seed the voice scorecard dimensions, `proof_points`, `before_state`, or `transformation` — pillars don't capture those.

If neither file exists, skip this step and interview from scratch as normal.

## Step 1: Entry Point Detection

**Setup context:** If this skill was invoked with the `from-setup` argument (i.e. `/tone-of-voice from-setup`), apply these overrides and SKIP the URL / existing-guide detection below:
- Target format is **blog / Medium articles** — do not ask "what will you use this for."
- Treat the shipped `Reference/Voice-Guide.md` as a generic starter, NOT a user-authored guide: do NOT run the "refine or start fresh" prompt.
- Go straight to Phase 1, **Path B (Interview)**, using the Step 0.5 pillar pre-seed — do not ask "do you have existing content."
- Save path is fixed to `Reference/Voice-Guide.md` (see Step 2.8) — do not offer a format-specific filename.

Otherwise, check if the user passed a URL argument.

**If URL argument provided (Entry C):**
- Detect type: blog URL or YouTube channel URL
- Ask: "Want to pick your best pieces, or should I choose?"
- Ask: "What will you mainly use this voice guide for? (blog, social, newsletter, product copy, YouTube scripts, etc.)"
- Skip to Phase 1, Path A (Content Ingestion)

**If no argument provided:**
- Search the current project for an existing voice guide. Check these locations in order:
  1. `./Reference/Voice-Guide.md`
  2. Any `Voice-Guide.md` or `voice-guide.md` in the project root or common directories
  3. Any file referenced as a voice guide in `CLAUDE.md`

**If existing guide found (Entry B):**
- Say: "I found an existing voice guide at [path]. Do you want to refine it or start fresh?"
  - **"Refine"** → go to Refine Mode (see below)
  - **"Start fresh"** → proceed to Entry A

**If no existing guide found (Entry A):**
- Ask: "Do you have existing content I can analyze, or should we start from scratch?"
  - **"I have content"** → ask for blog URL, YouTube channel URL, or pasted text. Also ask: "Want to pick your best pieces, or should I choose?"
  - **"Start from scratch"** → will use interview track

Then ask: "What will you mainly use this voice guide for? (blog, social, newsletter, product copy, YouTube scripts, etc.)"

---

## Phase 1: Discovery

Goal: build a voice scorecard with confident signal across 8 dimensions AND extract the user's unique perspective (content space, pain points, proof points, solutions).

### Voice Scorecard Dimensions

Track confidence (low / medium / high) on each internally. Do NOT show the raw scorecard to the user.

1. **Formality** — casual vs polished
2. **Directness** — bold opinions vs hedging
3. **Sentence rhythm** — short/punchy vs long/complex, fragments or not
4. **Vocabulary** — plain language vs jargon, simple vs sophisticated
5. **Humor/personality** — dry wit, self-deprecating, earnest, none
6. **Energy** — enthusiastic vs measured
7. **Perspective** — first-person storyteller vs second-person teacher vs third-person observer
8. **Storytelling** — anecdotes vs abstract reasoning

### Perspective Data (track alongside scorecard)

Store these as structured data from journey extraction responses:
- `content_space`: Who they make content for and why
- `core_expertise`: What they've figured out that's worth sharing
- `before_state`: Where they were before, what they struggled with
- `audience_pain_points`: What their audience struggles with
- `transformation`: What changed, what they figured out
- `solution_approach`: How they solve problems now
- `proof_points`: Specific numbers, outcomes, timeframes
- `unique_insight`: What they know that others haven't figured out

---

### Path A: Content Ingestion (existing content track)

#### A1: Grab Content

Based on what the user provided:

**Blog URL:**
- If user chose "you choose": scrape the blog index page, identify the 5 most recent article URLs
- If user chose "I'll pick": ask them to paste 3-5 article URLs
- For each URL, run the blog grabbing script:
```bash
./.claude/skills/tone-of-voice/scripts/grab-blog.sh "[ARTICLE_URL]"
```
- If the script returns HTML rather than markdown, extract the main article content yourself using the raw HTML

**YouTube channel:** (requires `yt-dlp` installed — the script errors clearly if it's missing; blog URL or pasted text need no extra tools)
- If user chose "you choose": list top videos by views:
```bash
./.claude/skills/tone-of-voice/scripts/grab-youtube.sh list "[CHANNEL_URL]" 5
```
- If user chose "I'll pick": ask them to paste 3-5 video URLs
- For each video, grab the transcript:
```bash
./.claude/skills/tone-of-voice/scripts/grab-youtube.sh grab "[VIDEO_URL]"
```

**Pasted text:**
- Use the pasted content directly. If they paste less than 500 words total, ask if they have more.

#### A2: Analyze Content

Read through all collected content. For each scorecard dimension, look for:

- **Formality:** Contractions? Slang? Sentence fragments? Register consistency?
- **Directness:** "I think" vs "Here's the thing." Hedging language frequency?
- **Sentence rhythm:** Average sentence length. Variation patterns. Fragment usage.
- **Vocabulary:** Reading level. Jargon density. Synonym variety vs repetition.
- **Humor/personality:** Jokes, asides, self-deprecation, dry observations. How frequent?
- **Energy:** Exclamation points. Intensifiers ("really", "absolutely"). Measured qualifiers.
- **Perspective:** First person ("I found"), second person ("you'll notice"), third person ("users report").
- **Storytelling:** Personal anecdotes vs abstract claims. Setup/payoff patterns.

Score each dimension as low/medium/high confidence.

#### A3: Supplemental Interview

Even with content analysis, run 3-5 supplemental questions. Always include E1 ("Is this content representative of how you want to sound going forward?").

Additionally, ask at least J5 (How You Solve It) and J6 (Proof and Results) from the Journey Extraction category — content alone rarely reveals proof points and solutions clearly enough for calibration.

Pick remaining questions based on which scorecard dimensions have the weakest signal. One question at a time. End every question with an open invitation to keep going.

After each response, update the scorecard and perspective data.

---

### Path B: Interview (from-scratch track)

#### B1: Journey Extraction (minimum 4 questions)

Select questions from Category 1 (Journey Extraction) in the question bank. This is the primary interview track.

**If perspective data was pre-seeded in Step 0.5:** Don't ask J1–J4 cold. Confirm the pre-seeded fields in a single batch first — "From your content pillars, here's what I picked up about your space and expertise: [summary]. Did I get that right, and is there anything to add?" Update the perspective data from their response. Then go straight to J5 (How You Solve It) and J6 (Proof and Results) — pillars rarely capture proof points — and continue to B2 to fill voice-dimension gaps. This keeps the interview on voice + proof instead of re-collecting positioning.

**Rules:**
- Always start with J1 (Your Content Space)
- Follow the natural arc: J1 → J2 → J3 → J4 → J5 → J6
- One question at a time
- End every question with an open invitation: "Feel free to just keep going — give me as much as you want"
- After each response, update the voice scorecard AND store the perspective data
- Minimum 4 journey questions before moving to structured gap-filling

**If the user has no clear content space or topic area**, fall back to Category 2 (Open-Ended) questions instead.

#### B2: Structured Preference Questions (fill scorecard gaps)

Select from Category 3 in the question bank. Only ask questions for dimensions where journey extraction didn't give clear signal.

**Rules:**
- One question at a time
- Only ask what's needed — don't ask about humor if J3 already made it obvious

#### B3: Adaptive Exit Check

After the minimum floor (4 journey + any needed structured):
- Check scorecard: if 6 of 8 dimensions have medium or high confidence → proceed to Phase 1 Output
- If fewer than 6 are confident → ask more targeted questions on weak dimensions (pull from Category 2 or 3)
- Hard cap: 12 total questions. After 12, proceed regardless.

---

### Phase 1 Output — Checkpoint

**Step A: Verbal Tic Check**

If the user provided dictated responses, transcripts, or any speech-based input during discovery, review all responses for verbal patterns (see Verbal Tic Protocol in the question bank). If patterns are found, present them to the user BEFORE the voice summary:

> "Before I share my read on your voice, I noticed you use these phrases when you talk: [list patterns with examples]. Some of these might be part of your authentic voice that should show up in scripts. Others might be filler you'd rather leave out and deliver naturally on camera. Which of these should I write into the guide, and which should I leave out?"

Wait for their response. Record their decisions — these go into the Vocabulary Patterns section of the voice guide.

If no verbal patterns were detected (or input was typed, not dictated), skip this step.

**Step B: Voice Summary**

Present a plain-language summary to the user:

> "Here's what I'm picking up about your voice:"
>
> [For each dimension, a natural-language sentence. E.g., "You're direct — you state opinions without hedging, and you lean into strong positions." or "Your humor is dry and understated — it shows up as asides, not as jokes."]
>
> "Does this sound right? Anything I'm getting wrong or missing?"

**Wait for user response.** If they correct anything, update the scorecard. Then proceed to Phase 2.

---

## Phase 2: Calibration

### Pre-Built Format Templates

Use these as starting structures for calibration samples. The user reacts to both voice AND structure, and the template gets customized based on their feedback.

**YouTube Script Intro:**
```
1. What I built/did — open with a concrete thing, not a broad statement
2. Proof it works — specific numbers, results, timeframe
3. The problem — stated through own experience first, then generalized
4. What I built to fix it — brief, what it does
5. Results after fixing it — connect back to proof, more numbers
6. CTA — "In this video, I'm going to show/walk you through exactly..."
7. Transition — "So let's get into it" / "So let's get going"
```

**Blog Article Intro:**
```
1. Hook — personal anecdote, bold claim, or specific result
2. Context — why this matters, what problem exists
3. Credibility — specific results or experience
4. Promise — what the reader will learn/gain
5. Transition into first section
```

These are starting points. The user's feedback during calibration customizes them.

---

### Step 2.1: First Contrasting Pair

Pick the topic where the user showed the most energy during journey extraction — the longest response, the strongest opinions, the most enthusiasm.

Write two versions (150-250 words each) in the content format the user specified, using the pre-built format template as structure. Both versions should:
- Use the user's actual proof points and numbers from the journey extraction
- Reference their actual audience pain points
- Be on the SAME topic

**The two versions must vary on the 2-3 scorecard dimensions with the lowest confidence.** Examples:
- If formality is uncertain: Version A is polished, Version B is casual
- If humor is uncertain: Version A is dry/serious, Version B has personality/wit
- If directness is uncertain: Version A hedges, Version B makes bold claims

Present both with proactive follow-up prompts (see Proactive Calibration Follow-Ups in the question bank):

> "I wrote two versions of a [format] about [specific topic using their proof points]. Which sounds more like something you'd write? What would you change?"
>
> **Version A:**
> [150-250 words]
>
> **Version B:**
> [150-250 words]
>
> "Feel free to give me any feedback on both the voice and the structure — or just tell me how you'd actually say it."

Update the scorecard based on their reaction.

### Step 2.2: Refined Pair (Same Topic)

Based on the user's feedback from Step 2.1, write two REFINED versions of the SAME topic. These are not new samples — they are improvements on the version the user preferred.

**If the user gave raw dictation of how they'd say it, work from THEIR version — not yours.** Their words are the primary source. Polish and present their version back with two variations.

The two refined versions should:
- Start from the version the user picked (or their raw dictation)
- Apply their specific feedback
- Vary on 1-2 remaining uncertain dimensions (if any)

Present them:

> "Here are two refined versions based on your feedback. Same topic, adjusted. Which is closer now? What would you still change?"
>
> **Version A (refined):**
> [150-250 words]
>
> **Version B (refined):**
> [150-250 words]

Use 1-2 proactive follow-ups as appropriate.

### Step 2.3: Polish Loop (Same Topic)

If the user has further feedback, keep refining on the SAME topic. Produce ONE version at a time now (not pairs), applying their feedback directly.

> "Here's a revised version with your changes. How does this feel? Feel free to give me any feedback or just keep telling me how you'd say it."
>
> [150-250 words]

Repeat until the user says something like "that's it," "that's me," "nailed it," or otherwise approves.

**Mark this approved sample as Reference Example 1.**

### Step 2.4: Generalization Test (New Topic)

Now test whether the voice generalizes. Pick a DIFFERENT topic from the journey extraction — ideally one that requires a different angle (e.g., if the first was a how-to intro, make this one about a different problem or solution).

Write ONE sample using the voice established in Steps 2.1-2.3, in the same format template:

> "Let me test this voice on a different topic. Here's a [format] about [new topic]. Does this still sound like you?"
>
> [150-250 words]

If the user says it's off:
- Ask what's different and iterate (same polish loop as Step 2.3)
- After approval, update the voice profile with what was missing

If the user approves:
- **Mark this as Reference Example 2.**

### Step 2.5: Generate Voice Guide Draft

Using the fully-populated scorecard, perspective data, verbal tic decisions, and approved calibration samples, generate the voice guide following the template in `references/voice-guide-template.md`.

Sections to generate:
- **Identity** — who they are, what they do, how they show up
- **Unique perspective** — their content space, problem they solve, proof points, unique insight (from journey extraction)
- **Voice rules (Do / Don't)** — specific behavioral rules derived from ALL evidence (journey responses, calibration reactions, raw dictation)
- **Tone spectrum** — where they sit on key dimensions
- **Vocabulary patterns** — words/phrases they use and avoid, including verbal tic decisions
- **Sentence patterns** — recurring structures pulled from their actual responses
- **Format guide** — structural patterns for their specified format, derived from the pre-built template as customized during calibration
- **AI tells to avoid** — tailored to their content type and natural voice tendencies
- **Reference examples** — the approved samples from Steps 2.3 and 2.4

**Important:** Sentence patterns should use actual phrases and structures from the user's responses where possible, not generic templates.

Present the guide:

> "Here's your voice guide draft. Take a look — I want to make sure this captures everything before we validate it."
>
> [Full voice guide]

### Step 2.6: Iterate Guide

Based on user feedback:

**"Looks good" / "That's it"** → proceed to Step 2.7 (Validation)

**"The guide is close but [feedback]"** → adjust the guide based on their specific feedback. Present the updated guide. Repeat until approved.

No hard cap on iterations. The user decides when it's done.

### Step 2.7: Sub-Agent Validation

Spawn a sub-agent that receives ONLY the voice guide (no conversation history, no scorecard, no interview responses). The sub-agent writes a sample on a THIRD topic (different from both calibration topics) in the user's specified format.

Present the sub-agent's output to the user:

> "I just tested your voice guide by giving it to a fresh AI with no context from our conversation — only the guide itself. Here's what it produced:"
>
> [Sub-agent's output]
>
> "Does this sound like you? If it's off, the guide needs more specificity. What's missing or wrong?"

**If the user says it's off:**
- Identify which sections of the guide failed to convey enough information
- Add more specificity to those sections
- Run the sub-agent test again with the updated guide
- Repeat until the sub-agent's output passes

**If the user approves:**
- Proceed to Step 2.8 (Save)

**Fallback:** If sub-agent spawning is not available, write the sample yourself using ONLY the voice guide as reference. Be strict — do not use any knowledge from the conversation that isn't explicitly captured in the guide.

### Step 2.8: Save

**Setup context override:** If invoked from `/setup`, skip the save question entirely. Write to `./Reference/Voice-Guide.md` (the path the article skills read), skip the CLAUDE.md-reference suggestion below (setup already wires this), and return control to setup.

Ask where to save:

> "Where should I save your voice guide? Default: `./Reference/Voice-Guide.md`"

If a format-specific guide, suggest a format-specific filename (e.g., `./Reference/Voice-Guide-YouTube.md`).

Write the file to the specified location.

Then suggest:

> "You may want to reference this in your CLAUDE.md so other skills can find it. Something like: 'Voice and tone: see Reference/Voice-Guide-YouTube.md'"

---

## Refine Mode

Entered when the skill detects an existing voice guide and the user chooses "refine."

### Refine Step 1: Load Existing Guide

Read the existing voice guide file.

Ask: "What would you like to do?"

**Option A — "I have new content that better represents me":**
- Ask for new blog posts, YouTube videos, or pasted text
- Analyze the new content against the existing guide
- Identify where the new content diverges from the guide (e.g., "Your guide says you're formal, but these new pieces are noticeably more casual")
- Present the divergences and ask which direction they want to go
- Update the scorecard based on the new content + their direction choice
- Go to Phase 2 Step 2.1 (calibration with updated voice)

**Option B — "Here's what feels off":**
- Ask them to describe what's not working
- Run 2-4 targeted follow-up questions from the question bank on the relevant dimensions
- Update the scorecard
- Go to Phase 2 Step 2.1 (calibration with updated voice)

---

## Self-Update

When the user provides feedback during or after the skill run that reveals a reusable lesson (e.g., "the rant question doesn't work for enthusiastic people"), add it to `learnings.md` in the format:

```markdown
## [Date] — [Short description]
[What happened and what to do differently]
```

---

## Rules

- One question at a time. Never ask multiple questions in a single message.
- End every question with an open invitation to keep going ("Feel free to just keep going — give me as much as you want").
- Never show the raw scorecard to the user. Always present voice observations in natural language.
- Journey extraction responses serve double duty: voice signal AND perspective data. Pay attention to both HOW people answer and WHAT they say.
- Interview responses ARE voice samples. Pay attention to HOW people answer, not just WHAT they say.
- The first draft doesn't need to be perfect — it needs to be close enough to react to.
- Sentence patterns in the output should use the user's actual phrases where possible.
- Calibration samples must use the user's actual proof points, pain points, and solutions from the journey extraction. Never use generic topics.
- Stay on the SAME topic during calibration until the user approves. Only move to a new topic for generalization testing.
- When the user gives raw dictation of how they'd say something, that IS the voice. Work from their version, not yours.
- Use proactive follow-ups (C1-C7) during calibration to help users articulate feedback. Not everyone can pinpoint what's wrong — give them handles.
- Present verbal tic patterns to the user and ask — never silently include or exclude.
- The user reacts to both voice AND format during calibration — invite feedback on both.
- Sub-agent validation is mandatory before saving. If the guide can't stand alone, it's not specific enough.
- For YouTube transcripts, ignore verbal tics, filler words, and video-specific callouts ("click subscribe") — focus on the communication style underneath.
