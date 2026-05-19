#!/bin/bash
# convert_menu.command

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear
echo "============================================"
echo "  🎬 Video → GIF  |  Interactive Converter"
echo "============================================"
echo ""
echo "  [1] Quick convert       (default settings)"
echo "  [2] Custom convert      (fps, resize, trim)"
echo "  [3] Help"
echo "  [4] Exit"
echo ""
read -p "Choose an option (1-4): " CHOICE

case $CHOICE in

1)
    echo ""
    echo "Tip: Just type the filename if the video is in the Gif Converter folder."
    echo "     e.g.  tiktok_4.mp4"
    echo ""
    read -p "Enter video filename or full path: " INPUT

    # Strip quotes and whitespace
    INPUT=$(echo "$INPUT" | sed "s/^'//;s/'$//;s/^\"/\"/;s/\"$//;s/^ //;s/ $//")
    # Expand ~
    INPUT="${INPUT/#\~/$HOME}"
    # If no slash, assume it's in the script folder
    if [[ "$INPUT" != */* ]]; then
        INPUT="$SCRIPT_DIR/$INPUT"
    fi

    OUTPUT="${INPUT%.*}.gif"

    echo ""
    echo "Input  : $INPUT"
    echo "Output : $OUTPUT"
    echo ""

    python3 "$SCRIPT_DIR/video_to_gif.py" "$INPUT" -o "$OUTPUT"
    ;;

2)
    echo ""
    read -p "Enter video filename or full path: " INPUT

    INPUT=$(echo "$INPUT" | sed "s/^'//;s/'$//;s/^\"/\"/;s/\"$//;s/^ //;s/ $//")
    INPUT="${INPUT/#\~/$HOME}"
    if [[ "$INPUT" != */* ]]; then
        INPUT="$SCRIPT_DIR/$INPUT"
    fi

    DEFAULT_OUTPUT="${INPUT%.*}.gif"

    echo ""
    read -p "Output path? (Enter for default next to video): " OUTPUT
    read -p "FPS? (Enter for 12): " FPS
    read -p "Resize width px? (Enter to keep original): " WIDTH
    read -p "Start time seconds? (Enter for beginning): " START
    read -p "End time seconds? (Enter for full video): " END

    [ -z "$OUTPUT" ] && OUTPUT="$DEFAULT_OUTPUT"
    OUTPUT=$(echo "$OUTPUT" | sed "s/^'//;s/'$//")
    OUTPUT="${OUTPUT/#\~/$HOME}"

    ARGS=("$INPUT" -o "$OUTPUT")
    [ -n "$FPS" ]   && ARGS+=("--fps"   "$FPS")
    [ -n "$WIDTH" ] && ARGS+=("--width" "$WIDTH")
    [ -n "$START" ] && ARGS+=("--start" "$START")
    [ -n "$END" ]   && ARGS+=("--end"   "$END")

    echo ""
    echo "Input  : $INPUT"
    echo "Output : $OUTPUT"
    echo ""
    python3 "$SCRIPT_DIR/video_to_gif.py" "${ARGS[@]}"
    ;;

3)
    echo ""
    echo "  Filename only:  tiktok_4.mp4   (video must be in Gif Converter folder)"
    echo "  Full path:      ~/Desktop/clip.mp4"
    echo "  FPS:            8-15 recommended (lower = smaller file)"
    echo "  Width:          480 is good for web (keeps aspect ratio)"
    echo "  Trim:           start=5 end=15 gives a 10-second GIF"
    echo ""
    ;;

4)
    exit 0
    ;;
esac

echo ""
read -p "Press Enter to close..."
