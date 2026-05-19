#!/bin/bash
# drag_and_drop_convert.command
# Drag a .mp4 or .mov file onto this icon in Finder to convert it to GIF.
# The output GIF is saved in the SAME FOLDER as your video file.

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
    echo "  in Finder to convert it to a GIF."
    echo ""
    echo "  The output GIF is saved in the SAME FOLDER"
    echo "  as your original video file."
    echo ""
    echo "  For advanced options (fps, resize, trim),"
    echo "  use convert_menu.command instead."
    echo ""
    read -p "Press Enter to close..."
    exit 0
fi

# Resolve absolute path and output location next to the input file
INPUT="$(cd "$(dirname "$INPUT")" && pwd)/$(basename "$INPUT")"
INPUT_DIR="$(dirname "$INPUT")"
INPUT_NAME="$(basename "${INPUT%.*}")"
OUTPUT="$INPUT_DIR/$INPUT_NAME.gif"

echo "============================================"
echo "  🎬 Video → GIF  |  Drag & Drop Converter"
echo "============================================"
echo ""
echo "Input  : $INPUT"
echo "Output : $OUTPUT"
echo ""

# Ask for optional settings
read -p "Resize width in pixels? (press Enter to keep original): " WIDTH
read -p "FPS? (press Enter for default 12): " FPS

WIDTH_ARG=""
FPS_ARG=""
[ -n "$WIDTH" ] && WIDTH_ARG="--width $WIDTH"
[ -n "$FPS" ]   && FPS_ARG="--fps $FPS"

echo ""
echo "Converting... this may take a moment."
echo ""

python3 "$SCRIPT_DIR/video_to_gif.py" "$INPUT" -o "$OUTPUT" $WIDTH_ARG $FPS_ARG

echo ""
read -p "Press Enter to close..."
