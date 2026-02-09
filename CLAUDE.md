## AMD Machines Website - AI Agent Context

## Quick Reference

| Item | Value |
|------|-------|
| **Company** | AMD Machines (Advanced Manufacturing Development LLC) |
| **Domain** | amdmachines.com |
| **Repository** | github.com/erdmannjuan/amd-site |
| **Hosting** | Cloudflare Pages (amd-site.pages.dev) |
| **Tech Stack** | Python + Jinja2 static site generator |
| **Local Path** | `/Users/juan_erdmann/my-site-generator` |
| **Core Expertise** | Assembly Systems (featured prominently on homepage) |
| **Business** | Custom automation & robotic systems, 30+ years, 2,500+ machines delivered |

---

## SEO Protection (CRITICAL — Read Before Making ANY Changes)

**This site is LIVE and actively ranking in search engines.** Careless changes can destroy rankings that take months to recover. Follow every rule below.

### Domain & URL Rules

1. **Canonical domain is `amdmachines.com` (non-www).** All URLs must use `https://amdmachines.com/...` — never `www.amdmachines.com`. If you reference the site in sitemaps, canonical tags, internal links, or structured data, always use the non-www version.

2. **URL path structure is `/solutions/*` for solution pages.** The old path `/automated-solutions/*` was migrated with 301 redirects. NEVER create new pages under `/automated-solutions/`. All new solution pages go under `/solutions/`.

3. **Never change an existing URL slug.** If a page exists at `/solutions/robotic-cells/`, do not rename it to `/solutions/robotic-cell/` or `/robotic-cells/` or anything else. Changing a URL that Google has indexed causes ranking loss. If you absolutely must change a URL, you MUST add a 301 redirect from the old URL to the new URL in `_redirects`.

4. **Never create duplicate paths.** Before creating any new page, check that no existing page targets the same topic. For example, do not create `/solutions/automated-welding/` if `/solutions/welding/` already exists. One page per topic.

5. **Add 301 redirects in `_redirects` for any URL change.** Format:
   ```
   /old-path  /new-path  301
   ```

### Keyword Targeting Rules (Prevent Cannibalization)

6. **One primary keyword cluster per page.** Every page should target ONE main keyword cluster. Do not create two pages that target the same keyword. This causes "keyword cannibalization" — Google splits authority between pages and both rank worse.

7. **Current keyword-to-page assignments (DO NOT create competing pages):**

   | Primary Keyword Cluster | Assigned Page | Do NOT Target From Other Pages |
   |------------------------|---------------|-------------------------------|
   | robotic cell, robot cell, robotic cells | `/solutions/robotic-cells/` | No other page should have "robotic cell" in H1 or title |
   | welding automation, automated welding | `/solutions/welding/` | No other page should target "welding automation" as primary |
   | automated assembly, assembly automation, assembly line | `/solutions/assembly/` | No other page should target "assembly automation" as primary |
   | leak detection, test systems, leak testing | `/solutions/test-systems/` | No other page should target "leak testing" as primary |
   | machine tending, CNC tending | `/solutions/machine-tending/` | No other page should target "machine tending" as primary |
   | custom automation, automated equipment | `/solutions/custom-automation/` | No other page should target "custom automation" as primary |
   | marking, traceability | `/solutions/marking-traceability/` | No other page should target "marking systems" as primary |
   | industrial automation equipment | `/industries/` | No other page should target "industrial automation equipment" as primary |
   | automated assembly machines (guide content) | `/blog/automated-assembly-machines-a-selection-guide/` | Blog targets guide/educational intent |

8. **Blog posts SUPPORT solution pages, they don't compete with them.** Blog posts should target educational/informational keywords ("what is...", "how to...", "guide to..."). Solution pages target commercial keywords ("robotic cells", "welding automation"). Every blog post about a solution topic MUST link to the corresponding solution page with descriptive anchor text.

9. **When creating a new page, verify it won't cannibalize existing pages:**
   - Search the site content for the target keyword
   - Check if an existing page already ranks for it in Google Search Console
   - If an existing page covers the topic, EXPAND that page instead of creating a new one
   - If the new page serves a genuinely different intent (e.g., educational blog vs. commercial solution), proceed but differentiate the title, H1, and primary keywords

### Title Tag & Meta Description Rules

10. **Title tags must be under 60 characters.** Format: `Primary Keyword | Secondary | AMD Machines`

