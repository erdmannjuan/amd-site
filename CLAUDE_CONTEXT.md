# AMD Machines Website - Claude Context Prompt

Use this prompt when starting a new chat about the AMD Machines website.

---

## PROMPT TO COPY:

```
I need help with my AMD Machines website (amdautomation.com). Here's the context:

## Site Overview
- **Company**: AMD Machines - custom assembly machines and automation systems
- **Core Expertise**: Assembly Systems (this is our main specialty, highlighted on homepage)
- **Domain**: amdautomation.com
- **Repository**: github.com/erdmannjuan/amd-site

## Tech Stack
- **Static Site Generator**: Custom Python script (build.py)
- **Templating**: Jinja2
- **Hosting**: GitHub Pages
- **CSS**: Custom CSS with CSS variables (no framework)

## Directory Structure
```
my-site-generator/
├── build.py              # Main build script
├── config.yaml           # Site configuration, navigation, SEO settings
├── content/              # Markdown content files
│   ├── index.md          # Homepage
│   ├── about.md
│   ├── contact.md
│   ├── blog/             # Blog posts (356+ posts)
│   │   └── index.md
│   ├── case-studies/     # Case study pages
│   │   └── index.md
│   ├── solutions/        # Solution pages (assembly, welding, etc.)
│   ├── services/         # Service pages
│   └── industries/       # Industry pages
├── templates/            # Jinja2 HTML templates
│   ├── base.html         # Base template with header/footer
│   ├── homepage.html
│   ├── blog.html
│   ├── blog-post.html
│   ├── case-study.html
│   ├── case-studies.html
│   ├── solution.html
│   ├── page.html
│   └── ...
├── static/
│   ├── css/style.css     # Main stylesheet
│   ├── images/           # All images
│   └── js/               # JavaScript files
├── output/               # Generated site (this is the git repo for GitHub Pages)
└── scripts/
    └── seo-crawler.py    # SEO audit script
```

## How to Build & Deploy
1. Make changes to templates, CSS, or content
2. Run: `python build.py`
3. Navigate to output directory: `cd output`
4. Commit and push: `git add -A && git commit -m "message" && git push origin main`

## Content Files Format
Markdown files with YAML frontmatter:
```yaml
---
title: "Page Title"
description: "Meta description (70-160 chars for SEO)"
template: page.html
keywords: keyword1, keyword2
---

Page content in Markdown...
```

## SEO Requirements (IMPORTANT)
1. **Meta Descriptions**: Must be 70-160 characters
2. **Titles**: Unique per page, include brand name
3. **H1 Tags**: One per page
4. **Alt Text**: All images must have descriptive alt text
5. **Sitemap**: Auto-generated at /sitemap.xml
6. **Robots.txt**: Located at static/robots.txt
7. **Run SEO Audit**: `python scripts/seo-crawler.py`

## Blog Categories
- Assembly, Business, Guides, News, Robotics, Trends, Vision & QC
- Paginated at 12 posts per page
- Category pages at /blog/category/{slug}/

## Case Studies
- Individual pages at /case-studies/{slug}/
- Industry filter pages at /case-studies/{industry}/ (automotive, medical, etc.)
- 10 case studies across 7 industries

## Navigation Structure (config.yaml)
- Solutions (dropdown with 19 items, Assembly featured at top)
- Industries (dropdown)
- Services (dropdown)
- Case Studies (dropdown by industry)
- Blog
- About
- Contact

## Key CSS Variables (static/css/style.css)
- --primary: #003087 (dark blue)
- --primary-dark: #026
- --accent-teal: #00b785
- --dark: #1a1a2e
- --header-height: 56px

## Text Contrast Rules
- Always use explicit colors, never opacity for text
- White text on dark backgrounds: #ffffff
- Light text on dark backgrounds: #e0e0e0 minimum
- Dark text on light backgrounds: #555555 or darker
- Add text-shadow for text over images

## Performance Considerations
- CSS is minified during build
- Images should be optimized (<200KB for hero images)
- Use lazy loading for below-fold images
- Background images via CSS are non-blocking

## Common Tasks
- **Add new page**: Create .md file in content/, add to navigation in config.yaml if needed
- **Edit styles**: Modify static/css/style.css
- **Update navigation**: Edit config.yaml navigation section
- **Add case study**: Create .md in content/case-studies/, update index.md counts
- **Check SEO**: Run `python scripts/seo-crawler.py`

## Current Highlights
- Assembly Systems is featured as "Core Expertise" on homepage and in nav dropdown
- Homepage has special expertise section with engineering image background
- All CTA sections have high-contrast text (no opacity)

What would you like help with?
```

---

## Quick Reference Commands

```bash
# Build the site
python build.py

# Deploy changes
cd output && git add -A && git commit -m "description" && git push origin main

# Run SEO audit
python scripts/seo-crawler.py

# Check for broken links and SEO issues
python scripts/seo-crawler.py
```

## Important Files to Know

| File | Purpose |
|------|---------|
| `build.py` | Main build script - generates all HTML |
| `config.yaml` | Site config, navigation, SEO defaults |
| `static/css/style.css` | All CSS styles |
| `templates/base.html` | Header, footer, nav (all pages inherit) |
| `templates/homepage.html` | Homepage layout |
| `output/CNAME` | Domain configuration (amdautomation.com) |

## Recent Changes Log
- Added Assembly expertise highlight section on homepage
- Added engineering image background to expertise section
- Fixed text contrast issues across case studies
- Added industry filter pages for case studies
- SEO audit: 0 critical issues, 0 broken links
