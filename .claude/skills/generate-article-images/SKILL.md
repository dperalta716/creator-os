---
name: generate-article-images
description: Generate whiteboard-style diagram images for Medium articles. Called by /review-article as a background sub-agent after Phase 1, or standalone. Reads the draft, identifies 3-5 image placement spots, generates A/B pairs using fal-ai, saves to assets/.
argument-hint: article folder name or number (e.g., "001-what-is-claude-cowork" or "001")
user-invocable: true
---

# Generate Article Images

Generates whiteboard-style diagram images for a Medium article draft. Designed to run as a background sub-agent during `/review-article` (Phase 1.5), but can also be invoked standalone.

## Usage

```
/generate-article-images 001-what-is-claude-cowork
/generate-article-images 001
```

---

## Step 0: Apply Learnings

Read the `## Rules` section below (already in context). If `learnings.md` exists in this skill's directory, read it too. Apply all rules during this execution.

## Step 1: Locate the Draft

1. Resolve the article folder: `02-Articles/In-Progress/[argument]/`
2. Find the latest draft version (highest `vN-*.md` file)
3. Read the draft
4. Create `[article-folder]/assets/` if it doesn't exist

## Step 2: Identify Image Placement Spots

Read through the draft and identify **3-5 spots** where a visual diagram would reinforce the concept being discussed. Good candidates:

- **After the title / before Overview** — hero image that visually captures the article's core concept or comparison
- **After process/workflow sections** — flowchart or step-by-step diagram
- **After sections listing categories or use cases** — hub-and-spoke layout or card grid with big icons
- **After the customization/features section** — layered stack or building blocks diagram
- **Before the closing/takeaway section** — decision flowchart or comparison summary

For each spot, note:
- Where in the article it goes (after which section/paragraph)
- What concept it illustrates
- What diagram type fits best (flowchart, comparison, hub-and-spoke, card grid, decision tree)

## Step 3: Generate Images

For each placement spot, generate **2 versions (A and B)** using the fal-ai generation script.

### Technical Settings

- Script: `./.claude/skills/fal-ai/scripts/fal-generate-image.sh`
- Model: `gpt2` (GPT Image 2)
- Quality: `medium`
- Size: `1536x1024` (landscape)
- Format: `png`

### Style Rules

These are non-negotiable. Every image must follow all of these:

1. **Whiteboard hand-drawn style** — casual handwritten font throughout, not clean/digital typography
2. **Pastel color palette** — light blue, soft purple/lavender, mint green, pale yellow, soft orange/coral. White background.
3. **No humans ever** — no human figures, person icons, faces, avatars, or caricatures anywhere. Use abstract labels ("You ask", "You type"), speech bubble icons, or simple non-human icons instead.
4. **Every shape must have a filled background** — rounded rectangles, ovals, speech bubbles all have a lighter pastel shade of their border color as interior fill. No white/empty shape interiors. For example: a blue-bordered box has a light blue fill, a green-bordered box has a light mint fill.
5. **Big icons for non-flowchart images** — when the image is a category overview or feature showcase (not a specific process flow), use large illustrative icons (puzzle piece, lightbulb, calendar, folder, chart) inside card-style layouts with short bold labels.
6. **Flowcharts use numbered steps** — vertical or horizontal flows with numbered steps in rounded rectangles, connected by directional arrows. Keep the hand-drawn feel.
7. **Comparison diagrams use a dashed vertical divider** — left side vs right side, each with its own color scheme and clear labels.

### Prompt Structure

Each prompt should follow this pattern:
```
Whiteboard hand-drawn style diagram on clean white background. Pastel colors: [specific colors for this diagram]. Casual handwritten font throughout. Title: '[Title]'. [Detailed layout description]. Every shape (rounded rectangles, speech bubbles, ovals) has a filled interior that is a lighter pastel shade of its border color — no white/empty interiors. IMPORTANT: No human figures, no person icons, no faces, no caricatures anywhere. Use only abstract shapes, speech bubbles, icons, and labeled boxes. Clean conceptual diagram for a Medium article.
```

### Variation Strategy for A/B Pairs

- **Version A**: Vertical layout (or left-to-right for comparisons)
- **Version B**: Different layout approach — horizontal timeline, card grid, or alternative visual metaphor for the same concept

### Saving Images

Save each generated image to `[article-folder]/assets/` with naming convention:
```
01-[short-description]-a.png
01-[short-description]-b.png
02-[short-description]-a.png
02-[short-description]-b.png
```

After generating, **always read each image** to verify:
- Style matches (whiteboard/hand-drawn, not digital/clean)
- No humans present
- Shapes have filled backgrounds (not white/empty interiors)
- Text is legible
- Concept is accurately represented

If an image fails verification, use the edit script to fix it:
```
./.claude/skills/fal-ai/scripts/fal-edit-image.sh "fix description" "path/to/image.png" gpt2 medium
```

## Step 4: Create IMAGE-PICKS.md

Save a manifest file at `[article-folder]/assets/IMAGE-PICKS.md`:

```markdown
# Image Picks for [Article Title]

## Slot 1: [Description]
**Placement:** After [section name], before [section name]
**Concept:** [What the image illustrates]
- Version A: `01-description-a.png`
- Version B: `01-description-b.png`
**Your pick:** [ ]

## Slot 2: [Description]
...
```

## Step 5: Report Back

If running as a sub-agent for `/review-article`, the parent process will present IMAGE-PICKS.md to the user for selection during Phase 4.4.

If running standalone, present each A/B pair to the user directly:
1. Show both versions (Read each image file)
2. Ask the user to pick A or B for each slot
3. After picks are made, embed the selected images into the latest draft version

---

## Rules

*Updated when the user flags issues. Read before every run.*

- Shapes must ALWAYS have pastel-filled interiors matching their border color — never white/empty. This was flagged as a critical miss on the first article's hero image.
- The "comparison" diagram type (e.g., Chat vs Cowork) should show a clear contrast: left side feels manual/repetitive, right side feels autonomous/productive.
- For the "What You Can Do" use-case type images, the hub-and-spoke with big icons works well. The card-grid layout (like "From Tool to System" with puzzle piece, lightbulb, calendar) also works well.
- When editing an existing image to fix style issues, be very specific about what to change and what to keep. The edit script preserves layout better when given precise instructions.

---

## Self-Update

When the user provides feedback about image quality, style mismatches, or preferences:

1. **Fix the current image** — regenerate or edit based on the feedback
2. **Update the Style Rules** section above if the feedback reveals a new constraint
3. **Add a Rule** to the `## Rules` section if Claude might repeat the mistake
4. **Log to `learnings.md`** only if the failure story adds context the fix alone doesn't convey
