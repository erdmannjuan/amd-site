#!/usr/bin/env python3
from PIL import Image
import os

SOURCE_DIR = "/Users/juan_erdmann/my-site-generator/static/images/customers"
OUTPUT_DIR = "/Users/juan_erdmann/my-site-generator/static/images/logos-white"
TARGET_HEIGHT = 84  # 3x for retina displays (displayed at 28px)

os.makedirs(OUTPUT_DIR, exist_ok=True)

# Name mapping for clean filenames
name_map = {
    "2880px-Tenneco_logo.svg.png": "tenneco.png",
    "aam-logo.png": "aam.png",
    "ABCTechnologies-logo-770x400.png": "abctechnologies.png",
    "ARBURG-Logo_sRGB.png": "arburg.png",
    "ATS-Corporation-Logo-2024.png": "ats-automation.png",
    "BBS_logo_RGB_sm.webp": "bbs.png",
    "BorgWarner_logo_logotype.png": "borgwarner.png",
    "Bosch-Logo.png": "bosch.png",
    "Brose.svg.png": "brose.png",
    "BTicino_logo.svg.png": "bticino.png",
    "Eaton_Corporation_logo.svg.png": "eaton.png",
    "Faurecia_Logo.png": "faurecia.png",
    "Flex-n-gate_logo.png": "flex-n-gate.png",
    "gabriel-3-logo-png-transparent.png": "gabriel.png",
    "Grammer_logo.svg.png": "grammer.png",
    "hella-2-logo-png-transparent.png": "hella.png",
    "Hitachi-Logo.png": "hitachi.png",
    "imi-norgren_white-bg.png": "imi-norgren.png",
    "kaeser-kompressoren-logo-png-transparent.png": "kaeser.png",
    "Kostal_logo.svg.png": "kostal.png",
    "Logotipo_Mabe.svg.png": "mabe.png",
    "mazda-logo-0.png": "mazda.png",
    "Meritor-logo.png": "meritor.png",
    "Mitutoyo_company_logo.svg.png": "mitutoyo.png",
    "Monroe.png": "monroe.png",
    "Panasonic-logo.png": "panasonic.png",
    "Pferd-Logo.png": "pferd.png",
    "Plastikon_Logo-1024x398.webp": "plastikon.png",
    "SensataLogo.png": "sensata.png",
    "Shape-Corp-logo-w-Effects-1941162176.png": "shape.png",
    "Texas-Instruments-Logo-1959.png": "texas-instruments.png",
    "Thyssenkrupp_AG_Logo_2015.svg.png": "thyssenkrupp.png",
    "Valeo_Logo.svg.png": "valeo.png",
    "Vibracosutic_Logo.webp": "vibracoustic.png",
    "woco.png": "woco.png",
}

for source_name, output_name in name_map.items():
    filepath = os.path.join(SOURCE_DIR, source_name)
    if not os.path.exists(filepath):
        print(f"✗ {source_name}: not found")
        continue

    try:
        img = Image.open(filepath)

        if img.mode != 'RGBA':
            img = img.convert('RGBA')

        # Crop to content
        bbox = img.getbbox()
        if bbox:
            img = img.crop(bbox)

        # Resize to target height
        aspect = img.width / img.height
        new_width = int(TARGET_HEIGHT * aspect)
        img = img.resize((new_width, TARGET_HEIGHT), Image.Resampling.LANCZOS)

        # Convert to white
        pixels = img.load()
        for y in range(img.height):
            for x in range(img.width):
                r, g, b, a = pixels[x, y]
                if a > 0:
                    pixels[x, y] = (255, 255, 255, a)

        output_path = os.path.join(OUTPUT_DIR, output_name)
        img.save(output_path, 'PNG', optimize=True)
        print(f"✓ {output_name}: {new_width}x{TARGET_HEIGHT}")

    except Exception as e:
        print(f"✗ {source_name}: {e}")

print("\nDone!")