11. **Meta descriptions must be under 155 characters.** Include the primary keyword, a benefit/differentiator, and a call to action.

12. **Every page MUST have a unique title tag and meta description.** No two pages should share the same title or meta. Duplicates confuse Google.

13. **Do not change existing title tags or meta descriptions without checking GSC data first.** A title that looks "bad" might actually be performing well. Always verify current ranking and CTR before changing.

### Internal Linking Rules

14. **Every new page must be linked FROM at least 3 existing pages.** Orphan pages (no internal links pointing to them) will not get crawled or ranked. When creating a new page:
    - Add a link from the parent hub page (e.g., `/solutions/` for solution pages)
    - Add a link from at least one related solution page
    - Add a link from at least one related blog post or industry page

15. **Every new page must link TO at least 2 existing pages.** This distributes authority and helps users navigate. Include contextual links within the body content, not just navigation.

16. **Use descriptive anchor text for internal links.** Write "learn more about our robotic welding systems" — not "click here" or "learn more." The anchor text tells Google what the linked page is about.

17. **Never link to www.amdmachines.com in internal links.** All internal links must use relative paths (`/solutions/robotic-cells/`) or the non-www domain (`https://amdmachines.com/solutions/robotic-cells/`).

### Structured Data Rules

18. **All solution pages must include JSON-LD structured data** (already implemented — do not remove or break it). Types used: LocalBusiness, Service, BreadcrumbList.

19. **All blog posts must include Article structured data.**

20. **Do not duplicate structured data blocks.** One JSON-LD block per schema type per page.

### Heading Hierarchy Rules

21. **Every page has exactly ONE H1 tag.** The H1 must contain the primary keyword for that page. No page should have zero H1s or multiple H1s.

22. **H2 tags define major sections and should include secondary keywords.** Use H2 for section headings, H3 for subsections. Do not skip levels (e.g., H1 → H3 with no H2).

23. **Do not change an H1 without checking what keywords that page ranks for.** The H1 is the strongest on-page ranking signal. Changing it can immediately impact rankings.

### Image Rules

24. **All images must have descriptive alt text** that includes relevant keywords naturally.

25. **All `<img>` tags must include explicit `width` and `height` attributes** to prevent layout shift (CLS).

26. **Hero/above-fold images must be preloaded** with `<link rel="preload" as="image" fetchpriority="high">` in the `<head>`.

### Redirect Reference

Current active redirects (in `_redirects`):
- `/automated-solutions/*` paths → `/solutions/*` equivalents (301)
- `www.amdmachines.com/*` → `amdmachines.com/*` (handled by Cloudflare)

When adding new redirects, always use 301 (permanent), never 302 (temporary).

### Sitemap & Crawling

27. **Sitemap must only contain non-www canonical URLs.** The sitemap is auto-generated by `build.py`. Verify after builds that no `www.` URLs appear in `output/sitemap.xml`.

28. **Do not block any non-www page in robots.txt** unless it is intentionally non-indexable (e.g., thank-you pages, test pages).

---

## Architecture

### Tech Stack
- **Static Site Generator**: Custom Python (`build.py`)
- **Templating**: Jinja2
- **Styling**: Plain CSS with custom properties (no framework)
- **Content**: Markdown files with YAML frontmatter
- **Hosting**: Cloudflare Pages
- **CDN/DNS**: Cloudflare

