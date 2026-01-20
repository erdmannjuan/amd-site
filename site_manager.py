#!/usr/bin/env python3
"""
Site Manager - Command Line Interface for Managing Your Static Site

Commands:
  python site_manager.py new-page          Create a new page interactively
  python site_manager.py new-equipment     Create a new equipment listing
  python site_manager.py add-image         Add an image to a page
  python site_manager.py update-seo        Update SEO metadata for a page
  python site_manager.py link              Add internal links between pages
  python site_manager.py list              List all pages
  python site_manager.py build             Build the site
  python site_manager.py serve             Build and serve locally
"""

import os
import sys
import yaml
import shutil
import argparse
from pathlib import Path
from datetime import datetime
from PIL import Image

BASE_DIR = Path(__file__).parent
CONTENT_DIR = BASE_DIR / 'content'
STATIC_DIR = BASE_DIR / 'static'
IMAGES_DIR = STATIC_DIR / 'images'


def slugify(text):
    """Convert text to URL-friendly slug"""
    import re
    text = text.lower().strip()
    text = re.sub(r'[^\w\s-]', '', text)
    text = re.sub(r'[-\s]+', '-', text)
    return text


def load_config():
    """Load site configuration"""
    with open(BASE_DIR / 'config.yaml', 'r') as f:
        return yaml.safe_load(f)


def process_image(source_path, dest_name=None, max_width=1200, quality=85):
    """
    Process and optimize an image for the web.

    Args:
        source_path: Path to the source image
        dest_name: Destination filename (auto-generated if None)
        max_width: Maximum width in pixels
        quality: JPEG quality (1-100)

    Returns:
        The filename of the processed image
    """
    source = Path(source_path)
    if not source.exists():
        print(f"Error: Image not found: {source_path}")
        return None

    IMAGES_DIR.mkdir(parents=True, exist_ok=True)

    if dest_name is None:
        timestamp = datetime.now().strftime('%Y%m%d_%H%M%S')
        dest_name = f"{timestamp}_{source.stem}.jpg"

    dest_path = IMAGES_DIR / dest_name

    try:
        with Image.open(source) as img:
            if img.mode in ('RGBA', 'P'):
                img = img.convert('RGB')

            if img.width > max_width:
                ratio = max_width / img.width
                new_height = int(img.height * ratio)
                img = img.resize((max_width, new_height), Image.LANCZOS)

            img.save(dest_path, 'JPEG', quality=quality, optimize=True)

        print(f"  Processed: {dest_name} ({dest_path.stat().st_size // 1024}KB)")
        return dest_name
    except Exception as e:
        print(f"Error processing image: {e}")
        return None


def create_page(title, slug, content, **kwargs):
    """Create a new page with frontmatter"""
    frontmatter = {
        'title': title,
        'description': kwargs.get('description', ''),
        'keywords': kwargs.get('keywords', ''),
        'template': kwargs.get('template', 'page.html'),
        'hero': kwargs.get('hero', False),
        'show_cta': kwargs.get('show_cta', True),
        'created': datetime.now().strftime('%Y-%m-%d'),
    }

    optional_fields = ['hero_image', 'hero_title', 'hero_subtitle', 'hero_cta',
                       'hero_cta_url', 'image', 'images', 'price', 'status', 'specs']
    for field in optional_fields:
        if kwargs.get(field):
            frontmatter[field] = kwargs[field]

    md_content = '---\n'
    md_content += yaml.dump(frontmatter, default_flow_style=False, sort_keys=False)
    md_content += '---\n\n'
    md_content += content

    if slug == '' or slug == '/':
        file_path = CONTENT_DIR / 'index.md'
    else:
        slug = slug.strip('/')
        if '/' in slug:
            file_path = CONTENT_DIR / slug / 'index.md'
        else:
            file_path = CONTENT_DIR / f'{slug}.md'

    file_path.parent.mkdir(parents=True, exist_ok=True)

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(md_content)

    print(f"Created: {file_path}")
    return file_path


def create_equipment(title, slug, description, content, price=None, status='Available',
                     specs=None, images=None, keywords=None):
    """Create a new equipment listing page"""
    return create_page(
        title=title,
        slug=slug,
        content=content,
        template='equipment.html',
        description=description,
        keywords=keywords or f"{title}, industrial equipment, machinery",
        price=price,
        status=status,
        specs=specs or {},
        images=images or [],
        show_cta=False
    )


