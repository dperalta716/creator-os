---
name: firecrawl-scraper
description: This skill should be used for web scraping when WebFetch fails or when dealing with JavaScript-heavy sites, anti-bot protection, or sites requiring specific rendering. Use this skill for extracting web content, discovering site structure, or crawling multiple pages using Firecrawl API via bash scripts.
---

# Firecrawl Scraper

## Overview

This skill provides advanced web scraping capabilities using Firecrawl API via bash scripts, designed as a fallback when standard WebFetch fails. Firecrawl handles JavaScript rendering, bypasses anti-bot protection, and offers specialized operations for different scraping scenarios through token-efficient command-line scripts.

## When to Use Firecrawl

### Primary Use Case: WebFetch Fallback
Always try WebFetch first. Use Firecrawl when:
- WebFetch times out or fails to retrieve content
- Site uses heavy JavaScript rendering (SPAs, React, Vue, Angular)
- Anti-bot protection blocks standard requests
- Mobile-only content needs to be accessed
- Structured data extraction is needed

### Trigger Scenarios
- **User request:** "Scrape this website" or "Get content from [URL]"
- **WebFetch failure:** Automatic fallback after timeout/SSL/rendering errors
- **Site mapping:** "What pages exist on this website?"
- **Multi-page extraction:** "Get content from all blog posts on [site]"
- **Web search + scrape:** "Search for X and extract content from results"
- **Structured extraction:** "Extract product prices and names from [URL]"

## Operation Decision Tree

Choose the right Firecrawl operation based on your goal:

```
Need web content?
├─ Single page? → Use firecrawl-scrape.sh
├─ Discover URLs? → Use firecrawl-map.sh
└─ Multiple pages? → Use firecrawl-crawl.sh
```

## Core Scraping Operations

### 1. Single Page Scraping

**When to use:** Extract content from a specific URL you already know.

**Best for:**
- Individual articles, blog posts, documentation pages
- Fallback when WebFetch fails
- JavaScript-heavy single pages
- Sites with anti-bot protection

**Script location:** `.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh`

**How to use:**
```bash

./.claude/skills/firecrawl-scraper/scripts/firecrawl-scrape.sh "URL" [format] [onlyMainContent]
```

**Parameters:**
- `URL` (required): Target webpage to scrape
- `format` (optional): Output format - markdown, html, rawHtml (default: markdown)
- `onlyMainContent` (optional): Filter to main content - true or false (default: true)

**Examples:**
```bash
# Basic scrape (markdown, main content only)
./firecrawl-scrape.sh "https://example.com/article"

# Get full page HTML including nav/footer
./firecrawl-scrape.sh "https://example.com" "html" "false"

# Scrape main content as markdown (explicit)
./firecrawl-scrape.sh "https://docs.example.com/guide" "markdown" "true"
```

**Example request:** "Get the content from https://example.com/article using Firecrawl"

**Output:** Markdown or HTML formatted content of the page

### 2. Site Mapping

**When to use:** Discover all URLs on a website before scraping.

**Best for:**
- Exploring unknown site structure
- Finding specific sections (e.g., all blog posts, product pages)
- Building sitemaps
- Identifying pages to crawl

**Script location:** `.claude/skills/firecrawl-scraper/scripts/firecrawl-map.sh`

**How to use:**
```bash

./.claude/skills/firecrawl-scraper/scripts/firecrawl-map.sh "URL" [search_term] [limit]
```

**Parameters:**
- `URL` (required): Website to map
- `search_term` (optional): Filter URLs containing this keyword
- `limit` (optional): Maximum URLs to return (default: 5000)

**Examples:**
```bash
# Discover all pages on site
./firecrawl-map.sh "https://example.com"

# Find blog posts containing "probiotic"
./firecrawl-map.sh "https://seed.com" "probiotic" 100

# Map specific section with limit
./firecrawl-map.sh "https://example.com/blog" "" 50
```

**Example request:** "Map all URLs on seed.com to find probiotic articles"

**Output:** List of discovered URLs on the site

**Workflow:** Map → Review URLs → Scrape or Crawl specific ones

### 3. Multi-Page Crawling

**When to use:** Extract content from multiple related pages automatically.

**Best for:**
- Scraping all blog posts from a blog
- Extracting product data from e-commerce sites
- Building content databases
- Comprehensive site analysis

**Script locations:**
- Start crawl: `.claude/skills/firecrawl-scraper/scripts/firecrawl-crawl.sh`
- Check status: `.claude/skills/firecrawl-scraper/scripts/firecrawl-crawl-status.sh`