### Directory Structure
```
my-site-generator/
├── build.py              # Main build script - generates all HTML
├── config.yaml           # Site config: navigation, footer, social, SEO defaults
├── requirements.txt      # Python dependencies (jinja2, markdown, pyyaml, pillow)
├── CNAME                 # Domain configuration (amdmachines.com)
├── _headers              # Cloudflare headers config
├── _redirects            # Cloudflare redirects config
│
├── content/              # Markdown content files
│   ├── index.md          # Homepage
│   ├── about.md
│   ├── contact.md
│   ├── blog/             # Blog posts (356+ posts)
│   │   └── index.md
│   ├── case-studies/     # Case study pages (10 studies)
│   │   └── index.md
│   ├── solutions/        # Solution pages (19 solutions)
│   ├── services/         # Service pages (8 services)
│   ├── industries/       # Industry pages (12 industries)
│   └── tooling/          # Tooling pages
│
├── templates/            # Jinja2 HTML templates
│   ├── base.html         # Base layout with header/footer (all pages inherit)
│   ├── homepage.html     # Homepage template (use as style reference)
│   ├── page.html         # Generic page template
│   ├── about.html        # About page template
│   ├── blog.html         # Blog listing
│   ├── blog-post.html    # Individual blog post
│   ├── case-study.html   # Individual case study
│   ├── case-studies.html # Case studies listing
│   ├── solution.html     # Solution page template
│   └── ...
│
├── static/               # Static assets (copied to output)
│   ├── css/
│   │   └── style.css     # Main stylesheet
│   ├── images/
│   │   ├── customers/    # Original customer logos (source)
│   │   ├── logos-white/  # Processed white logos (84px height)
│   │   ├── logos-color/  # Processed color logos (32px height)
│   │   ├── STORY/        # Company timeline photos (2012, 2015, 2018, 2023)
│   │   └── amd/          # AMD facility and equipment photos
│   └── js/
│
├── output/               # Generated site (419 pages, deployed via git push)
│
├── scripts/
│   └── seo-crawler.py    # SEO audit script
│
│ # Utility Scripts (root level)
├── claude_helper.py      # Content management CLI tool
├── site_manager.py       # Site management utilities
├── generate_blogs.py     # Blog post generation
├── process_logos.py      # Logo processing
├── process_logos_hires.py # High-res logo processing (84px white)
├── process_color_logos.py # Color logo processing (32px)
├── optimize_images.py    # Image optimization
│
└── CLAUDE.md             # This file - AI agent context
```

---

## Build & Deploy

### Build the Site
```bash
python3 build.py
```

This process:
1. Reads `config.yaml` for site settings
2. Processes all Markdown files in `content/`
3. Renders templates with Jinja2
4. Copies static files to `output/static/`
5. Generates sitemap.xml and search index
6. Outputs everything to `output/`

### Deploy to Production

**Deployment is automatic via GitHub → Cloudflare Pages**

```bash
# 1. Make changes to templates, CSS, or content
# 2. Build the site
python3 build.py

# 3. Commit and push (triggers auto-deploy)
git add .
git commit -m "Description of changes"
git push origin main

# 4. Wait 1-2 minutes for Cloudflare Pages deployment
```

### Verify Deployment
- Check Cloudflare Dashboard → Workers & Pages → amd-site
- If changes don't appear:
  1. Purge Cloudflare cache: Caching → Configuration → Purge Everything
  2. Hard refresh browser: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
  3. Check in incognito window

### Local Preview
```bash
python3 -m http.server 8000 --directory output
# Visit http://localhost:8000
```

---

## Content Management

### Markdown File Format
All content files use YAML frontmatter:
```yaml
---
title: "Page Title"
description: "Meta description (70-160 chars for SEO)"
template: page.html
keywords: keyword1, keyword2
---

Page content in Markdown...
```

### Adding New Pages
1. Create `.md` file in appropriate `content/` subfolder
2. Add YAML frontmatter with required fields
3. Add to navigation in `config.yaml` if needed
4. Build and deploy

### CLI Helper Tool
```bash
# Create a new page
python claude_helper.py create "Page Title" --slug "page-slug" --description "SEO description"

# Update SEO for existing page
python claude_helper.py seo products --description "New description"

# Add internal links between pages
python claude_helper.py link products about contact

# List all pages
python claude_helper.py list
```

### Blog Posts
- Location: `content/blog/`
- Template: `blog-post.html`
- Categories: Assembly, Business, Guides, News, Robotics, Trends, Vision & QC
- Paginated at 12 posts per page
- Category pages at `/blog/category/{slug}/`

### Case Studies
- Location: `content/case-studies/`
- 10 case studies across 7 industries
- Individual pages: `/case-studies/{slug}/`
- Industry filter pages: `/case-studies/{industry}/` (automotive, medical, etc.)

---

## Styling

### Key CSS Variables (`static/css/style.css`)
```css
--primary: #003087        /* Dark blue */
--primary-dark: #026
--accent-teal: #00b785
--dark: #1a1a2e
--header-height: 56px
```

### Text Contrast Rules
- Always use explicit colors, never opacity for text
- White text on dark backgrounds: `#ffffff`
- Light text on dark backgrounds: `#e0e0e0` minimum
- Dark text on light backgrounds: `#555555` or darker
- Add `text-shadow` for text over images

### Mobile Breakpoints
- Tablet: 768px
- Mobile: 480px