def add_image_to_page(slug, image_path, position='append'):
    """Add an image to an existing page"""
    slug = slug.strip('/')
    file_path = CONTENT_DIR / f'{slug}.md'
    if not file_path.exists():
        file_path = CONTENT_DIR / slug / 'index.md'

    if not file_path.exists():
        print(f"Error: Page not found: {slug}")
        return None

    processed_image = process_image(image_path)
    if not processed_image:
        return None

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if content.startswith('---'):
        parts = content.split('---', 2)
        frontmatter = yaml.safe_load(parts[1])
        body = parts[2]
    else:
        frontmatter = {}
        body = content

    if 'images' not in frontmatter:
        frontmatter['images'] = []

    if position == 'prepend':
        frontmatter['images'].insert(0, processed_image)
    else:
        frontmatter['images'].append(processed_image)

    if 'image' not in frontmatter:
        frontmatter['image'] = frontmatter['images'][0]

    new_content = '---\n'
    new_content += yaml.dump(frontmatter, default_flow_style=False, sort_keys=False)
    new_content += '---'
    new_content += body

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

    print(f"Added image to: {slug}")
    return file_path


def update_seo(slug, title=None, description=None, keywords=None):
    """Update SEO metadata for a page"""
    if slug == '' or slug == '/':
        file_path = CONTENT_DIR / 'index.md'
    else:
        slug = slug.strip('/')
        file_path = CONTENT_DIR / f'{slug}.md'
        if not file_path.exists():
            file_path = CONTENT_DIR / slug / 'index.md'

    if not file_path.exists():
        print(f"Error: Page not found: {slug}")
        return None

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    if content.startswith('---'):
        parts = content.split('---', 2)
        frontmatter = yaml.safe_load(parts[1])
        body = parts[2]
    else:
        frontmatter = {}
        body = content

    if title:
        frontmatter['title'] = title
    if description:
        frontmatter['description'] = description
    if keywords:
        frontmatter['keywords'] = keywords

    frontmatter['updated'] = datetime.now().strftime('%Y-%m-%d')

    new_content = '---\n'
    new_content += yaml.dump(frontmatter, default_flow_style=False, sort_keys=False)
    new_content += '---'
    new_content += body

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

    print(f"Updated SEO for: {slug}")
    return file_path


def add_links(from_slug, to_slugs):
    """Add internal links between pages"""
    if from_slug == '':
        file_path = CONTENT_DIR / 'index.md'
    else:
        from_slug = from_slug.strip('/')
        file_path = CONTENT_DIR / f'{from_slug}.md'
        if not file_path.exists():
            file_path = CONTENT_DIR / from_slug / 'index.md'

    if not file_path.exists():
        print(f"Error: Source page not found: {from_slug}")
        return None

    with open(file_path, 'r', encoding='utf-8') as f:
        content = f.read()

    parts = content.split('---', 2)
    frontmatter = yaml.safe_load(parts[1])
    body = parts[2]

    related = []
    for slug in to_slugs:
        target_slug = slug.strip('/')
        target_path = CONTENT_DIR / f'{target_slug}.md'
        if not target_path.exists():
            target_path = CONTENT_DIR / target_slug / 'index.md'

        if target_path.exists():
            with open(target_path, 'r') as f:
                target_content = f.read()
            target_parts = target_content.split('---', 2)
            target_fm = yaml.safe_load(target_parts[1])

            related.append({
                'url': f'/{target_slug}/',
                'title': target_fm.get('title', slug),
                'excerpt': target_fm.get('description', '')[:100],
                'image': target_fm.get('image') or (target_fm.get('images', [None])[0])
            })

    frontmatter['related_pages'] = related

    new_content = '---\n'
    new_content += yaml.dump(frontmatter, default_flow_style=False, sort_keys=False)
    new_content += '---'
    new_content += body

    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(new_content)

    print(f"Added {len(related)} related links to: {from_slug}")
    return file_path


def list_pages():
    """List all pages in the content directory"""
    print("\nPages in your site:\n")
    for md_file in sorted(CONTENT_DIR.rglob('*.md')):
        rel_path = md_file.relative_to(CONTENT_DIR)

        with open(md_file, 'r') as f:
            content = f.read()

        if content.startswith('---'):
            parts = content.split('---', 2)
            fm = yaml.safe_load(parts[1])
            title = fm.get('title', 'Untitled')
            template = fm.get('template', 'page.html')
        else:
            title = 'Untitled'
            template = 'unknown'

        page_type = 'equipment' if template == 'equipment.html' else 'page'
        print(f"  [{page_type:9}] {str(rel_path):30} - {title}")
    print()


def interactive_new_page():
    """Interactive prompt for creating a new page"""
    print("\n--- Create New Page ---\n")

    title = input("Title: ").strip()
    if not title:
        print("Error: Title is required")
        return

    default_slug = slugify(title)
    slug = input(f"URL slug [{default_slug}]: ").strip() or default_slug

    description = input("Meta description: ").strip()
    keywords = input("Keywords (comma-separated): ").strip()

    hero = input("Add hero section? (y/N): ").strip().lower() == 'y'

    print("\nContent (markdown). Enter 'END' on a new line when done:")
    content_lines = []
    while True:
        line = input()
        if line.strip() == 'END':
            break
        content_lines.append(line)
    content = '\n'.join(content_lines)

    if not content:
        content = f"## {title}\n\nYour content here."

    create_page(
        title=title,
        slug=slug,
        content=content,
        description=description,
        keywords=keywords,
        hero=hero
    )
    print("\nPage created! Run 'python build.py' to rebuild the site.")


