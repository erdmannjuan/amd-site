#!/usr/bin/env python3
from PIL import Image
import os
import glob

LOGOS_DIR = "/Users/juan_erdmann/my-site-generator/static/images/logos-white"
TARGET_HEIGHT = 28  # Final height after cropping

for filepath in glob.glob(f"{LOGOS_DIR}/*.png"):
    filename = os.path.basename(filepath)
    
    try:
        img = Image.open(filepath)
        
        # Convert to RGBA if needed
        if img.mode != 'RGBA':
            img = img.convert('RGBA')
        
        # Get the bounding box of non-transparent content
        bbox = img.getbbox()
        
        if bbox:
            # Crop to content
            img = img.crop(bbox)
            
            # Resize to target height maintaining aspect ratio
            aspect = img.width / img.height
            new_width = int(TARGET_HEIGHT * aspect)
            img = img.resize((new_width, TARGET_HEIGHT), Image.Resampling.LANCZOS)
            
            # Save
            img.save(filepath, 'PNG', optimize=True)
            print(f"✓ {filename}: cropped to {new_width}x{TARGET_HEIGHT}")
        else:
            print(f"✗ {filename}: no content found")
            
    except Exception as e:
        print(f"✗ {filename}: {e}")

print("\nDone! All logos cropped and resized.")
