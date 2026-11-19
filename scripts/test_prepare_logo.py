"""Behavior checks for trimming without losing visible logo content."""

import os
from pathlib import Path
import subprocess
import sys
import tempfile
import unittest

from PIL import Image, ImageDraw

from prepare_logo import prepare_logo


class PrepareLogoTests(unittest.TestCase):
    def test_transparent_margins_and_antialiased_edge_are_preserved(self):
        source = Image.new("RGBA", (20, 14))
        ImageDraw.Draw(source).rectangle((4, 2, 14, 10), fill=(20, 80, 120, 255))
        source.putpixel((3, 6), (20, 80, 120, 1))
        source.putpixel((0, 0), (255, 0, 0, 0))
        result, bounds = prepare_logo(source)
        self.assertEqual(bounds, (3, 2, 15, 11))
        self.assertEqual(result.size, (12, 9))
        self.assertEqual(result.getpixel((0, 4)), (20, 80, 120, 1))
        self.assertEqual(source.size, (20, 14))

    def test_white_margin_is_removed_without_erasing_interior_white(self):
        source = Image.new("RGB", (20, 16), "white")
        ImageDraw.Draw(source).rectangle((3, 4, 16, 11), outline="red", width=1)
        result, bounds = prepare_logo(source)
        self.assertEqual(bounds, (3, 4, 17, 12))
        self.assertEqual(result.getpixel((5, 3)), (255, 255, 255, 255))

    def test_square_padding_preserves_aspect_ratio_and_centers_artwork(self):
        source = Image.new("RGBA", (14, 12))
        ImageDraw.Draw(source).rectangle((2, 3, 9, 6), fill="green")
        result, _ = prepare_logo(source, square=True, padding=2)
        self.assertEqual(result.size, (12, 12))
        self.assertEqual(result.getchannel("A").getbbox(), (2, 4, 10, 8))

    def test_explicit_background_ignores_near_white_border(self):
        source = Image.new("RGB", (12, 12), (250, 250, 250))
        ImageDraw.Draw(source).rectangle((4, 3, 7, 8), fill="black")
        result, bounds = prepare_logo(source, background="white", tolerance=8)
        self.assertEqual(bounds, (4, 3, 8, 9))
        self.assertEqual(result.size, (4, 6))

    def test_processing_a_prepared_square_again_is_idempotent(self):
        source = Image.new("RGBA", (18, 12))
        ImageDraw.Draw(source).ellipse((4, 3, 13, 8), fill="blue")
        once, _ = prepare_logo(source, square=True, padding=2)
        twice, _ = prepare_logo(once, square=True, padding=2)
        self.assertEqual(once.size, twice.size)
        self.assertEqual(once.tobytes(), twice.tobytes())

    def test_empty_and_invalid_settings_are_rejected(self):
        for source in (Image.new("RGBA", (5, 5)), Image.new("RGB", (5, 5), "white")):
            with self.subTest(mode=source.mode), self.assertRaises(ValueError):
                prepare_logo(source)
        with self.assertRaises(ValueError):
            prepare_logo(Image.new("RGB", (5, 5)), padding=-1)

    def test_cli_cannot_overwrite_source_through_a_hard_link(self):
        with tempfile.TemporaryDirectory() as directory:
            source = Path(directory) / "source.png"
            alias = Path(directory) / "alias.png"
            Image.new("RGBA", (8, 8), "red").save(source)
            original = source.read_bytes()
            try:
                os.link(source, alias)
            except OSError as error:
                self.skipTest(f"Hard links unavailable: {error}")
            result = subprocess.run(
                [sys.executable, str(Path(__file__).with_name("prepare_logo.py")),
                 str(source), str(alias)],
                capture_output=True, text=True,
            )
            self.assertEqual(result.returncode, 2)
            self.assertIn("Source and output must differ", result.stderr)
            self.assertEqual(source.read_bytes(), original)


if __name__ == "__main__":
    unittest.main()
