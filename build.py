#!/usr/bin/env python3
"""
Static Site Generator - Build Script
Compiles markdown content into a full HTML website.
"""

import os
import shutil
import yaml
import markdown
from datetime import datetime
from pathlib import Path
from jinja2 import Environment, FileSystemLoader

# Directories
BASE_DIR = Path(__file__).parent
CONTENT_DIR = BASE_DIR / 'content'
TEMPLATES_DIR = BASE_DIR / 'templates'
STATIC_DIR = BASE_DIR / 'static'
OUTPUT_DIR = BASE_DIR / 'output'


def load_config():
    """Load site configuration from config.yaml"""
    config_path = BASE_DIR / 'config.yaml'
    with open(config_path, 'r') as f:
        return yaml.safe_load(f)


def parse_frontmatter(content):
    """Parse YAML frontmatter from markdown content"""
    if content.startswith('---'):
        parts = content.split('---', 2)
        if len(parts) >= 3:
            frontmatter = yaml.safe_load(parts[1])
            body = parts[2].strip()
            return frontmatter or {}, body
    return {}, content


def get_all_pages(content_dir):
    """Get all markdown files from content directory"""
    pages = []
    for md_file in content_dir.rglob('*.md'):
        rel_path = md_file.relative_to(content_dir)
        with open(md_file, 'r', encoding='utf-8') as f:
            content = f.read()
        
        frontmatter, body = parse_frontmatter(content)
        
        # Determine URL from file path
        if md_file.name == 'index.md':
            if md_file.parent == content_dir:
                url = '/'
            else:
                url = '/' + str(rel_path.parent) + '/'
        else:
            # Convert filename to URL, preserving directory structure
            parent_dir = str(rel_path.parent)
            if parent_dir == '.':
                url = '/' + rel_path.stem + '/'
            else:
                url = '/' + parent_dir + '/' + rel_path.stem + '/'
        
        pages.append({
            'source_path': md_file,
            'url': url.replace('\\', '/'),
            'frontmatter': frontmatter,
            'body': body
        })
    
    return pages


def get_blog_posts(all_pages):
    """Extract blog posts from all pages"""
    posts = []
    for page in all_pages:
        # Check if it's a blog post (in /blog/ but not the index)
        if page['url'].startswith('/blog/') and page['url'] != '/blog/':
            post_data = {
                'url': page['url'],
                'title': page['frontmatter'].get('title', 'Untitled'),
                'description': page['frontmatter'].get('description', ''),
                'date': page['frontmatter'].get('date', ''),
                'author': page['frontmatter'].get('author', ''),
                'category': page['frontmatter'].get('category', ''),
                'image': page['frontmatter'].get('image', ''),
                'read_time': page['frontmatter'].get('read_time', ''),
            }
            posts.append(post_data)

    # Sort by date (newest first)
    posts.sort(key=lambda x: x.get('date', ''), reverse=True)
    return posts


def build_page(page, config, env, all_pages, posts=None):
    """Build a single page"""
    page_data = {
        'title': 'Untitled',
        'template': 'page.html',
        'url': page['url'],
        **page['frontmatter']
    }

    md = markdown.Markdown(extensions=['extra', 'meta', 'toc'])
    html_content = md.convert(page['body'])

    template_name = page_data.get('template', 'page.html')
    template = env.get_template(template_name)

    rendered = template.render(
        page=page_data,
        content=html_content,
        config=config,
        all_pages=all_pages,
        posts=posts or [],
        year=datetime.now().year
    )

    if page_data['url'] == '/':
        output_path = OUTPUT_DIR / 'index.html'
    elif page_data['url'] == '/404/':
        # GitHub Pages expects 404.html at root
        output_path = OUTPUT_DIR / '404.html'
    else:
        output_path = OUTPUT_DIR / page_data['url'].strip('/') / 'index.html'

    output_path.parent.mkdir(parents=True, exist_ok=True)
    with open(output_path, 'w', encoding='utf-8') as f:
        f.write(rendered)

    print(f"  ✓ Built: {page_data['url']}")
    return page_data


def build_site():
    """Main build function"""
    print("\n🔨 Building site...\n")
    
    config = load_config()
    print(f"  Site: {config['site']['name']}")
    
    env = Environment(
        loader=FileSystemLoader(TEMPLATES_DIR),
        autoescape=True
    )
    
    if OUTPUT_DIR.exists():
        shutil.rmtree(OUTPUT_DIR)
    OUTPUT_DIR.mkdir()
    
    if STATIC_DIR.exists():
        shutil.copytree(STATIC_DIR, OUTPUT_DIR / 'static')
        print("  ✓ Copied static files")

        # Copy robots.txt to root
        robots_src = STATIC_DIR / 'robots.txt'
        if robots_src.exists():
            shutil.copy(robots_src, OUTPUT_DIR / 'robots.txt')
            print("  ✓ Copied robots.txt")

        # Copy .well-known directory to root
        wellknown_src = STATIC_DIR / '.well-known'
        if wellknown_src.exists():
            shutil.copytree(wellknown_src, OUTPUT_DIR / '.well-known')
            print("  ✓ Copied .well-known directory")

        # Copy CNAME file for custom domain
        cname_src = STATIC_DIR / 'CNAME'
        if cname_src.exists():
            shutil.copy(cname_src, OUTPUT_DIR / 'CNAME')
            print("  ✓ Copied CNAME file")
    
    pages = get_all_pages(CONTENT_DIR)
    print(f"\n  Found {len(pages)} page(s) to build:\n")

    # Extract blog posts for blog templates
    posts = get_blog_posts(pages)

    built_pages = []
    for page in pages:
        page_data = build_page(page, config, env, pages, posts)
        built_pages.append(page_data)
    
    generate_sitemap(built_pages, config)
    
    print(f"\n✅ Build complete! Output in: {OUTPUT_DIR}\n")


def generate_sitemap(pages, config):
    """Generate sitemap.xml"""
    sitemap_content = '<?xml version="1.0" encoding="UTF-8"?>\n'
    sitemap_content += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'
    
    for page in pages:
        sitemap_content += f'''  <url>
    <loc>{config['site']['url']}{page['url']}</loc>
    <lastmod>{datetime.now().strftime('%Y-%m-%d')}</lastmod>
  </url>\n'''
    
    sitemap_content += '</urlset>'
    
    sitemap_path = OUTPUT_DIR / 'sitemap.xml'
    with open(sitemap_path, 'w') as f:
        f.write(sitemap_content)
    
    print("  ✓ Generated sitemap.xml")


def serve_site(port=8000):
    """Start a local development server"""
    import http.server
    import socketserver
    
    os.chdir(OUTPUT_DIR)
    
    handler = http.server.SimpleHTTPRequestHandler
    
    with socketserver.TCPServer(("", port), handler) as httpd:
        print(f"\n🌐 Serving site at http://localhost:{port}")
        print("   Press Ctrl+C to stop\n")
        try:
            httpd.serve_forever()
        except KeyboardInterrupt:
            print("\n\n👋 Server stopped")


if __name__ == '__main__':
    import sys
    
    if len(sys.argv) > 1 and sys.argv[1] == 'serve':
        build_site()
        port = int(sys.argv[2]) if len(sys.argv) > 2 else 8000
        serve_site(port)
    else:
        build_site()