### Style Reference
Use the **homepage** (`templates/homepage.html`) as the primary style reference when creating new pages or components.

---

## Navigation Structure

Defined in `config.yaml`:
- **Solutions** (dropdown with 19 items, Assembly featured at top as "Core Expertise")
- **Industries** (dropdown with 12 industries)
- **Case Studies** (dropdown by industry: Automotive, Medical, Electronics, Consumer, Heavy Equipment)
- **Services** (dropdown with 8 services)
- **Tooling** (dropdown: Press Tooling, Assembly Fixtures, Welding Fixtures)
- **Resources/Blog** (dropdown with categories)
- **About**
- **Contact**

---

## Key Files Reference

| File | Purpose |
|------|---------|
| `build.py` | Main build script - generates all HTML |
| `config.yaml` | Site config, navigation, SEO defaults |
| `static/css/style.css` | All CSS styles |
| `templates/base.html` | Header, footer, nav (all pages inherit) |
| `templates/homepage.html` | Homepage layout - **style reference** |
| `templates/about.html` | About page template |
| `CNAME` | Domain configuration (amdmachines.com) |
| `scripts/seo-crawler.py` | SEO audit and broken link checker |
| `claude_helper.py` | Content management CLI tool |

---

## Images

### Image Locations
| Location | Purpose |
|----------|---------|
| `static/images/customers/` | Original high-res customer logos |
| `static/images/logos-color/` | Processed color logos (32px height) |
| `static/images/logos-white/` | Processed white logos (84px height) |
| `static/images/STORY/` | Company timeline photos (2012.jpeg, 2015.jpeg, 2018.jpeg, 2023.jpeg) |
| `static/images/amd/` | AMD facility and equipment photos |

### Logo Processing Scripts
- `process_logos_hires.py` - Creates white logos at 84px height
- `process_color_logos.py` - Creates color logos at 32px height

### Image Guidelines
- Hero images: < 200KB
- Card images: < 100KB
- Use lazy loading for below-fold images
- All images must have descriptive alt text

---

## Common Tasks

| Task | Action |
|------|--------|
| Change hero section | Edit `templates/homepage.html` → `<section class="hero hero-home">` |
| Modify navigation | Edit `config.yaml` under `navigation:` |
| Update footer | Edit `config.yaml` for links, `templates/base.html` for structure |
| Add new page | Create `.md` in `content/`, add to nav if needed |
| Edit global styles | Modify `static/css/style.css` |
| Check SEO | Run `python scripts/seo-crawler.py` |
| List all pages | Run `python claude_helper.py list` |
| Optimize images | Run `python optimize_images.py` |

---

## DNS Configuration (Cloudflare)

| Type | Name | Target |
|------|------|--------|
| CNAME | @ | amd-site.pages.dev |
| CNAME | www | amd-site.pages.dev |
| CNAME | go | clever-lemon.aploconnects.com |
| CNAME | info | hubspot (for forms) |
| CNAME | mail | hover email |

---

## Troubleshooting

### Site not updating after deploy
1. Check Cloudflare Pages dashboard for deployment status
2. Purge Cloudflare cache
3. Hard refresh browser
4. Verify you pushed to `main` branch

### Build fails
```bash
# Check/install dependencies
pip install jinja2 markdown pyyaml pillow csscompressor
```

### CSS not applying
- Hard refresh browser (Cmd+Shift+R / Ctrl+Shift+R)
- Verify CSS file was copied to `output/static/css/`

### Images not showing
- Verify path starts with `/static/images/`
- Check image exists in both `static/images/` and `output/static/images/`

---

## Environment Requirements

- **Python**: 3.x
- **Dependencies**: jinja2, markdown, pyyaml, pillow, csscompressor (optional)
- **Git Remote**: https://github.com/erdmannjuan/amd-site.git
- **Production URL**: https://amdmachines.com
- **Cloudflare Pages URL**: https://amd-site.pages.dev

---

## Quick Deploy Checklist

1. Make changes to templates/CSS/content
2. Build: `python3 build.py`
3. Verify locally (optional): `python3 -m http.server 8000 --directory output`
4. Commit: `git add . && git commit -m "message"`
5. Deploy: `git push origin main`
6. Wait 1-2 minutes for Cloudflare Pages
7. Purge Cloudflare cache if needed
8. Verify on https://amdmachines.com