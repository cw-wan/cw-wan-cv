#!/usr/bin/env python3
"""Trim transparent or solid-color logo margins without resizing the artwork."""

from __future__ import annotations

import argparse
from pathlib import Path

from PIL import Image, ImageChops, ImageColor, ImageOps


def prepare_logo(
    image: Image.Image,
    *,
    square: bool = False,
    padding: int = 0,
    background: str = "auto",
    tolerance: int = 8,
    alpha_threshold: int = 0,
) -> tuple[Image.Image, tuple[int, int, int, int]]:
    """Return the cropped RGBA image and its original, exclusive-right/bottom box.

    Auto uses alpha for transparent images and white for fully opaque images.
    A color such as '#ffffff' can explicitly select solid-background detection.
    Only canvas margins change: content colors, resolution and alpha are retained.
    """
    if padding < 0:
        raise ValueError("Padding must be nonnegative.")
    if not 0 <= tolerance <= 255 or not 0 <= alpha_threshold <= 254:
        raise ValueError("Tolerance must be 0..255 and alpha threshold 0..254.")

    rgba = ImageOps.exif_transpose(image).convert("RGBA")
    alpha = rgba.getchannel("A")
    visible = alpha.point(lambda value: 255 if value > alpha_threshold else 0)
    if background == "auto":
        background = "transparent" if alpha.getextrema()[0] < 255 else "#ffffff"

    if background != "transparent":
        color = ImageColor.getrgb(background)
        if len(color) != 3:
            raise ValueError("Background must be an opaque RGB color.")
        difference = ImageChops.difference(
            rgba.convert("RGB"), Image.new("RGB", rgba.size, color)
        )
        red, green, blue = difference.split()
        distance = ImageChops.lighter(ImageChops.lighter(red, green), blue)
        foreground = distance.point(lambda value: 255 if value > tolerance else 0)
        visible = ImageChops.multiply(visible, foreground)

    bounds = visible.getbbox()
    if bounds is None:
        raise ValueError("No visible artwork found; check the background and thresholds.")

    artwork = rgba.crop(bounds)
    width, height = artwork.size
    if square:
        width = height = max(width, height)
    canvas = Image.new("RGBA", (width + 2 * padding, height + 2 * padding))
    offset = ((canvas.width - artwork.width) // 2, (canvas.height - artwork.height) // 2)
    # Copy RGBA directly: an alpha mask here would apply transparency twice.
    canvas.paste(artwork, offset)
    return canvas, bounds


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("source", type=Path, help="Source raster image; kept unchanged.")
    parser.add_argument("output", type=Path, help="New PNG path.")
    parser.add_argument("--square", action="store_true", help="Center on a square canvas.")
    parser.add_argument("--padding", type=int, default=0, help="Transparent padding in pixels.")
    parser.add_argument(
        "--background", default="auto",
        help="auto (default), transparent, or an opaque color such as white or #ffffff.",
    )
    parser.add_argument("--tolerance", type=int, default=8, help="Color tolerance, 0..255.")
    parser.add_argument("--alpha-threshold", type=int, default=0, help="Alpha cutoff, 0..254.")
    args = parser.parse_args()
    if args.output.suffix.lower() != ".png":
        parser.error("Output must use .png to preserve transparency without compression loss.")
    try:
        if args.source.resolve() == args.output.resolve() or (
            args.output.exists() and args.source.samefile(args.output)
        ):
            parser.error("Source and output must differ so the original is preserved.")
        with Image.open(args.source) as source:
            source_size = ImageOps.exif_transpose(source).size
            result, bounds = prepare_logo(
                source, square=args.square, padding=args.padding,
                background=args.background, tolerance=args.tolerance,
                alpha_threshold=args.alpha_threshold,
            )
        args.output.parent.mkdir(parents=True, exist_ok=True)
        result.save(args.output, format="PNG", optimize=True)
    except (OSError, ValueError) as error:
        parser.error(str(error))
    left, top, right, bottom = bounds
    print(f"Source: {source_size[0]} x {source_size[1]}")
    print(f"Artwork: {right - left} x {bottom - top}; bounds: {bounds}")
    print(f"Output: {result.width} x {result.height} -> {args.output}")


if __name__ == "__main__":
    main()
