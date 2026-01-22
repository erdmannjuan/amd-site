#!/bin/bash
# ===========================================
# AMD AUTOMATION - IMAGE OPTIMIZATION SCRIPT
# Converts images to WebP format (<150KB) while maintaining clarity
# Requires: ImageMagick (brew install imagemagick) or cwebp (brew install webp)
# ===========================================

set -e

# Configuration
INPUT_DIR="${1:-./static/images}"
OUTPUT_DIR="${2:-./static/images/optimized}"
MAX_SIZE_KB=150
QUALITY=82
MAX_WIDTH=1600

echo "==========================================="
echo "AMD Automation Image Optimizer"
echo "==========================================="
echo "Input:  $INPUT_DIR"
echo "Output: $OUTPUT_DIR"
echo "Target: <${MAX_SIZE_KB}KB per image"
echo ""

# Create output directory
mkdir -p "$OUTPUT_DIR"

# Counter
TOTAL=0
CONVERTED=0
SKIPPED=0

# Process each image
find "$INPUT_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" \) | while read -r img; do
    TOTAL=$((TOTAL + 1))

    # Get relative path for output
    REL_PATH="${img#$INPUT_DIR/}"
    OUTPUT_PATH="$OUTPUT_DIR/${REL_PATH%.*}.webp"
    OUTPUT_SUBDIR=$(dirname "$OUTPUT_PATH")

    # Create subdirectory if needed
    mkdir -p "$OUTPUT_SUBDIR"

    # Get original size
    ORIG_SIZE=$(stat -f%z "$img" 2>/dev/null || stat -c%s "$img" 2>/dev/null)
    ORIG_SIZE_KB=$((ORIG_SIZE / 1024))

    echo -n "Processing: $REL_PATH (${ORIG_SIZE_KB}KB) -> "

    # Convert to WebP with quality optimization
    if command -v cwebp &> /dev/null; then
        # Use cwebp (better quality)
        cwebp -q $QUALITY -resize $MAX_WIDTH 0 -quiet "$img" -o "$OUTPUT_PATH" 2>/dev/null
    else
        # Fallback to ImageMagick
        convert "$img" -resize "${MAX_WIDTH}x>" -quality $QUALITY -define webp:lossless=false "$OUTPUT_PATH" 2>/dev/null
    fi

    # Check output size and re-compress if needed
    if [ -f "$OUTPUT_PATH" ]; then
        NEW_SIZE=$(stat -f%z "$OUTPUT_PATH" 2>/dev/null || stat -c%s "$OUTPUT_PATH" 2>/dev/null)
        NEW_SIZE_KB=$((NEW_SIZE / 1024))

        # If still too large, reduce quality
        if [ $NEW_SIZE_KB -gt $MAX_SIZE_KB ]; then
            ADJUSTED_QUALITY=65
            if command -v cwebp &> /dev/null; then
                cwebp -q $ADJUSTED_QUALITY -resize $MAX_WIDTH 0 -quiet "$img" -o "$OUTPUT_PATH" 2>/dev/null
            else
                convert "$img" -resize "${MAX_WIDTH}x>" -quality $ADJUSTED_QUALITY -define webp:lossless=false "$OUTPUT_PATH" 2>/dev/null
            fi
            NEW_SIZE=$(stat -f%z "$OUTPUT_PATH" 2>/dev/null || stat -c%s "$OUTPUT_PATH" 2>/dev/null)
            NEW_SIZE_KB=$((NEW_SIZE / 1024))
        fi

        SAVINGS=$((100 - (NEW_SIZE * 100 / ORIG_SIZE)))
        echo "${NEW_SIZE_KB}KB (${SAVINGS}% smaller)"
        CONVERTED=$((CONVERTED + 1))
    else
        echo "FAILED"
        SKIPPED=$((SKIPPED + 1))
    fi
done

echo ""
echo "==========================================="
echo "Optimization Complete"
echo "==========================================="
echo "Processed: $TOTAL images"
echo "Converted: $CONVERTED"
echo "Skipped:   $SKIPPED"
echo ""
echo "Next steps:"
echo "1. Review optimized images in $OUTPUT_DIR"
echo "2. Replace originals: cp -r $OUTPUT_DIR/* $INPUT_DIR/"
echo "3. Update templates to use .webp extensions"
