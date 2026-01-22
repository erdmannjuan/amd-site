#!/usr/bin/env python3
"""
Fix SEO issues and humanize blog content
"""
import os
import re
import yaml

CONTENT_DIR = '/Users/juan_erdmann/my-site-generator/content/blog'

# AI phrases to remove or replace
AI_PATTERNS = [
    (r"This topic represents an important consideration for manufacturers seeking to improve their operations through automation\. Understanding the fundamentals helps inform better decisions\.", ""),
    (r"Several fundamental concepts underpin this area:", "Here's what you need to know:"),
    (r"Organizations that succeed with this approach typically:", "What works:"),
    (r"If you're considering this for your operation:", "Here's how to get started:"),
    (r"Manufacturers should weigh both the benefits and considerations:", "The tradeoffs:"),
    (r"The latest developments in AI and automation continue to reshape manufacturing\.", ""),
    (r"Industry analysts note that this development represents a significant step forward for manufacturing automation\. The integration of artificial intelligence with traditional automation technologies is accelerating across sectors\.", ""),
    (r"\*\*Process understanding\*\* - knowing your current state and requirements", "**Know your process** - document what you're doing now and what needs to change"),
    (r"\*\*Technology options\*\* - available solutions and their capabilities", "**Pick the right tech** - match equipment to your actual requirements"),
    (r"\*\*Implementation factors\*\* - what it takes to deploy successfully", "**Plan the rollout** - budget time for debugging and training"),
    (r"\*\*Performance measurement\*\* - how to evaluate results", "**Track results** - measure before and after"),
    (r"\*\*Continuous improvement\*\* - ongoing optimization and enhancement", "**Keep improving** - automation is never 'done'"),
]

# Generic benefits to make more specific
GENERIC_BENEFITS = [
    ("Improved efficiency and productivity", "Faster cycle times and less rework"),
    ("Enhanced quality and consistency", "Fewer defects, tighter tolerances"),
    ("Better data and visibility", "Real-time dashboards showing actual vs. target"),
    ("Reduced costs over time", "Lower cost-per-part after payback"),
]

def fix_description(frontmatter, body):
    """Expand short descriptions using content"""
    desc = frontmatter.get('description', '')
    if len(desc) >= 120:
        return desc

    # Extract first meaningful paragraph from body
    lines = body.strip().split('\n')
    for line in lines:
        line = line.strip()
        # Skip headers, empty lines, and very short lines
        if line.startswith('#') or line.startswith('-') or line.startswith('*'):
            continue
        if len(line) < 50:
            continue
        # Remove markdown links
        clean_line = re.sub(r'\[([^\]]+)\]\([^\)]+\)', r'\1', line)
        if len(clean_line) >= 120:
            # Truncate to 155 chars at word boundary
            if len(clean_line) > 155:
                truncated = clean_line[:155].rsplit(' ', 1)[0]
                return truncated + '.'
            return clean_line

    # If we couldn't find a good sentence, expand the existing description
    if desc and len(desc) < 120:
        # Add context based on common patterns
        title = frontmatter.get('title', '')
        category = frontmatter.get('category', '')

        expanded = desc
        if 'automation' in title.lower() or 'automation' in desc.lower():
            expanded = f"{desc} Learn practical approaches for manufacturing applications."
        elif 'robot' in title.lower():
            expanded = f"{desc} Implementation guidance for industrial robotics."
        else:
            expanded = f"{desc} Practical guidance for manufacturing automation."

        return expanded[:160]

    return desc

def fix_title(title):
    """Shorten titles over 60 chars"""
    if len(title) <= 60:
        return title

    # Common patterns to shorten
    title = title.replace(' - Robots, Presses, Conveyors, and Vision Systems', '')
    title = title.replace(' and How Does It Improve Manufacturing Productivity', '')
    title = title.replace(' in Manufacturing', '')
    title = title.replace(' for Manufacturing', '')

    # If still too long, truncate at word boundary
    if len(title) > 60:
        # Find a good break point
        truncated = title[:57].rsplit(' ', 1)[0]
        return truncated

    return title

def humanize_content(content):
    """Remove obvious AI patterns"""
    for pattern, replacement in AI_PATTERNS:
        content = re.sub(pattern, replacement, content, flags=re.MULTILINE)

    # Fix generic benefits
    for generic, specific in GENERIC_BENEFITS:
        content = content.replace(generic, specific)

    # Remove empty lines created by pattern removal
    content = re.sub(r'\n\n\n+', '\n\n', content)

    return content

def process_file(filepath):
    """Process a single markdown file"""
    with open(filepath, 'r') as f:
        content = f.read()

    if not content.startswith('---'):
        return False

    parts = content.split('---', 2)
    if len(parts) < 3:
        return False

    try:
        frontmatter = yaml.safe_load(parts[1])
    except:
        return False

    body = parts[2]
    original_content = content

    # Fix description
    old_desc = frontmatter.get('description', '')
    new_desc = fix_description(frontmatter, body)
    if new_desc != old_desc:
        frontmatter['description'] = new_desc

    # Fix title
    old_title = frontmatter.get('title', '')
    new_title = fix_title(old_title)
    if new_title != old_title:
        frontmatter['title'] = new_title

    # Humanize content
    new_body = humanize_content(body)

    # Rebuild the file
    new_content = '---\n' + yaml.dump(frontmatter, default_flow_style=False, allow_unicode=True, sort_keys=False) + '---' + new_body

    if new_content != original_content:
        with open(filepath, 'w') as f:
            f.write(new_content)
        return True

    return False

def main():
    modified = 0
    total = 0

    for filename in os.listdir(CONTENT_DIR):
        if not filename.endswith('.md'):
            continue

        filepath = os.path.join(CONTENT_DIR, filename)
        total += 1

        if process_file(filepath):
            modified += 1
            print(f"  Modified: {filename}")

    print(f"\nProcessed {total} files, modified {modified}")

if __name__ == '__main__':
    main()
