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
            # Convert date to string for consistent sorting
            date_val = page['frontmatter'].get('date', '')
            if hasattr(date_val, 'strftime'):
                date_val = date_val.strftime('%Y-%m-%d')
            elif date_val:
                date_val = str(date_val)

            post_data = {
                'url': page['url'],
                'title': page['frontmatter'].get('title', 'Untitled'),
                'description': page['frontmatter'].get('description', ''),
                'date': date_val,
                'author': page['frontmatter'].get('author', ''),
                'category': page['frontmatter'].get('category', ''),
                'image': page['frontmatter'].get('image', ''),
                'read_time': page['frontmatter'].get('read_time', ''),
            }
            posts.append(post_data)

    # Sort by date (newest first)
    posts.sort(key=lambda x: x.get('date', ''), reverse=True)
    return posts


def get_related_posts(page_data, posts, max_related=3):
    """Find related posts based on category"""
    if not posts:
        return []

    current_url = page_data.get('url', '')
    current_category = page_data.get('category', '')

    related = []

    # First, find posts in the same category
    if current_category:
        for post in posts:
            if post.get('url') != current_url and post.get('category') == current_category:
                related.append(post)
                if len(related) >= max_related:
                    break

    # If not enough, add recent posts from other categories
    if len(related) < max_related:
        for post in posts:
            if post.get('url') != current_url and post not in related:
                related.append(post)
                if len(related) >= max_related:
                    break

    return related


POSTS_PER_PAGE = 12  # Number of blog posts per page


def build_blog_index_pages(config, env, posts, categories):
    """Build paginated blog index pages"""
    total_posts = len(posts)
    total_pages = (total_posts + POSTS_PER_PAGE - 1) // POSTS_PER_PAGE
    built_pages = []

    for page_num in range(1, total_pages + 1):
        start_idx = (page_num - 1) * POSTS_PER_PAGE
        end_idx = start_idx + POSTS_PER_PAGE
        page_posts = posts[start_idx:end_idx]

        # Pagination data
        pagination = {
            'current_page': page_num,
            'total_pages': total_pages,
            'total_posts': total_posts,
            'has_prev': page_num > 1,
            'has_next': page_num < total_pages,
            'prev_url': '/blog/' if page_num == 2 else f'/blog/page/{page_num - 1}/' if page_num > 1 else None,
            'next_url': f'/blog/page/{page_num + 1}/' if page_num < total_pages else None,
            'pages': list(range(1, total_pages + 1))
        }

        page_data = {
            'title': 'Automation Insights & Industry Blog' if page_num == 1 else f'Blog - Page {page_num}',
            'description': 'Expert perspectives on manufacturing automation, robotics, and industry trends.',
            'template': 'blog.html',
            'url': '/blog/' if page_num == 1 else f'/blog/page/{page_num}/',
            'hero_title': 'Automation Insights',
            'hero_subtitle': 'Expert perspectives on manufacturing automation, robotics, and industry trends',
            'label': 'Blog'
        }

        template = env.get_template('blog.html')
        rendered = template.render(
            page=page_data,
            content='',
            config=config,
            posts=page_posts,
            categories=categories,
            pagination=pagination,
            year=datetime.now().year
        )

        if page_num == 1:
            output_path = OUTPUT_DIR / 'blog' / 'index.html'
        else:
            output_path = OUTPUT_DIR / 'blog' / 'page' / str(page_num) / 'index.html'

        output_path.parent.mkdir(parents=True, exist_ok=True)
        with open(output_path, 'w', encoding='utf-8') as f:
            f.write(rendered)

        print(f"  ✓ Built: {page_data['url']}")
        built_pages.append(page_data)

    return built_pages


