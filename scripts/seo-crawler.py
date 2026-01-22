#!/usr/bin/env python3
"""
SEO Crawler - Checks for broken links and SEO issues
"""

import os
import re
from pathlib import Path
from collections import defaultdict
from html.parser import HTMLParser
from urllib.parse import urljoin, urlparse

OUTPUT_DIR = Path("/Users/juan_erdmann/my-site-generator/output")
BASE_URL = "https://amdmachines.com"

class HTMLAnalyzer(HTMLParser):
    def __init__(self, page_path):
        super().__init__()
        self.page_path = page_path
        self.links = []
        self.images = []
        self.title = None
        self.meta_description = None
        self.h1_tags = []
        self.in_title = False
        self.in_h1 = False
        self.current_h1 = ""
        self.title_content = ""

    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)

        if tag == 'a':
            href = attrs_dict.get('href', '')
            if href:
                self.links.append(href)

        elif tag == 'img':
            src = attrs_dict.get('src', '')
            alt = attrs_dict.get('alt')
            self.images.append({'src': src, 'alt': alt})

        elif tag == 'meta':
            if attrs_dict.get('name', '').lower() == 'description':
                self.meta_description = attrs_dict.get('content', '')

        elif tag == 'title':
            self.in_title = True

        elif tag == 'h1':
            self.in_h1 = True
            self.current_h1 = ""

    def handle_endtag(self, tag):
        if tag == 'title':
            self.in_title = False
            self.title = self.title_content.strip()
        elif tag == 'h1':
            self.in_h1 = False
            if self.current_h1.strip():
                self.h1_tags.append(self.current_h1.strip())

    def handle_data(self, data):
        if self.in_title:
            self.title_content += data
        elif self.in_h1:
            self.current_h1 += data


def get_all_html_files():
    """Find all HTML files in output directory"""
    html_files = []
    for root, dirs, files in os.walk(OUTPUT_DIR):
        for file in files:
            if file.endswith('.html'):
                html_files.append(Path(root) / file)
    return html_files


def file_path_to_url(file_path):
    """Convert file path to URL path"""
    rel_path = file_path.relative_to(OUTPUT_DIR)
    if rel_path.name == 'index.html':
        url_path = '/' + str(rel_path.parent) + '/'
        if url_path == '/./' or url_path == '/./':
            url_path = '/'
    else:
        url_path = '/' + str(rel_path)
    return url_path.replace('//', '/')


def url_to_file_path(url, current_page_path):
    """Convert URL to expected file path"""
    # Handle external URLs
    if url.startswith(('http://', 'https://', 'mailto:', 'tel:', '#', 'javascript:')):
        return None

    # Handle anchor links
    if url.startswith('#'):
        return None

    # Remove query strings and anchors
    url = url.split('?')[0].split('#')[0]

    # Handle relative URLs
    if not url.startswith('/'):
        current_dir = current_page_path.parent
        url = '/' + str((current_dir / url).relative_to(OUTPUT_DIR))

    # Normalize the path
    url = url.rstrip('/')

    # Check for directory with index.html
    dir_path = OUTPUT_DIR / url.lstrip('/')
    if dir_path.is_dir():
        return dir_path / 'index.html'

    # Check for direct file
    file_path = OUTPUT_DIR / url.lstrip('/')
    if file_path.exists():
        return file_path

    # Check with .html extension
    html_path = OUTPUT_DIR / (url.lstrip('/') + '.html')
    if html_path.exists():
        return html_path

    # Check as directory with index.html
    index_path = OUTPUT_DIR / url.lstrip('/') / 'index.html'
    if index_path.exists():
        return index_path

    return False  # Broken link


def check_image_exists(src, current_page_path):
    """Check if image file exists"""
    if src.startswith(('http://', 'https://', 'data:')):
        return True  # External or data URI

    # Handle relative paths
    if src.startswith('/'):
        img_path = OUTPUT_DIR / src.lstrip('/')
    else:
        img_path = current_page_path.parent / src

    return img_path.exists()


