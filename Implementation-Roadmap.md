# Implementation Roadmap -- Future Plans

Status: **Captured** -- nothing below is implemented yet. This is the backlog.

---

## 1. Publishing Pipeline: GitHub Pages -> Medium -> Website

- **Phase 1 (planned):** GitHub Pages site that uses Medium's import function to pull articles in
- **Phase 2 (eventual):** Full website where all content is hosted natively

### Critical Limitation: Medium Import is One-Shot
Medium's import function (`/p/import`) creates a **new draft** each time. There is no way to re-import a URL and update an existing published article. Medium's API (deprecated but functional) only supports creating posts -- no PUT/PATCH for updates. This means:

- **GitHub Pages is the canonical, living source.** Internal link updates, corrections, etc. happen there and are always current.
- **Medium copies are frozen at publish time.** If you update old articles with new internal links on GitHub Pages, those changes do NOT propagate to Medium automatically.
- **Updating Medium requires manual editing** in their web editor. The internal linking pass should flag what changed so you can manually update Medium if it's worth it.
- **Implication for internal linking:** Backward link updates (adding links to old articles) will work perfectly on GitHub Pages via git commits. For Medium, the pipeline should output a summary of what changed so you can decide whether to manually update the Medium versions.

## 2. Post-Drafting Review Pipeline

### Recommended Review Steps

| Step | What it does |
|------|-------------|
| 1 | Quality Review (voice/tone, readability, SEO) |
| 2 | Sources Verification (triple-fallback: API -> WebFetch -> Firecrawl) |
| 3 | Claims Verification (verify claims against official docs and current behavior) |
| 4 | Internal Linking Pass (forward + backward links across published articles) |

### Internal Linking Pass
- **Forward linking (new -> old):** Scan all previously published articles. Insert internal links in the new draft where relevant topics overlap. Only link when genuinely useful.
- **Backward linking (old <- new):** After the pipeline finishes, analyze which existing published articles should link TO the new article. Output a recommendation and update if approved.
- Backward link updates work perfectly on GitHub Pages via git commits. For Medium, output a change summary to decide whether to update manually.

### Integration with Existing Pipeline
The `/generate-article` skill produces v1 drafts (3-phase: topic context -> competitor analysis -> draft). The review pipeline picks up where that leaves off.

## 3. Tone of Voice

- Define and document your voice/tone before the review pipeline can enforce it
- Voice Guide stub exists at `Reference/Voice-Guide.md` -- populate it with your real voice characteristics

---

## Implementation Order (suggested)

1. Tone of Voice -- unblocks everything else
2. Claims Verification -- highest-value review step
3. Full Review Pipeline -- adapt remaining steps
4. GitHub Pages / Website -- publishing infrastructure
