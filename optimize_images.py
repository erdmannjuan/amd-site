#!/usr/bin/env python3
"""
Image Optimization Script
Compresses and resizes images for faster web loading.
"""

import os
import sys
from pathlib import Path
from PIL import Image

# Configuration
IMAGES_DIR = Path(__file__).parent / 'static' / 'images'
MAX_WIDTH = 1600  # Max width for large images
JPEG_QUALITY = 80  # Quality for JPEG compression (1-100)
PNG_OPTIMIZE = True

# Size thresholds
THUMBNAIL_WIDTH = 400
MEDIUM_WIDTH = 800
LARGE_WIDTH = 1600


def get_file_size(path):
    """Get file size in KB"""
    return os.path.getsize(path) / 1024


def optimize_image(image_path, max_width=MAX_WIDTH, quality=JPEG_QUALITY):
    """Optimize a single image"""
    path = Path(image_path)

    if path.suffix.lower() not in ['.jpg', '.jpeg', '.png', '.webp']:
        return None

    original_size = get_file_size(path)

    try:
        with Image.open(path) as img:
            # Convert RGBA to RGB for JPEG
            if img.mode == 'RGBA' and path.suffix.lower() in ['.jpg', '.jpeg']:
                img = img.convert('RGB')

            # Resize if larger than max width
            if img.width > max_width:
                ratio = max_width / img.width
                new_height = int(img.height * ratio)
                img = img.resize((max_width, new_height), Image.LANCZOS)

            # Save optimized image
            if path.suffix.lower() in ['.jpg', '.jpeg']:
                img.save(path, 'JPEG', quality=quality, optimize=True)
            elif path.suffix.lower() == '.png':
                img.save(path, 'PNG', optimize=PNG_OPTIMIZE)
            elif path.suffix.lower() == '.webp':
                img.save(path, 'WEBP', quality=quality)

        new_size = get_file_size(path)
        savings = original_size - new_size
        percent = (savings / original_size * 100) if original_size > 0 else 0

        return {
            'file': path.name,
            'original': original_size,
            'optimized': new_size,
            'savings': savings,
            'percent': percent
        }

    except Exception as e:
        print(f"  Error processing {path.name}: {e}")
        return None


def create_responsive_versions(image_path):
    """Create multiple sizes of an image for responsive loading"""
    path = Path(image_path)

    if path.suffix.lower() not in ['.jpg', '.jpeg', '.png', '.webp']:
        return

    stem = path.stem
    suffix = path.suffix
    parent = path.parent

    sizes = [
        ('sm', THUMBNAIL_WIDTH),
        ('md', MEDIUM_WIDTH),
        ('lg', LARGE_WIDTH),
    ]

    try:
        with Image.open(path) as img:
            original_width = img.width

            for size_name, max_width in sizes:
                if original_width <= max_width:
                    continue

                ratio = max_width / original_width
                new_height = int(img.height * ratio)
                resized = img.resize((max_width, new_height), Image.LANCZOS)

                # Convert RGBA to RGB for JPEG
                if resized.mode == 'RGBA' and suffix.lower() in ['.jpg', '.jpeg']:
                    resized = resized.convert('RGB')

                new_path = parent / f"{stem}-{size_name}{suffix}"

                if suffix.lower() in ['.jpg', '.jpeg']:
                    resized.save(new_path, 'JPEG', quality=JPEG_QUALITY, optimize=True)
                elif suffix.lower() == '.png':
                    resized.save(new_path, 'PNG', optimize=PNG_OPTIMIZE)
                elif suffix.lower() == '.webp':
                    resized.save(new_path, 'WEBP', quality=JPEG_QUALITY)

                print(f"  Created: {new_path.name} ({max_width}px)")

    except Exception as e:
        print(f"  Error creating responsive versions for {path.name}: {e}")


def optimize_all_images(create_responsive=False):
    """Optimize all images in the images directory"""
    if not IMAGES_DIR.exists():
        print(f"Images directory not found: {IMAGES_DIR}")
        return

    print(f"\n🖼️  Optimizing images in {IMAGES_DIR}\n")

    image_files = []
    for ext in ['*.jpg', '*.jpeg', '*.png', '*.webp', '*.JPG', '*.JPEG', '*.PNG', '*.WEBP']:
        image_files.extend(IMAGES_DIR.rglob(ext))

    # Filter out already-resized versions
    image_files = [f for f in image_files if not any(f.stem.endswith(s) for s in ['-sm', '-md', '-lg'])]

    if not image_files:
        print("  No images found to optimize.")
        print("  Add images to: static/images/")
        return

    print(f"  Found {len(image_files)} image(s)\n")

    total_savings = 0
    results = []

    for image_path in image_files:
        print(f"  Processing: {image_path.name}")
        result = optimize_image(image_path)

        if result:
            results.append(result)
            total_savings += result['savings']
            print(f"    {result['original']:.1f}KB → {result['optimized']:.1f}KB ({result['percent']:.1f}% smaller)")

        if create_responsive:
            create_responsive_versions(image_path)

    print(f"\n✅ Optimization complete!")
    print(f"   Total savings: {total_savings:.1f}KB")

    if results:
        avg_reduction = sum(r['percent'] for r in results) / len(results)
        print(f"   Average reduction: {avg_reduction:.1f}%")


if __name__ == '__main__':
    # Check for --responsive flag
    create_responsive = '--responsive' in sys.argv

    if '--help' in sys.argv:
        print("""
Image Optimization Script

Usage:
  python optimize_images.py              Optimize all images
  python optimize_images.py --responsive Also create sm/md/lg versions

Options:
  --responsive  Create multiple sizes for responsive images
  --help        Show this help message
""")
    else:
        optimize_all_images(create_responsive=create_responsive)