def analyze_site():
    """Main analysis function"""
    html_files = get_all_html_files()

    issues = {
        'broken_links': [],
        'missing_alt': [],
        'missing_images': [],
        'missing_title': [],
        'missing_meta_desc': [],
        'short_meta_desc': [],
        'long_meta_desc': [],
        'missing_h1': [],
        'multiple_h1': [],
        'duplicate_titles': defaultdict(list),
        'duplicate_meta': defaultdict(list),
    }

    all_internal_urls = set()

    # First pass: collect all valid internal URLs
    for html_file in html_files:
        url = file_path_to_url(html_file)
        all_internal_urls.add(url.rstrip('/'))

    print(f"Analyzing {len(html_files)} pages...\n")

    # Second pass: analyze each page
    for html_file in html_files:
        page_url = file_path_to_url(html_file)

        try:
            with open(html_file, 'r', encoding='utf-8') as f:
                content = f.read()
        except Exception as e:
            print(f"Error reading {html_file}: {e}")
            continue

        analyzer = HTMLAnalyzer(html_file)
        try:
            analyzer.feed(content)
        except Exception as e:
            print(f"Error parsing {html_file}: {e}")
            continue

        # Check links
        for link in analyzer.links:
            # Skip external, mailto, tel, javascript, and anchor links
            if link.startswith(('http://', 'https://', 'mailto:', 'tel:', '#', 'javascript:')):
                continue

            result = url_to_file_path(link, html_file)
            if result is False:
                issues['broken_links'].append({
                    'page': page_url,
                    'broken_link': link
                })

        # Check images
        for img in analyzer.images:
            if not img['src']:
                continue

            # Check alt text
            if img['alt'] is None or img['alt'].strip() == '':
                # Skip decorative images (often icons or backgrounds)
                if not any(x in img['src'].lower() for x in ['icon', 'logo', 'background', 'pattern', 'decoration']):
                    issues['missing_alt'].append({
                        'page': page_url,
                        'image': img['src']
                    })

            # Check if image exists
            if not check_image_exists(img['src'], html_file):
                issues['missing_images'].append({
                    'page': page_url,
                    'image': img['src']
                })

        # Check title
        if not analyzer.title:
            issues['missing_title'].append(page_url)
        else:
            issues['duplicate_titles'][analyzer.title].append(page_url)

        # Check meta description
        if not analyzer.meta_description:
            issues['missing_meta_desc'].append(page_url)
        else:
            desc_len = len(analyzer.meta_description)
            if desc_len < 70:
                issues['short_meta_desc'].append({
                    'page': page_url,
                    'length': desc_len,
                    'description': analyzer.meta_description[:50] + '...' if len(analyzer.meta_description) > 50 else analyzer.meta_description
                })
            elif desc_len > 160:
                issues['long_meta_desc'].append({
                    'page': page_url,
                    'length': desc_len,
                    'description': analyzer.meta_description[:50] + '...'
                })
            issues['duplicate_meta'][analyzer.meta_description].append(page_url)

        # Check H1 tags
        if not analyzer.h1_tags:
            issues['missing_h1'].append(page_url)
        elif len(analyzer.h1_tags) > 1:
            issues['multiple_h1'].append({
                'page': page_url,
                'count': len(analyzer.h1_tags),
                'h1s': analyzer.h1_tags[:3]  # Show first 3
            })

    return issues