def interactive_new_equipment():
    """Interactive prompt for creating a new equipment listing"""
    print("\n--- Create New Equipment Listing ---\n")

    title = input("Equipment name: ").strip()
    if not title:
        print("Error: Equipment name is required")
        return

    default_slug = f"products/{slugify(title)}"
    slug = input(f"URL slug [{default_slug}]: ").strip() or default_slug

    description = input("Short description (for SEO): ").strip()
    price = input("Price (e.g., '$45,000' or 'Call for pricing'): ").strip() or None

    print("Status options: Available, Sold, Pending")
    status = input("Status [Available]: ").strip() or 'Available'

    print("\nSpecifications (enter 'done' when finished):")
    specs = {}
    while True:
        spec_name = input("  Spec name (or 'done'): ").strip()
        if spec_name.lower() == 'done':
            break
        spec_value = input(f"  {spec_name} value: ").strip()
        if spec_name and spec_value:
            specs[spec_name] = spec_value

    print("\nDescription (markdown). Enter 'END' on a new line when done:")
    content_lines = []
    while True:
        line = input()
        if line.strip() == 'END':
            break
        content_lines.append(line)
    content = '\n'.join(content_lines)

    if not content:
        content = f"Quality {title} ready for immediate delivery.\n\nContact us for more information."

    keywords = f"{title}, industrial equipment, machinery, {status.lower()}"

    create_equipment(
        title=title,
        slug=slug,
        description=description or f"{title} - Quality industrial equipment",
        content=content,
        price=price,
        status=status,
        specs=specs if specs else None,
        keywords=keywords
    )
    print("\nEquipment listing created! Run 'python build.py' to rebuild the site.")


def main():
    parser = argparse.ArgumentParser(
        description='Site Manager - Command Line Interface',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
Examples:
  python site_manager.py new-page              # Interactive page creation
  python site_manager.py new-equipment         # Interactive equipment listing
  python site_manager.py add-image products/excavator ~/photos/exc1.jpg
  python site_manager.py update-seo products --description "New description"
  python site_manager.py link products products/excavator products/loader
  python site_manager.py list
  python site_manager.py build
  python site_manager.py serve
        """
    )

    subparsers = parser.add_subparsers(dest='command', help='Available commands')

    # Interactive commands
    subparsers.add_parser('new-page', help='Create a new page (interactive)')
    subparsers.add_parser('new-equipment', help='Create new equipment listing (interactive)')

    # Add image command
    img_parser = subparsers.add_parser('add-image', help='Add an image to a page')
    img_parser.add_argument('slug', help='Page slug')
    img_parser.add_argument('image', help='Path to image file')
    img_parser.add_argument('--prepend', action='store_true', help='Add as first image')

    # Update SEO command
    seo_parser = subparsers.add_parser('update-seo', help='Update page SEO metadata')
    seo_parser.add_argument('slug', help='Page slug')
    seo_parser.add_argument('--title', help='New title')
    seo_parser.add_argument('--description', help='New description')
    seo_parser.add_argument('--keywords', help='New keywords')

    # Link command
    link_parser = subparsers.add_parser('link', help='Add internal links')
    link_parser.add_argument('from_slug', help='Source page slug')
    link_parser.add_argument('to_slugs', nargs='+', help='Target page slugs')

    # List command
    subparsers.add_parser('list', help='List all pages')

    # Build command
    subparsers.add_parser('build', help='Build the site')

    # Serve command
    serve_parser = subparsers.add_parser('serve', help='Build and serve locally')
    serve_parser.add_argument('--port', type=int, default=8000, help='Port number')

    args = parser.parse_args()

    if args.command == 'new-page':
        interactive_new_page()

    elif args.command == 'new-equipment':
        interactive_new_equipment()

    elif args.command == 'add-image':
        position = 'prepend' if args.prepend else 'append'
        add_image_to_page(args.slug, args.image, position)

    elif args.command == 'update-seo':
        update_seo(args.slug, args.title, args.description, args.keywords)

    elif args.command == 'link':
        add_links(args.from_slug, args.to_slugs)

    elif args.command == 'list':
        list_pages()

    elif args.command == 'build':
        os.system(f'cd "{BASE_DIR}" && source venv/bin/activate && python build.py')

    elif args.command == 'serve':
        os.system(f'cd "{BASE_DIR}" && source venv/bin/activate && python build.py serve {args.port}')

    else:
        parser.print_help()


if __name__ == '__main__':
    main()
