#!/usr/bin/env python3
"""
Claude Helper - AI-Powered Content Generation
Use Claude to create new pages, update SEO, and manage your site.
"""

import os
import sys
import yaml
import argparse
from pathlib import Path
from datetime import datetime

# Optional: Use Anthropic API directly
# pip install anthropic
try:
    from anthropic import Anthropic
    ANTHROPIC_AVAILABLE = True
except ImportError:
    ANTHROPIC_AVAILABLE = False

BASE_DIR = Path(__file__).parent
CONTENT_DIR = BASE_DIR / 'content'
STATIC_DIR = BASE_DIR / 'static'


def load_config():
    """Load site configuration"""
    with open(BASE_DIR / 'config.yaml', 'r') as f:
        return yaml.safe_load(f)


def create_page(title, slug, content, **kwargs):
    """
    Create a new page with frontmatter
    
    Args:
        title: Page title
        slug: URL slug (e.g., 'products/excavator')
        content: Markdown content
        **kwargs: Additional frontmatter fields (description, keywords, etc.)
    """
    # Build frontmatter
    frontmatter = {
        'title': title,
        'description': kwargs.get('description', ''),
        'keywords': kwargs.get('keywords', ''),
        'template': kwargs.get('template', 'page.html'),
        'hero': kwargs.get('hero', False),
        'show_cta': kwargs.get('show_cta', True),
        'created': datetime.now().strftime('%Y-%m-%d'),
    }
    
    # Add optional fields
    if kwargs.get('hero_image'):
        frontmatter['hero_image'] = kwargs['hero_image']
    if kwargs.get('hero_title'):
        frontmatter['hero_title'] = kwargs['hero_title']
    if kwargs.get('hero_subtitle'):
        frontmatter['hero_subtitle'] = kwargs['hero_subtitle']
    if kwargs.get('hero_cta'):
        frontmatter['hero_cta'] = kwargs['hero_cta']
    if kwargs.get('related_pages'):
        frontmatter['related_pages'] = kwargs['related_pages']
    
    # Build markdown file
    md_content = '---\n'
    md_content += yaml.dump(frontmatter, default_flow_style=False)
    md_content += '---\n\n'
    md_content += content
    
    # Determine file path
    if slug == '' or slug == '/':
        file_path = CONTENT_DIR / 'index.md'
    else:
        slug = slug.strip('/')
        if '/' in slug:
            # Nested page
            file_path = CONTENT_DIR / slug / 'index.md'
        else:
            file_path = CONTENT_DIR / f'{slug}.md'
    
    # Create directories if needed
    file_path.parent.mkdir(parents=True, exist_ok=True)
    
    # Write file
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(md_content)
    
    print(f"✓ Created page: {file_path}")
    return file_path


def update_page_seo(slug, title=None, description=None, keywords=None):
    """Update SEO fields for an existing page"""
    # Find the page
    if slug == '' or slug == '/':
        file_path = CONTENT_DIR / 'index.md'
    else:
        slug = slug.strip('/')
        file_path = CONTENT_DIR / f'{slug}.md'
        if not file_path.exists():
            file_path = CONTENT_DIR / slug / 'index.md'
    
    if not file_path.exists():
        print(f"✗ Page not found: {slug}")
        return None
    
    # Read current content
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse frontmatter
    if content.startswith('---'):
        parts = content.split('---', 2)
        frontmatter = yaml.safe_load(parts[1])
        body = parts[2]
    else:
        frontmatter = {}
        body = content
    
    # Update SEO fields
    if title:
        frontmatter['title'] = title
    if description:
        frontmatter['description'] = description
    if keywords:
        frontmatter['keywords'] = keywords
    
    frontmatter['updated'] = datetime.now().strftime('%Y-%m-%d')
    
    # Rebuild file
    new_content = '---\n'
    new_content += yaml.dump(frontmatter, default_flow_style=False)
    new_content += '---\n'
    new_content += body
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"✓ Updated SEO for: {slug}")
    return file_path


