#!/bin/bash
# drag_and_drop_convert.command
# Drag a .mp4 or .mov file onto this script in Finder to convert it to GIF.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INPUT="$1"

# If no file was dragged onto it, show instructions
if [ -z "$INPUT" ]; then
    echo "============================================"
    echo "  🎬 Video → GIF  |  Drag & Drop Converter"
    echo "============================================"
    echo ""
    echo "  HOW TO USE:"
    echo "  Drag a .mp4 or .mov file onto this icon"
    echo "  in Finder, and it will convert it to GIF."
    echo ""
    echo "  The output GIF is saved in the same folder"
    echo "  as your video file."
    echo ""
    echo "  To use advanced options (fps, resize, trim),"
    echo "  run: convert_menu.command instead."
    echo ""
    read -p "Press Enter to close..."
    exit 0
fi

echo "============================================"
echo "  🎬 Video → GIF  |  Drag & Drop Converter"
echo "============================================"
echo ""
echo "Input : $INPUT"
echo ""

# Ask for optional width
read -p "Resize width in pixels? (press Enter to keep original): " WIDTH
read -p "FPS? (press Enter for default 12): " FPS

WIDTH_ARG=""
FPS_ARG=""
[ -n "$WIDTH" ] && WIDTH_ARG="--width $WIDTH"
[ -n "$FPS" ]   && FPS_ARG="--fps $FPS"

echo ""
echo "Converting... this may take a moment."
echo ""

python3 "$SCRIPT_DIR/video_to_gif.py" "$INPUT" $WIDTH_ARG $FPS_ARG

echo ""
read -p "Press Enter to close..."