**How to use:**
```bash
# Start crawl job (returns job ID)

./.claude/skills/firecrawl-scraper/scripts/firecrawl-crawl.sh "URL" [limit] [maxDepth]

# Check crawl status (use job ID from above)
./.claude/skills/firecrawl-scraper/scripts/firecrawl-crawl-status.sh "job_id"
```

**Parameters:**
- `URL` (required): Starting URL to crawl
- `limit` (optional): Max pages to crawl (default: 10, max: 10000)
- `maxDepth` (optional): Discovery depth, 0 = sitemap only (default: 0)

**Examples:**
```bash
# Conservative crawl (10 pages, sitemap only)
./firecrawl-crawl.sh "https://seed.com/cultured/" 10 0

# Check status of job
./firecrawl-crawl-status.sh "abc123-job-id"

# Larger crawl after testing
./firecrawl-crawl.sh "https://example.com/blog" 50 0
```

**Example request:** "Crawl the first 10 blog posts from seed.com/cultured/"

**Critical safety rules:**
- **ALWAYS start with limit=10** to avoid overwhelming crawls
- **Use maxDepth=0** (sitemap only) unless you have a specific reason
- **Wait 30-60 seconds** before checking status
- **Review results** before increasing limits

**Warning:** Crawl responses can be HUGE. Start small, increase limit gradually.

**Output:**
1. Crawl script returns job ID
2. Status script returns progress and results when complete

**Workflow:**
1. Start crawl with limit=10, maxDepth=0
2. Wait 30-60 seconds
3. Check status with job ID
4. Review results, adjust parameters if needed
5. Re-crawl with refined settings


## Best Practices

### Start Conservative with Crawls
Always begin with small limits:
```
limit: 10          // Start here
maxDiscoveryDepth: 0  // Sitemap only
```

Increase gradually after reviewing results.

### Filter to Main Content
Use `onlyMainContent: true` to:
- Reduce token usage
- Remove navigation/footer clutter
- Focus on article/product content

Set `false` only when you need full page structure.

### Handle JavaScript Sites
For heavy JS rendering:
```
waitFor: 3000  // 3 seconds for JS to load
mobile: false  // or true for mobile-only content
```

### Avoid Token Explosions
**Dangerous combinations:**
- `limit: 10000` + `maxDiscoveryDepth: 5` = Could crawl entire internet
- Multiple crawls without checking status first
- Crawling without `deduplicateSimilarURLs: true`

**Safe approach:**
- Map first to understand site structure
- Crawl with specific URL patterns
- Use low limits initially

## Integration with Vault Workflows

### WebFetch Fallback Pattern
```
1. Try WebFetch first (faster, fewer tokens)
2. If fails → Automatically use firecrawl_scrape
3. Mention: "WebFetch failed, using Firecrawl fallback"
```

### Save Scraped Content
Save to vault for analysis:
```
# Create note with scraped content
Title: [[Article Title - Scraped YYYY-MM-DD]]
Tags: #source/scraped #topic/relevant
Content: [Firecrawl markdown output]
```

### Competitive Analysis Workflow
```
1. Use SEARCH to find competitors
2. Extract structured data with EXTRACT
3. Analyze and compare in Obsidian
4. Save findings in /research/ folder
```

## Common Issues & Solutions

### "Response exceeds token limits"
**Solution:** Use `onlyMainContent: true` and lower `limit`

### "Crawl taking too long"
**Solution:** Reduce `maxDiscoveryDepth` and `limit`, or use MAP → selective SCRAPE instead

### "Getting navigation/footer content"
**Solution:** Set `onlyMainContent: true`

### "JavaScript not rendering"
**Solution:** Increase `waitFor` to 3000-5000ms

### "Need fresh data but scrape is slow"
**Solution:** Lower `maxAge` or set to 0 for real-time scraping

## Quick Reference

### Operation Comparison

| Operation | Use Case | Token Cost | Speed |
|-----------|----------|------------|-------|
| **SCRAPE** | Single page | Low | Fast |
| **MAP** | Discover URLs | Low | Fast |
| **CRAWL** | Multiple pages | HIGH | Slow |

### When to Use Which

**Need content from one page?** → firecrawl-scrape.sh
**Don't know what pages exist?** → firecrawl-map.sh
**Need content from many pages?** → firecrawl-crawl.sh (or MAP + batch SCRAPE)

### Script Reference

All scripts located in: `.claude/skills/firecrawl-scraper/scripts/`

- `firecrawl-scrape.sh` - Single page content extraction
- `firecrawl-map.sh` - Site URL discovery
- `firecrawl-crawl.sh` - Start multi-page crawl job
- `firecrawl-crawl-status.sh` - Check crawl job progress

### Script Paths

From vault root:
```bash

./.claude/skills/firecrawl-scraper/scripts/[script-name].sh
```
