# AMD Machines Website - AI Agent Context

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

## SEO Protection (Read Before Making Changes)

**This site is LIVE and actively ranking in search engines.** Do not modify without explicit approval:
- URL structures or slugs
- Page titles or meta descriptions
- H1 tags or heading hierarchy
- Internal linking structure
- Navigation structure
- Sitemap configuration

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
