# AMD Machines Website - Complete Guide

## Overview

This is the marketing website for AMD Machines (amdmachines.com), a custom automation and manufacturing solutions company. The site is a static site generator built with Python and Jinja2 templates.

---

## Architecture

### Tech Stack
- **Static Site Generator**: Custom Python (`build.py`)
- **Templating**: Jinja2
- **Styling**: CSS (no preprocessor)
- **Content**: Markdown files with YAML frontmatter
- **Hosting**: Cloudflare Pages
- **CDN/DNS**: Cloudflare

### Directory Structure
```
my-site-generator/
├── build.py              # Main build script
├── config.yaml           # Site configuration (nav, footer, social, etc.)
├── content/              # Markdown content files
│   ├── blog/             # Blog posts
│   ├── case-studies/     # Case study pages
│   ├── industries/       # Industry pages
│   ├── solutions/        # Solution pages
│   └── ...
├── templates/            # Jinja2 HTML templates
│   ├── base.html         # Base layout (header, footer)
│   ├── homepage.html     # Homepage template
│   ├── page.html         # Generic page template
│   ├── blog-post.html    # Blog post template
│   └── ...
├── static/               # Static assets (copied to output)
│   ├── css/
│   │   └── style.css     # Main stylesheet
│   ├── images/
│   │   ├── customers/    # Original customer logos (source)
│   │   ├── logos-white/  # Processed white logos
│   │   └── logos-color/  # Processed color logos
│   └── js/
├── output/               # Generated site (deployed)
└── .github/workflows/    # GitHub Actions (not used for deploy)
```

---

## Build Process

### To Build the Site
```bash
python3 build.py
```

This:
1. Reads `config.yaml` for site settings
2. Processes all Markdown files in `content/`
3. Renders templates with Jinja2
4. Copies static files
5. Outputs everything to `output/`

### Build Output
- Generated HTML files go to `output/`
- Static files are copied to `output/static/`
- Sitemap and search index are auto-generated

---

## Deployment

### Production Deployment (Cloudflare Pages)

**IMPORTANT**: The site is hosted on **Cloudflare Pages**, NOT Netlify.

The domain `amdmachines.com` points to `amd-site.pages.dev` (Cloudflare Pages).

#### To Deploy Changes:

1. Make your changes to templates, CSS, or content
2. Build the site: `python3 build.py`
3. Commit changes:
   ```bash
   git add .
   git commit -m "Description of changes"
   ```
4. Push to trigger deployment:
   ```bash
   git push origin main
   ```
5. Cloudflare Pages auto-deploys from the GitHub repo (takes 1-2 minutes)

#### Checking Deployment Status:
- Go to Cloudflare Dashboard → Workers & Pages → amd-site
- View deployment history and logs

#### If Changes Don't Appear:
1. Purge Cloudflare cache: Caching → Configuration → Purge Everything
2. Hard refresh browser: Cmd+Shift+R (Mac) or Ctrl+Shift+R (Windows)
3. Check in incognito window

### Netlify (Legacy - Do Not Use for Production)

There's also a Netlify configuration (`.netlify/`, `netlify.toml`) but the production site does NOT use Netlify. The domain points to Cloudflare Pages.

If you accidentally deploy to Netlify with `npx netlify-cli deploy --prod --dir=output`, it deploys to `amd-automation.netlify.app` which is NOT connected to `amdmachines.com`.

---

## Key Files to Modify

### Styling
- **`static/css/style.css`** - All CSS styles
- Uses CSS custom properties (variables) defined at the top
- Mobile breakpoints: 768px, 480px

### Homepage
- **`templates/homepage.html`** - Homepage structure and sections
- **`content/index.md`** - Homepage content/metadata (if used)

### Navigation & Footer
- **`config.yaml`** - Navigation structure, footer links, social links
- **`templates/base.html`** - Header and footer HTML

### Adding New Pages
1. Create Markdown file in `content/` with YAML frontmatter:
   ```yaml
   ---
   title: "Page Title"
   description: "SEO description"
   template: page.html
   ---

   Page content in Markdown...
   ```
2. Build and deploy

### Adding Blog Posts
1. Create file in `content/blog/` named `post-slug.md`
2. Use `template: blog-post.html` in frontmatter
3. Build and deploy

---

## Logo Carousel

### How It Works
- Continuous horizontal scroll animation (CSS)
- Uses color logos with grayscale CSS filter
- Located between hero and "What are you trying to automate?" section

### Logo Files
- **Source images**: `static/images/customers/` (original high-res)
- **Processed color logos**: `static/images/logos-color/` (32px height)
- **Processed white logos**: `static/images/logos-white/` (84px height for retina)

### Processing Logos
To process new logos, use the Python scripts:
- `process_logos_hires.py` - Creates white logos at 84px height
- `process_color_logos.py` - Creates color logos at 32px height

### Adding/Removing Logos
1. Add source image to `static/images/customers/`
2. Update the name mapping in the processing script
3. Run the script to generate processed versions
4. Update `templates/homepage.html` to include/exclude the logo
5. Build and deploy

---

## Common Tasks

### Change Hero Section
Edit `templates/homepage.html` - look for `<section class="hero hero-home">`

### Change Hero Height
In `static/css/style.css`, find `.hero` and modify `min-height` (currently 70vh)

### Modify Navigation
Edit `config.yaml` under `navigation:`

### Update Footer
Edit `config.yaml` for links, `templates/base.html` for structure

### Add New Solution/Industry Page
1. Create Markdown file in appropriate `content/` subfolder
2. Use existing page as template for frontmatter
3. Build and deploy

---

## DNS Configuration

### Cloudflare DNS Records
| Type  | Name | Target                      |
|-------|------|------------------------------|
| CNAME | @    | amd-site.pages.dev          |
| CNAME | www  | amd-site.pages.dev          |
| CNAME | go   | clever-lemon.aploconnects.com |
| CNAME | info | hubspot (for forms)          |
| CNAME | mail | hover email                  |

---

## Troubleshooting

### Site not updating after deploy
1. Check Cloudflare Pages dashboard for deployment status
2. Purge Cloudflare cache
3. Hard refresh browser
4. Verify you pushed to `main` branch

### Build fails
- Check Python dependencies: `pip install jinja2 markdown pyyaml pillow`
- Check for syntax errors in templates or content files

### CSS not applying
- Check browser cache (hard refresh)
- Verify CSS file was copied to output
- Check for CSS syntax errors

### Images not showing
- Verify image path is correct (starts with `/static/images/`)
- Check image exists in `static/images/` (source) and `output/static/images/` (built)

---

## Environment

- **Python**: 3.x required
- **Dependencies**: jinja2, markdown, pyyaml, pillow, csscompressor (optional)
- **Git remote**: https://github.com/erdmannjuan/amd-site.git
- **Production URL**: https://amdmachines.com
- **Cloudflare Pages URL**: https://amd-site.pages.dev

---

## Summary: Quick Deploy Checklist

1. ✏️ Make changes to templates/CSS/content
2. 🔨 Build: `python3 build.py`
3. ✅ Verify locally (optional): `python3 -m http.server 8000 --directory output`
4. 📝 Commit: `git add . && git commit -m "message"`
5. 🚀 Deploy: `git push origin main`
6. ⏳ Wait 1-2 minutes for Cloudflare Pages
7. 🧹 Purge Cloudflare cache if needed
8. ✔️ Verify on https://amdmachines.com
