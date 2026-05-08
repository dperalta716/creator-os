# System Learnings

Captures what you learn about how the content system works as you use it. Use these to decide when skills need updating.

> These are examples and methodology notes from the system creator. Add your own learnings as you use the system.

---

## System Documentation: Topic Discovery Workflow

### The recommended workflow

**Phase 1: Surface pain points** (Reddit + Twitter in parallel)
- Output: pain points grouped by pillar, NOT article titles
- CHECK-IN: Pick which pain points resonate with your experience

**Phase 2: Keyword research** (DataForSEO suggestions)
- Run `dataforseo-suggestions.sh` on each selected pain point
- Look at volume, competition, and keyword variations
- CHECK-IN: Review keyword data, pick clusters to pursue

**Phase 3: SERP overlap analysis** (keyword clustering)
- Run `dataforseo-filtered.sh` on each keyword variation
- Compare organic results across related keywords
- Decision: 7+ same URLs = same article, 4-6 = consider merging, <3 = separate articles
- CHECK-IN: Review clustering, decide article boundaries

**Phase 4: Competitive analysis** (optional)
- Check who's ranking on Medium, scrape competitor articles
- Assess: follower count, content quality, paywall, beatable?
- CHECK-IN: Finalize topic queue

**Phase 5: Save & commit**
- Intel report, topic queue, learnings update, git commit

### SERP overlap decision criteria
- **7+ same URLs** = same article (Google sees same intent)
- **4-6 same URLs** = consider combining, secondary keyword as H2
- **<3 same URLs** = separate articles (different search intent)

### Key insight
Don't start with keywords -- start with pain points. Don't start with article titles -- start with what people are struggling with. The keywords and article boundaries emerge from the data, not from guessing.

---

## Your Learnings

*Add entries here as you run the system. Document what worked, what didn't, and what skill changes you made.*