def add_internal_links(from_slug, to_slugs):
    """
    Add related pages links to a page
    
    Args:
        from_slug: Source page slug
        to_slugs: List of target page slugs to link to
    """
    # Find source page
    if from_slug == '':
        file_path = CONTENT_DIR / 'index.md'
    else:
        from_slug = from_slug.strip('/')
        file_path = CONTENT_DIR / f'{from_slug}.md'
        if not file_path.exists():
            file_path = CONTENT_DIR / from_slug / 'index.md'
    
    if not file_path.exists():
        print(f"✗ Source page not found: {from_slug}")
        return None
    
    # Read current content
    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()
    
    # Parse frontmatter
    parts = content.split('---', 2)
    frontmatter = yaml.safe_load(parts[1])
    body = parts[2]
    
    # Build related pages list
    related = []
    for slug in to_slugs:
        target_path = CONTENT_DIR / f'{slug.strip("/")}.md'
        if not target_path.exists():
            target_path = CONTENT_DIR / slug.strip('/') / 'index.md'
        
        if target_path.exists():
            with open(target_path, 'r') as f:
                target_content = f.read()
            target_parts = target_content.split('---', 2)
            target_fm = yaml.safe_load(target_parts[1])
            
            related.append({
                'url': f'/{slug.strip("/")}/',
                'title': target_fm.get('title', slug),
                'excerpt': target_fm.get('description', '')[:100]
            })
    
    frontmatter['related_pages'] = related
    
    # Rebuild file
    new_content = '---\n'
    new_content += yaml.dump(frontmatter, default_flow_style=False)
    new_content += '---\n'
    new_content += body
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)
    
    print(f"✓ Added {len(related)} related links to: {from_slug}")
    return file_path


def list_pages():
    """List all pages in the content directory"""
    print("\n📄 Pages in your site:\n")
    for md_file in CONTENT_DIR.rglob('*.md'):
        rel_path = md_file.relative_to(CONTENT_DIR)
        
        with open(md_file, 'r') as f:
            content = f.read()
        
        if content.startswith('---'):
            parts = content.split('---', 2)
            fm = yaml.safe_load(parts[1])
            title = fm.get('title', 'Untitled')
        else:
            title = 'Untitled'
        
        print(f"  • {rel_path} - \"{title}\"")
    print()


def generate_with_claude(prompt, api_key=None):
    """
    Use Claude API to generate content
    
    Args:
        prompt: The prompt for Claude
        api_key: Anthropic API key (or set ANTHROPIC_API_KEY env var)
    """
    if not ANTHROPIC_AVAILABLE:
        print("✗ Anthropic library not installed. Run: pip install anthropic")
        return None
    
    api_key = api_key or os.environ.get('ANTHROPIC_API_KEY')
    if not api_key:
        print("✗ No API key. Set ANTHROPIC_API_KEY environment variable.")
        return None
    
    client = Anthropic(api_key=api_key)
    
    message = client.messages.create(
        model="claude-sonnet-4-20250514",
        max_tokens=4096,
        messages=[
            {"role": "user", "content": prompt}
        ]
    )
    
    return message.content[0].text


# ============================================
# Command Line Interface
# ============================================

def main():
    parser = argparse.ArgumentParser(
        description='Site management helper with Claude integration'
    )
    
    subparsers = parser.add_subparsers(dest='command', help='Commands')
    
    # Create page command
    create_parser = subparsers.add_parser('create', help='Create a new page')
    create_parser.add_argument('title', help='Page title')
    create_parser.add_argument('--slug', required=True, help='URL slug')
    create_parser.add_argument('--description', default='', help='Meta description')
    create_parser.add_argument('--keywords', default='', help='Meta keywords')
    create_parser.add_argument('--content', default='', help='Page content (markdown)')
    create_parser.add_argument('--hero', action='store_true', help='Add hero section')
    
    # Update SEO command
    seo_parser = subparsers.add_parser('seo', help='Update page SEO')
    seo_parser.add_argument('slug', help='Page slug')
    seo_parser.add_argument('--title', help='New title')
    seo_parser.add_argument('--description', help='New description')
    seo_parser.add_argument('--keywords', help='New keywords')
    
    # Link pages command
    link_parser = subparsers.add_parser('link', help='Add internal links')
    link_parser.add_argument('from_slug', help='Source page slug')
    link_parser.add_argument('to_slugs', nargs='+', help='Target page slugs')
    
    # List pages command
    subparsers.add_parser('list', help='List all pages')
    
    args = parser.parse_args()
    
    if args.command == 'create':
        content = args.content or f"# {args.title}\n\nYour content here."
        create_page(
            title=args.title,
            slug=args.slug,
            content=content,
            description=args.description,
            keywords=args.keywords,
            hero=args.hero
        )
    
    elif args.command == 'seo':
        update_page_seo(
            slug=args.slug,
            title=args.title,
            description=args.description,
            keywords=args.keywords
        )
    
    elif args.command == 'link':
        add_internal_links(args.from_slug, args.to_slugs)
    
    elif args.command == 'list':
        list_pages()
    
    else:
        parser.print_help()


if __name__ == '__main__':
    main()
