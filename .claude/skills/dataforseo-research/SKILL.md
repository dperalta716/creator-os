---
name: dataforseo-research
description: This skill should be used when conducting keyword research, SERP analysis, competitive research, or content gap analysis for SEO. Use this skill when analyzing search intent, identifying ranking opportunities, building content briefs, or validating keyword clustering strategies.
---

# DataForSEO Research

## Overview

This skill provides token-efficient access to Google SERP and keyword data via DataForSEO API for SEO keyword research and competitive analysis. Multiple scripts are available for different research needs.

## Available Scripts

| Script | Purpose | Returns Volume? |
|--------|---------|-----------------|
| `dataforseo-filtered.sh` | SERP analysis (organic results, PAA, related searches) | No |
| `dataforseo-suggestions.sh` | Keyword suggestions containing seed keyword | Yes |
| `dataforseo-search-volume.sh` | Search volume for a list of keywords | Yes |
| `dataforseo-related.sh` | Semantically related keywords | Yes |
| `dataforseo-autocomplete.sh` | Raw Google Autocomplete suggestions (edge cases) | No |

All scripts use the `.ai` endpoint for token-optimized responses.

## Quick Start by Use Case

### SERP Analysis (What's ranking?)
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-filtered.sh "keyword" "en" "United States"
```

### Competitor "vs" Keywords (e.g., "Ritual vs")
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "Ritual vs" "en" "United States" 15
```

### Keyword Expansion with Volume
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "sleep supplement" "en" "United States" 20
```

### Related Keywords with Volume
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-related.sh "multivitamin" "en" "United States" 20 2
```

### Search Volume for Specific Keywords
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-search-volume.sh "keyword1,keyword2,keyword3" "en" "United States"
```

---

## Script Details

### 1. dataforseo-filtered.sh (SERP Analysis)

**Purpose:** Get top 10 organic results with PAA, related searches, and other SERP features.

**Usage:**
```bash
./dataforseo-filtered.sh "keyword" "language_code" "location"
```

**Example:**
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-filtered.sh "best probiotics for gut health" "en" "United States"
```

**Returns:**
- Top 10 organic results with title, URL, domain, description
- People Also Ask questions
- Related searches
- Featured snippets, forums, AI overviews (when present)

**Best for:** Understanding search intent, content brief creation, competitor analysis

---

### 2. dataforseo-suggestions.sh (Keyword Suggestions)

**Purpose:** Get keywords that CONTAIN your seed keyword, with volume data.

**Usage:**
```bash
./dataforseo-suggestions.sh "keyword" "language_code" "location" [limit]
```

**Example:**
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "sleep supplement" "en" "United States" 20
```

**Returns:**
- Keywords containing your seed keyword
- Search volume, CPC, competition for each
- Sorted by volume (highest first)

**Best for:** Keyword expansion, finding long-tail variations, competitor "vs" research

---

### 3. dataforseo-search-volume.sh (Bulk Volume Lookup)

**Purpose:** Get search volume for a specific list of keywords you already have.

**Usage:**
```bash
./dataforseo-search-volume.sh "keyword1,keyword2,keyword3" "language_code" "location"
```

**Example:**
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-search-volume.sh "ritual vs athletic greens,ritual vs seed,ritual vs care of" "en" "United States"
```

**Returns:**
- Search volume for each keyword
- CPC and competition data

**Best for:** Enriching keyword lists from other sources, validating keyword ideas

**Note:** Can accept up to 700 keywords in a single request

---

### 4. dataforseo-related.sh (Related Keywords)

**Purpose:** Get semantically related keywords from Google's "searches related to" feature.

**Usage:**
```bash
./dataforseo-related.sh "keyword" "language_code" "location" [limit] [depth]
```

**Parameters:**
- `limit` - Max results (default: 20, max: 1000)
- `depth` - Search depth 0-4 (default: 1)
  - 0 = direct related searches only
  - 1 = one level deep
  - 2 = two levels deep
  - 3-4 = very broad exploration

**Example:**
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-related.sh "energy supplements" "en" "United States" 20 2
```

**Returns:**
- Semantically related keywords
- Search volume, CPC, competition for each
- Sorted by volume (highest first)

**Best for:** Topic expansion, finding related content opportunities, building topic clusters

---

### 5. dataforseo-autocomplete.sh (Raw Autocomplete)

**Purpose:** Get raw Google Autocomplete suggestions (no volume). Edge case use only.

**Usage:**
```bash
./dataforseo-autocomplete.sh "keyword" "language_code" "location" [limit]
```

**Example:**
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-autocomplete.sh "how to" "en" "United States" 10
```

**Returns:**
- Raw autocomplete suggestions (no volume data)

**Best for:** Exploring what users type when you don't need volume data

**Note:** For most use cases, use `dataforseo-suggestions.sh` instead (includes volume)

---

## Common Workflows

### Competitor Comparison Keyword Research

Find all "[Competitor] vs" keywords with volume:

```bash
# For multiple competitors
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "Athletic Greens vs" "en" "United States" 15
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "Ritual vs" "en" "United States" 15
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "Olly vs" "en" "United States" 15
```

### Keyword Clustering Analysis

Compare SERPs to determine if keywords should target same or different pages:

```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-filtered.sh "best probiotics" "en" "United States"
./.claude/skills/dataforseo-research/scripts/dataforseo-filtered.sh "top probiotic supplements" "en" "United States"
```

**Decision criteria:**
- 7+ same URLs = same page
- 4-6 same URLs = consider separate with linking
- <3 same URLs = definitely separate pages

### Content Brief Creation

1. Get SERP data for intent analysis:
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-filtered.sh "signs probiotics are working" "en" "United States"
```

2. Get related keywords for topic coverage:
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-related.sh "signs probiotics are working" "en" "United States" 20 1
```

3. Get keyword suggestions for long-tail opportunities:
```bash
./.claude/skills/dataforseo-research/scripts/dataforseo-suggestions.sh "probiotics working" "en" "United States" 20
```

---

## Parameter Reference

### Language Codes
- `en` - English
- `es` - Spanish
- `fr` - French
- `de` - German

### Location Formats
- **National:** `"United States"`
- **State/Region:** `"California,United States"`
- **City:** `"San Francisco,California,United States"`

---

## Technical Details

**Script location:** `./.claude/skills/dataforseo-research/scripts/`

**API endpoints used (all use .ai token optimization):**
- SERP: `https://api.dataforseo.com/v3/serp/google/organic/live/advanced.ai`
- Keyword Suggestions: `https://api.dataforseo.com/v3/dataforseo_labs/google/keyword_suggestions/live.ai`
- Historical Search Volume: `https://api.dataforseo.com/v3/dataforseo_labs/google/historical_search_volume/live.ai`
- Related Keywords: `https://api.dataforseo.com/v3/dataforseo_labs/google/related_keywords/live.ai`
- Autocomplete: `https://api.dataforseo.com/v3/serp/google/autocomplete/live/advanced.ai`

**Rate limits:** Up to 2000 API calls per minute

**API Documentation:** [DataForSEO API v3 Docs](https://docs.dataforseo.com/v3/)
