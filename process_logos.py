#!/usr/bin/env python3
from PIL import Image
import os
import glob

SOURCE_DIR = "/Users/juan_erdmann/my-site-generator/static/images/customers"
OUTPUT_DIR = "/Users/juan_erdmann/my-site-generator/static/images/logos-white"
TARGET_HEIGHT = 28  # Small height for slim section

os.makedirs(OUTPUT_DIR, exist_ok=True)

# Mapping of source files to clean names
files = glob.glob(f"{SOURCE_DIR}/*.*")

for filepath in files:
    filename = os.path.basename(filepath)
    
    # Skip hidden files
    if filename.startswith('.'):
        continue
    
    try:
        # Open image
        img = Image.open(filepath)
        
        # Convert to RGBA if not already
        if img.mode != 'RGBA':
            img = img.convert('RGBA')
        
        # Get image data
        data = img.getdata()
        
        # Convert to white: make all non-transparent pixels white
        new_data = []
        for item in data:
            # If pixel is not fully transparent
            if item[3] > 30:  # Has some opacity
                # Make it white but keep original alpha
                new_data.append((255, 255, 255, item[3]))
            else:
                # Keep transparent pixels transparent
                new_data.append((0, 0, 0, 0))
        
        img.putdata(new_data)
        
        # Resize to target height maintaining aspect ratio
        aspect = img.width / img.height
        new_width = int(TARGET_HEIGHT * aspect)
        img = img.resize((new_width, TARGET_HEIGHT), Image.Resampling.LANCZOS)
        
        # Create clean output filename
        clean_name = filename.lower()
        clean_name = clean_name.replace('.svg.png', '.png')
        clean_name = clean_name.replace('.webp', '.png')
        clean_name = clean_name.replace(' ', '-')
        clean_name = clean_name.replace('_', '-')
        
        # Remove common suffixes
        for suffix in ['-logo-png-transparent', '-logo', '-logo-2024', '-corporation-logo', 
                       '-logo-w-effects-1941162176', '-kompressoren-logo-png-transparent',
                       '-2-logo-png-transparent', '-3-logo-png-transparent', '-white-bg',
                       '2880px-', '-770x400', '-1024x398', '-rgb-sm', '-logotype',
                       '-logo-0', '-1959', '-ag-logo-2015', '-company-logo']:
            clean_name = clean_name.replace(suffix, '')
        
        # Ensure .png extension
        if not clean_name.endswith('.png'):
            clean_name = os.path.splitext(clean_name)[0] + '.png'
        
        output_path = os.path.join(OUTPUT_DIR, clean_name)
        
        # Save optimized PNG
        img.save(output_path, 'PNG', optimize=True)
        print(f"✓ {filename} -> {clean_name}")
        
    except Exception as e:
        print(f"✗ {filename}: {e}")

print(f"\nProcessed logos saved to: {OUTPUT_DIR}")