def build_page(page, config, env, all_pages, posts=None, categories=None):
    """Build a single page"""
    page_data = {
        'title': 'Untitled',
        'template': 'page.html',
        'url': page['url'],
        **page['frontmatter']
    }

    md = markdown.Markdown(extensions=['extra', 'meta', 'toc'])
    html_content = md.convert(page['body'])

    # Add related posts for blog posts
    if page_data.get('template') == 'blog-post.html' and posts:
        page_data['related_posts'] = get_related_posts(page_data, posts)

    template_name = page_data.get('template', 'page.html')
    template = env.get_template(template_name)

    rendered = template.render(
        page=page_data,
        content=html_content,
        config=config,
        all_pages=all_pages,
        posts=posts or [],
        categories=categories or [],
        pagination=None,
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

        # Minify CSS for production
        try:
            import csscompressor
            css_file = OUTPUT_DIR / 'static' / 'css' / 'style.css'
            if css_file.exists():
                original_size = css_file.stat().st_size
                with open(css_file, 'r') as f:
                    css_content = f.read()
                minified = csscompressor.compress(css_content)
                with open(css_file, 'w') as f:
                    f.write(minified)
                new_size = css_file.stat().st_size
                savings = ((original_size - new_size) / original_size) * 100
                print(f"  ✓ Minified CSS ({original_size//1024}KB → {new_size//1024}KB, {savings:.0f}% smaller)")
        except ImportError:
            print("  ⚠ csscompressor not installed, skipping CSS minification")

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

        # Copy _headers file for cache control (Netlify/Cloudflare)
        headers_src = BASE_DIR / '_headers'
        if headers_src.exists():
            shutil.copy(headers_src, OUTPUT_DIR / '_headers')
            print("  ✓ Copied _headers file")

        # Copy _redirects file for URL redirects (Netlify/Cloudflare)
        redirects_src = BASE_DIR / '_redirects'
        if redirects_src.exists():
            shutil.copy(redirects_src, OUTPUT_DIR / '_redirects')
            print("  ✓ Copied _redirects file")
    
    pages = get_all_pages(CONTENT_DIR)
    print(f"\n  Found {len(pages)} page(s) to build:\n")

    # Extract blog posts for blog templates
    posts = get_blog_posts(pages)

    # Extract unique categories from posts
    categories = sorted(set(p.get('category', '') for p in posts if p.get('category')))

    built_pages = []
    for page in pages:
        # Skip blog index - we build it separately with pagination
        if page['url'] == '/blog/':
            continue
        page_data = build_page(page, config, env, pages, posts, categories)
        built_pages.append(page_data)

    # Build paginated blog index pages
    blog_pages = build_blog_index_pages(config, env, posts, categories)
    built_pages.extend(blog_pages)

    generate_sitemap(built_pages, config)
    
    print(f"\n✅ Build complete! Output in: {OUTPUT_DIR}\n")


def generate_sitemap(pages, config):
    """Generate sitemap.xml with priority and changefreq for SEO"""
    sitemap_content = '<?xml version="1.0" encoding="UTF-8"?>\n'
    sitemap_content += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n'

    today = datetime.now().strftime('%Y-%m-%d')

    for page in pages:
        url = page['url']

        # Skip 404 and other utility pages
        if url in ['/404/', '/privacy-policy/']:
            continue

        # Determine priority and changefreq based on page type
        if url == '/':
            priority = '1.0'
            changefreq = 'weekly'
        elif url in ['/solutions/', '/industries/', '/blog/', '/about/', '/contact/']:
            priority = '0.9'
            changefreq = 'weekly'
        elif url.startswith('/solutions/') or url.startswith('/industries/'):
            priority = '0.8'
            changefreq = 'monthly'
        elif url.startswith('/blog/'):
            priority = '0.7'
            changefreq = 'monthly'
        elif url.startswith('/services/'):
            priority = '0.6'
            changefreq = 'monthly'
        else:
            priority = '0.5'
            changefreq = 'monthly'

        sitemap_content += f'''  <url>
    <loc>{config['site']['url']}{url}</loc>
    <lastmod>{today}</lastmod>
    <changefreq>{changefreq}</changefreq>
    <priority>{priority}</priority>
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
