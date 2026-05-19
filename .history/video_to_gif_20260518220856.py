#!/usr/bin/env python3
"""
video_to_gif.py
Convert an .mp4 or .mov video file to an animated GIF.

Usage:
    python video_to_gif.py input.mp4
    python video_to_gif.py input.mov -o output.gif
    python video_to_gif.py input.mp4 --fps 15 --width 480 --start 5 --end 15
"""

import argparse
import sys
from pathlib import Path
from moviepy import VideoFileClip


def convert_to_gif(
    input_path: str,
    output_path: str | None = None,
    fps: int = 12,
    width: int | None = None,
    start: float | None = None,
    end: float | None = None,
) -> str:
    """
    Convert a video file to a GIF.

    Args:
        input_path: Path to the input .mp4 or .mov file.
        output_path: Path for the output .gif (default: same name as input).
        fps:         Frames per second for the GIF (default: 12).
        width:       Resize width in pixels, keeps aspect ratio (default: original).
        start:       Start time in seconds (default: beginning of video).
        end:         End time in seconds (default: end of video).

    Returns:
        The path to the saved GIF.
    """
    input_path = Path(input_path)
    if not input_path.exists():
        raise FileNotFoundError(f"Input file not found: {input_path}")

    suffix = input_path.suffix.lower()
    if suffix not in {".mp4", ".mov"}:
        raise ValueError(f"Unsupported format '{suffix}'. Use .mp4 or .mov.")

    # Default output path: same location, .gif extension
    if output_path is None:
        output_path = input_path.with_suffix(".gif")
    output_path = Path(output_path)

    print(f"Loading  : {input_path}")
    clip = VideoFileClip(str(input_path))

    # Trim clip if start/end specified
    if start is not None or end is not None:
        t_start = start or 0
        t_end   = end   or clip.duration
        clip = clip.subclipped(t_start, t_end)
        print(f"Trimmed  : {t_start:.1f}s → {t_end:.1f}s")

    # Resize if width specified
    if width is not None:
        clip = clip.resized(width=width)
        print(f"Resized  : width={width}px")

    print(f"Duration : {clip.duration:.1f}s  |  FPS: {fps}  |  Size: {clip.size}")
    print(f"Saving   : {output_path} ...")

    # Write GIF (moviepy 2.x uses imageio internally and no longer exposes opt)
    clip.write_gif(
        str(output_path),
        fps=fps,
        logger="bar",
    )

    clip.close()

    size_mb = output_path.stat().st_size / 1_048_576
    print(f"\n✅ Done! GIF saved to: {output_path}  ({size_mb:.2f} MB)")
    return str(output_path)


def main():
    parser = argparse.ArgumentParser(
        description="Convert an .mp4 or .mov video to an animated GIF."
    )
    parser.add_argument("input", help="Path to input video (.mp4 or .mov)")
    parser.add_argument("-o", "--output",  default=None, help="Output .gif path (default: same name as input)")
    parser.add_argument("--fps",   type=int,   default=12,   help="Frames per second (default: 12)")
    parser.add_argument("--width", type=int,   default=None, help="Resize width in pixels, keeps aspect ratio")
    parser.add_argument("--start", type=float, default=None, help="Start time in seconds")
    parser.add_argument("--end",   type=float, default=None, help="End time in seconds")

    args = parser.parse_args()

    try:
        convert_to_gif(
            input_path=args.input,
            output_path=args.output,
            fps=args.fps,
            width=args.width,
            start=args.start,
            end=args.end,
        )
    except (FileNotFoundError, ValueError) as e:
        print(f"Error: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
