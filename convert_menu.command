#!/bin/bash
# convert_menu.command
# Double-click this file in Finder to open an interactive GIF converter menu.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

clear
echo "============================================"
echo "  🎬 Video → GIF  |  Interactive Converter"
echo "============================================"
echo ""
echo "  This tool converts .mp4 and .mov videos"
echo "  to animated GIFs."
echo ""
echo "  OPTIONS:"
echo "  [1] Quick convert       (default settings)"
echo "  [2] Custom convert      (fps, resize, trim)"
echo "  [3] Help / Examples"
echo "  [4] Exit"
echo ""
read -p "Choose an option (1-4): " CHOICE

case $CHOICE in

# ── Quick Convert ──────────────────────────────────────────────────────────
1)
    echo ""
    read -p "Enter video filename (or full path): " INPUT
    echo ""
    echo "Converting with default settings (12 fps, original size)..."
    echo ""
    python3 "$SCRIPT_DIR/video_to_gif.py" "$INPUT"
    ;;

# ── Custom Convert ─────────────────────────────────────────────────────────
2)
    echo ""
    read -p "Enter video filename (or full path): " INPUT
    read -p "Output GIF filename? (Enter to use same name as input): " OUTPUT
    read -p "FPS? (Enter for default 12): " FPS
    read -p "Resize width in pixels? (Enter to keep original): " WIDTH
    read -p "Start time in seconds? (Enter for beginning): " START
    read -p "End time in seconds? (Enter for full video): " END

    ARGS="$INPUT"
    [ -n "$OUTPUT" ] && ARGS="$ARGS -o $OUTPUT"
    [ -n "$FPS" ]    && ARGS="$ARGS --fps $FPS"
    [ -n "$WIDTH" ]  && ARGS="$ARGS --width $WIDTH"
    [ -n "$START" ]  && ARGS="$ARGS --start $START"
    [ -n "$END" ]    && ARGS="$ARGS --end $END"

    echo ""
    echo "Running: python3 video_to_gif.py $ARGS"
    echo ""
    python3 "$SCRIPT_DIR/video_to_gif.py" $ARGS
    ;;

# ── Help ───────────────────────────────────────────────────────────────────
3)
    echo ""
    echo "--------------------------------------------"
    echo "  HELP & EXAMPLES"
    echo "--------------------------------------------"
    echo ""
    echo "  QUICK CONVERT"
    echo "  Converts your video using defaults:"
    echo "  - 12 fps"
    echo "  - Original resolution"
    echo "  - Full video length"
    echo "  Output saved next to your video file."
    echo ""
    echo "  CUSTOM CONVERT OPTIONS"
    echo ""
    echo "  FPS (frames per second)"
    echo "    Lower = smaller file, choppier motion"
    echo "    Higher = smoother, but bigger file"
    echo "    Recommended: 8–15"
    echo ""
    echo "  Resize width"
    echo "    Shrinks video to this pixel width."
    echo "    Aspect ratio is preserved automatically."
    echo "    Example: 480  →  480×270 for a 16:9 video"
    echo ""
    echo "  Start / End time"
    echo "    Trim the video before converting."
    echo "    Example: start=5, end=15  →  10-second GIF"
    echo ""
    echo "  TIPS FOR SMALLER GIF FILES"
    echo "    • Use --fps 8 or 10"
    echo "    • Use --width 480 or smaller"
    echo "    • Trim to only the clip you need"
    echo ""
    echo "--------------------------------------------"
    ;;

# ── Exit ───────────────────────────────────────────────────────────────────
4)
    echo ""
    echo "Goodbye!"
    exit 0
    ;;

*)
    echo ""
    echo "Invalid option. Please run the script again."
    ;;
esac

echo ""
read -p "Press Enter to close..."
