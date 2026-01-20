# My Site Generator

A simple, Python-powered static site generator that you control from your terminal.

## Quick Start

```bash
# 1. Install dependencies
pip install -r requirements.txt

# 2. Build the site
python build.py

# 3. Preview locally
python build.py serve
```

Your site will be available at `http://localhost:8000`

## Project Structure

```
my-site-generator/
├── content/           # Your pages (markdown files)
├── templates/         # HTML templates (Jinja2)
├── static/           # CSS, JS, images
│   ├── css/
│   ├── js/
│   └── images/
├── output/           # Generated site (deploy this)
├── config.yaml       # Site configuration
├── build.py          # Main build script
└── claude_helper.py  # Content management tools
```

## Creating New Pages

### Method 1: Manual Creation
Create a `.md` file in the `content/` directory with frontmatter:

```markdown
---
title: My New Page
description: A description for SEO
keywords: keyword1, keyword2
template: page.html
hero: false
show_cta: true
---

Your markdown content here.
```

### Method 2: Using the CLI Helper

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

## Frontmatter Options

| Field | Description |
|-------|-------------|
| `title` | Page title (required) |
| `description` | Meta description for SEO |
| `keywords` | Meta keywords |
| `template` | Template to use (default: page.html) |
| `hero` | Show hero section (true/false) |
| `hero_image` | Background image for hero |
| `hero_title` | Override title in hero |
| `hero_subtitle` | Subtitle in hero |
| `hero_cta` | CTA button text |
| `hero_cta_url` | CTA button link |
| `show_cta` | Show CTA section at bottom |
| `related_pages` | List of related page links |

## Deployment Options

### Option 1: GitHub Pages (Free)
1. Create a GitHub repository
2. Push the `output/` folder contents
3. Enable GitHub Pages in settings

### Option 2: Netlify (Free tier)
1. Create a Netlify account
2. Connect your repository
3. Set build command: `python build.py`
4. Set publish directory: `output`

### Option 3: Traditional Hosting
Upload the contents of `output/` to your web server via FTP/SFTP.

## Customization

### Colors
Edit `config.yaml` to change the color scheme, then update the CSS variables in `static/css/style.css`.

### Templates
Edit files in `templates/` to change the HTML structure.

### Styling
Modify `static/css/style.css` for custom styles.

## Workflow for Weekly Updates

1. Add new images to `static/images/`
2. Create new page: `python claude_helper.py create "Title" --slug "url"`
3. Edit the markdown file with your content
4. Build: `python build.py`
5. Preview: `python build.py serve`
6. Deploy the `output/` folder

## Tips

- Keep URLs short and descriptive
- Write unique descriptions for every page
- Use internal links to connect related pages
- Optimize images before uploading
- Test on mobile after changes
