#!/usr/bin/env python3
"""
Generate placeholder images with dotted deep blue background and unique numbers.
Each image has a reference number for easy identification by designers.
"""

import os

# Placeholder definitions: (filename, number, width, height, description)
PLACEHOLDERS = [
    # Hero images
    ("placeholder-hero-home.svg", "001", 1920, 800, "Homepage hero background"),
    ("placeholder-hero-capabilities.svg", "002", 1920, 600, "Capabilities landing hero"),
    ("placeholder-hero-industries.svg", "003", 1920, 600, "Industries landing hero"),
    ("placeholder-hero-about.svg", "004", 1920, 600, "About page hero"),
    ("placeholder-hero-contact.svg", "005", 1920, 600, "Contact page hero"),
    ("placeholder-hero-blog.svg", "006", 1920, 600, "Blog landing hero"),

    # Capability images
    ("placeholder-capability-robotic-cells.svg", "010", 800, 600, "Robotic cells capability"),
    ("placeholder-capability-welding.svg", "011", 800, 600, "Welding automation capability"),
    ("placeholder-capability-test-systems.svg", "012", 800, 600, "Test systems capability"),
    ("placeholder-capability-assembly.svg", "013", 800, 600, "Assembly machines capability"),
    ("placeholder-capability-custom.svg", "014", 800, 600, "Custom automation capability"),
    ("placeholder-capability-material-handling.svg", "015", 800, 600, "Material handling capability"),

    # Industry images
    ("placeholder-industry-automotive.svg", "020", 800, 600, "Automotive industry"),
    ("placeholder-industry-medical.svg", "021", 800, 600, "Medical devices industry"),
    ("placeholder-industry-consumer.svg", "022", 800, 600, "Consumer products industry"),
    ("placeholder-industry-electronics.svg", "023", 800, 600, "Electronics industry"),
    ("placeholder-industry-aerospace.svg", "024", 800, 600, "Aerospace industry"),
    ("placeholder-industry-food.svg", "025", 800, 600, "Food & beverage industry"),

    # Card/thumbnail images
    ("placeholder-card-1.svg", "030", 400, 300, "Card image 1"),
    ("placeholder-card-2.svg", "031", 400, 300, "Card image 2"),
    ("placeholder-card-3.svg", "032", 400, 300, "Card image 3"),
    ("placeholder-card-4.svg", "033", 400, 300, "Card image 4"),
    ("placeholder-card-5.svg", "034", 400, 300, "Card image 5"),
    ("placeholder-card-6.svg", "035", 400, 300, "Card image 6"),

    # About page images
    ("placeholder-about-team.svg", "040", 800, 500, "About page team photo"),
    ("placeholder-about-facility.svg", "041", 800, 500, "About page facility photo"),

    # Blog post images
    ("placeholder-blog-1.svg", "050", 800, 450, "Blog post featured image 1"),
    ("placeholder-blog-2.svg", "051", 800, 450, "Blog post featured image 2"),
    ("placeholder-blog-3.svg", "052", 800, 450, "Blog post featured image 3"),

    # Icon placeholders (square)
    ("placeholder-icon-1.svg", "060", 120, 120, "Icon placeholder 1"),
    ("placeholder-icon-2.svg", "061", 120, 120, "Icon placeholder 2"),
    ("placeholder-icon-3.svg", "062", 120, 120, "Icon placeholder 3"),
    ("placeholder-icon-4.svg", "063", 120, 120, "Icon placeholder 4"),
    ("placeholder-icon-5.svg", "064", 120, 120, "Icon placeholder 5"),
    ("placeholder-icon-6.svg", "065", 120, 120, "Icon placeholder 6"),
]

def generate_svg(number, width, height, description):
    """Generate SVG placeholder with dotted deep blue background."""
    # Deep blue color
    bg_color = "#0d3b66"
    dot_color = "#1a5a96"
    text_color = "#ffffff"

    svg = f'''<svg xmlns="http://www.w3.org/2000/svg" width="{width}" height="{height}" viewBox="0 0 {width} {height}">
  <defs>
    <pattern id="dots-{number}" x="0" y="0" width="20" height="20" patternUnits="userSpaceOnUse">
      <circle cx="2" cy="2" r="1.5" fill="{dot_color}"/>
    </pattern>
  </defs>
  <rect width="100%" height="100%" fill="{bg_color}"/>
  <rect width="100%" height="100%" fill="url(#dots-{number})"/>
  <text x="50%" y="45%" dominant-baseline="middle" text-anchor="middle"
        font-family="Arial, sans-serif" font-size="{min(width, height) // 4}" font-weight="bold" fill="{text_color}">
    #{number}
  </text>
  <text x="50%" y="60%" dominant-baseline="middle" text-anchor="middle"
        font-family="Arial, sans-serif" font-size="{min(width, height) // 12}" fill="{text_color}" opacity="0.7">
    {width}x{height}
  </text>
</svg>'''
    return svg


def main():
    output_dir = "static/images"
    os.makedirs(output_dir, exist_ok=True)

    print("Generating placeholder images...")
    print("=" * 60)

    manifest = []

    for filename, number, width, height, description in PLACEHOLDERS:
        svg_content = generate_svg(number, width, height, description)
        filepath = os.path.join(output_dir, filename)

        with open(filepath, 'w') as f:
            f.write(svg_content)

        manifest.append({
            "number": number,
            "filename": filename,
            "dimensions": f"{width}x{height}",
            "description": description
        })

        print(f"  #{number}: {filename} ({width}x{height}) - {description}")

    # Generate manifest file for designers
    manifest_path = os.path.join(output_dir, "PLACEHOLDER_MANIFEST.md")
    with open(manifest_path, 'w') as f:
        f.write("# Placeholder Image Manifest\n\n")
        f.write("Replace these placeholder images with final designs.\n\n")
        f.write("| # | Filename | Dimensions | Description |\n")
        f.write("|---|----------|------------|-------------|\n")
        for item in manifest:
            f.write(f"| {item['number']} | {item['filename']} | {item['dimensions']} | {item['description']} |\n")

    print("=" * 60)
    print(f"Generated {len(PLACEHOLDERS)} placeholder images")
    print(f"Manifest saved to: {manifest_path}")


if __name__ == "__main__":
    main()