def print_report(issues):
    """Print formatted report"""
    print("=" * 70)
    print("SEO CRAWLER REPORT")
    print("=" * 70)

    # Broken Links
    print(f"\n🔗 BROKEN INTERNAL LINKS: {len(issues['broken_links'])}")
    print("-" * 50)
    if issues['broken_links']:
        for item in issues['broken_links'][:30]:  # Show first 30
            print(f"  Page: {item['page']}")
            print(f"  → Broken: {item['broken_link']}")
            print()
        if len(issues['broken_links']) > 30:
            print(f"  ... and {len(issues['broken_links']) - 30} more")
    else:
        print("  ✓ No broken links found")

    # Missing Images
    print(f"\n🖼️  MISSING IMAGES: {len(issues['missing_images'])}")
    print("-" * 50)
    if issues['missing_images']:
        for item in issues['missing_images'][:20]:
            print(f"  Page: {item['page']}")
            print(f"  → Missing: {item['image']}")
            print()
        if len(issues['missing_images']) > 20:
            print(f"  ... and {len(issues['missing_images']) - 20} more")
    else:
        print("  ✓ All images found")

    # Missing Alt Text
    print(f"\n🏷️  IMAGES MISSING ALT TEXT: {len(issues['missing_alt'])}")
    print("-" * 50)
    if issues['missing_alt']:
        for item in issues['missing_alt'][:20]:
            print(f"  Page: {item['page']}")
            print(f"  → Image: {item['image']}")
            print()
        if len(issues['missing_alt']) > 20:
            print(f"  ... and {len(issues['missing_alt']) - 20} more")
    else:
        print("  ✓ All images have alt text")

    # Missing Titles
    print(f"\n📝 MISSING TITLE TAGS: {len(issues['missing_title'])}")
    print("-" * 50)
    if issues['missing_title']:
        for page in issues['missing_title']:
            print(f"  → {page}")
    else:
        print("  ✓ All pages have titles")

    # Missing Meta Descriptions
    print(f"\n📋 MISSING META DESCRIPTIONS: {len(issues['missing_meta_desc'])}")
    print("-" * 50)
    if issues['missing_meta_desc']:
        for page in issues['missing_meta_desc'][:20]:
            print(f"  → {page}")
        if len(issues['missing_meta_desc']) > 20:
            print(f"  ... and {len(issues['missing_meta_desc']) - 20} more")
    else:
        print("  ✓ All pages have meta descriptions")

    # Short Meta Descriptions
    print(f"\n⚠️  SHORT META DESCRIPTIONS (<70 chars): {len(issues['short_meta_desc'])}")
    print("-" * 50)
    if issues['short_meta_desc']:
        for item in issues['short_meta_desc'][:10]:
            print(f"  Page: {item['page']}")
            print(f"  → Length: {item['length']} chars - \"{item['description']}\"")
            print()
        if len(issues['short_meta_desc']) > 10:
            print(f"  ... and {len(issues['short_meta_desc']) - 10} more")
    else:
        print("  ✓ All meta descriptions are adequate length")

    # Long Meta Descriptions
    print(f"\n⚠️  LONG META DESCRIPTIONS (>160 chars): {len(issues['long_meta_desc'])}")
    print("-" * 50)
    if issues['long_meta_desc']:
        for item in issues['long_meta_desc'][:10]:
            print(f"  Page: {item['page']}")
            print(f"  → Length: {item['length']} chars")
            print()
        if len(issues['long_meta_desc']) > 10:
            print(f"  ... and {len(issues['long_meta_desc']) - 10} more")
    else:
        print("  ✓ All meta descriptions are within limit")

    # Missing H1
    print(f"\n🔤 MISSING H1 TAGS: {len(issues['missing_h1'])}")
    print("-" * 50)
    if issues['missing_h1']:
        for page in issues['missing_h1'][:15]:
            print(f"  → {page}")
        if len(issues['missing_h1']) > 15:
            print(f"  ... and {len(issues['missing_h1']) - 15} more")
    else:
        print("  ✓ All pages have H1 tags")

    # Multiple H1
    print(f"\n⚠️  MULTIPLE H1 TAGS: {len(issues['multiple_h1'])}")
    print("-" * 50)
    if issues['multiple_h1']:
        for item in issues['multiple_h1'][:10]:
            print(f"  Page: {item['page']}")
            print(f"  → {item['count']} H1 tags: {item['h1s']}")
            print()
        if len(issues['multiple_h1']) > 10:
            print(f"  ... and {len(issues['multiple_h1']) - 10} more")
    else:
        print("  ✓ All pages have single H1")

    # Duplicate Titles
    dup_titles = {k: v for k, v in issues['duplicate_titles'].items() if len(v) > 1}
    print(f"\n🔄 DUPLICATE TITLES: {len(dup_titles)}")
    print("-" * 50)
    if dup_titles:
        for title, pages in list(dup_titles.items())[:10]:
            print(f"  Title: \"{title[:60]}...\"" if len(title) > 60 else f"  Title: \"{title}\"")
            for page in pages[:5]:
                print(f"    → {page}")
            if len(pages) > 5:
                print(f"    ... and {len(pages) - 5} more pages")
            print()
        if len(dup_titles) > 10:
            print(f"  ... and {len(dup_titles) - 10} more duplicate titles")
    else:
        print("  ✓ No duplicate titles")

    # Summary
    print("\n" + "=" * 70)
    print("SUMMARY")
    print("=" * 70)

    critical = len(issues['broken_links']) + len(issues['missing_images'])
    warnings = (len(issues['missing_alt']) + len(issues['missing_title']) +
                len(issues['missing_meta_desc']) + len(issues['missing_h1']))
    minor = (len(issues['short_meta_desc']) + len(issues['long_meta_desc']) +
             len(issues['multiple_h1']) + len(dup_titles))

    print(f"\n  🔴 Critical Issues: {critical}")
    print(f"  🟡 Warnings: {warnings}")
    print(f"  🟠 Minor Issues: {minor}")

    if critical == 0 and warnings == 0:
        print("\n  ✅ Site is in good SEO health!")
    elif critical == 0:
        print("\n  ⚠️  Site has some issues that should be addressed")
    else:
        print("\n  ❌ Site has critical issues that need immediate attention")


if __name__ == '__main__':
    issues = analyze_site()
    print_report(issues)
