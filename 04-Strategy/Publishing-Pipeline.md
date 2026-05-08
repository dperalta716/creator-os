# Publishing Pipeline — Future Automation

## Current Workflow (Manual)
1. Generate article draft via `/generate-article`
2. Review and edit in Obsidian
3. Copy/paste into Medium editor
4. Add Medium tags (up to 5)
5. Publish

## Planned: GitHub Pages Import Pipeline

**Goal:** Eliminate copy-paste formatting issues by using Medium's "Import a story" feature.

### Phase 1: Non-Indexed Staging (Build Now, No SEO Benefit)
1. Generate article draft as markdown
2. Convert markdown → clean HTML (a skill can do this)
3. Push HTML to a GitHub Pages site with `<meta name="robots" content="noindex">`
4. Use Medium's "Import a story" with the GitHub Pages URL
5. Medium pulls in the article with clean formatting
6. Publish on Medium

**Benefit:** Clean formatting, no manual copy-paste, automatable via Claude Code skill.
**Tradeoff:** No SEO benefit — the canonical URL points to a non-indexed page.

### Phase 2: Indexed Canonical Blog (Add Later for SEO)
1. Replace non-indexed GitHub Pages with an indexed blog (Ghost, Hashnode, or custom domain on GitHub Pages)
2. Publish on the blog first → this becomes the canonical URL
3. Import into Medium → Medium auto-adds `rel="canonical"` pointing to your blog
4. Google credits your domain as the original source
5. You get Medium's distribution AND build SEO equity on a domain you own

**Benefit:** Own your content, build domain authority, protect against Medium policy changes.
**Tradeoff:** Adds hosting cost ($9-25/mo for Ghost) and slight workflow complexity.

### Phase 3: Full Automation (Aspirational)
- Claude Code skill: `generate-article` → `publish-article`
- `publish-article` converts draft to HTML, pushes to GitHub Pages, returns import URL
- The user reviews on Medium, hits publish
- Could add Gumroad link injection, email signup CTAs, etc. during HTML conversion

## Decision: When to Move to Phase 2
- After 10-15 articles are published and performing on Medium
- When organic traffic justifies owning the SEO
- When a Gumroad product is live and traffic ownership matters for revenue

## Notes
- Medium deprecated their publishing API in 2023 — no direct API publishing
- Medium's import tool is the only automated path
- Hashnode has built-in canonical URL + Medium cross-post feature (free option)
- Ghost is the premium option ($9/mo self-hosted, $25/mo managed)
