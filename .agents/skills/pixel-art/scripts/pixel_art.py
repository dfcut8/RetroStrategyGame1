"""Pixel art converter — Floyd-Steinberg dithering with preset or named palette.

Named hardware palettes (NES, GameBoy, PICO-8, C64, etc.) ported from
pixel-art-studio (MIT) — see ATTRIBUTION.md.

Usage (import):
    from pixel_art import pixel_art
    pixel_art("in.png", "out.png", preset="arcade")
    pixel_art("in.png", "out.png", preset="nes")
    pixel_art("in.png", "out.png", palette="PICO_8", block=6)

Usage (CLI):
    python pixel_art.py in.png out.png --preset nes
"""

from PIL import Image, ImageEnhance, ImageOps

try:
    from .palettes import PALETTES, build_palette_image
except ImportError:
    from palettes import PALETTES, build_palette_image


PRESETS = {
    # ── Ashfall project preset ──────────────────────────────────────────
    "ashfall": {
        "contrast": 1.35, "color": 1.15, "sharpness": 1.0,
        "posterize_bits": 4, "block": 2, "palette": "ASHFALL_CORE",
        "dither": False,
    },
    # ── Original presets (adaptive palette) ─────────────────────────────
    "arcade": {
        "contrast": 1.8, "color": 1.5, "sharpness": 1.2,
        "posterize_bits": 5, "block": 8, "palette": 16,
    },
    "snes": {
        "contrast": 1.6, "color": 1.4, "sharpness": 1.2,
        "posterize_bits": 6, "block": 4, "palette": 32,
    },
    # ── Hardware-accurate presets (named palette) ───────────────────────
    "nes": {
        "contrast": 1.5, "color": 1.4, "sharpness": 1.2,
        "posterize_bits": 6, "block": 8, "palette": "NES",
    },
    "gameboy": {
        "contrast": 1.5, "color": 1.0, "sharpness": 1.2,
        "posterize_bits": 6, "block": 8, "palette": "GAMEBOY_ORIGINAL",
    },
    "gameboy_pocket": {
        "contrast": 1.5, "color": 1.0, "sharpness": 1.2,
        "posterize_bits": 6, "block": 8, "palette": "GAMEBOY_POCKET",
    },
    "pico8": {
        "contrast": 1.6, "color": 1.3, "sharpness": 1.2,
        "posterize_bits": 6, "block": 6, "palette": "PICO_8",
    },
    "c64": {
        "contrast": 1.6, "color": 1.3, "sharpness": 1.2,
        "posterize_bits": 6, "block": 8, "palette": "C64",
    },
    "apple2": {
        "contrast": 1.8, "color": 1.4, "sharpness": 1.2,
        "posterize_bits": 5, "block": 10, "palette": "APPLE_II_HI",
    },
    "teletext": {
        "contrast": 1.8, "color": 1.5, "sharpness": 1.2,
        "posterize_bits": 5, "block": 10, "palette": "TELETEXT",
    },
    "mspaint": {
        "contrast": 1.6, "color": 1.4, "sharpness": 1.2,
        "posterize_bits": 6, "block": 8, "palette": "MICROSOFT_WINDOWS_PAINT",
    },
    "mono_green": {
        "contrast": 1.8, "color": 0.0, "sharpness": 1.2,
        "posterize_bits": 5, "block": 6, "palette": "MONO_GREEN",
    },
    "mono_amber": {
        "contrast": 1.8, "color": 0.0, "sharpness": 1.2,
        "posterize_bits": 5, "block": 6, "palette": "MONO_AMBER",
    },
    # ── Artistic palette presets ────────────────────────────────────────
    "neon": {
        "contrast": 1.8, "color": 1.6, "sharpness": 1.2,
        "posterize_bits": 5, "block": 6, "palette": "NEON_CYBER",
    },
    "pastel": {
        "contrast": 1.2, "color": 1.3, "sharpness": 1.1,
        "posterize_bits": 6, "block": 6, "palette": "PASTEL_DREAM",
    },
}


def _parse_hex_color(value):
    """Return an RGB tuple from RRGGBB, #RRGGBB, or an existing RGB tuple."""
    if isinstance(value, tuple) and len(value) == 3:
        return value
    text = str(value).lstrip("#")
    if len(text) != 6:
        raise ValueError("chroma_key must be formatted as RRGGBB or #RRGGBB")
    try:
        return tuple(int(text[index:index + 2], 16) for index in (0, 2, 4))
    except ValueError as exc:
        raise ValueError("chroma_key must contain hexadecimal digits") from exc


def _apply_chroma_key(image, key, tolerance):
    """Make pixels near the key color transparent while preserving other alpha."""
    if tolerance < 0 or tolerance > 255:
        raise ValueError("chroma_tolerance must be between 0 and 255")
    key_r, key_g, key_b = _parse_hex_color(key)
    pixels = []
    for red, green, blue, alpha in image.get_flattened_data():
        distance = max(
            abs(red - key_r),
            abs(green - key_g),
            abs(blue - key_b),
        )
        pixels.append((red, green, blue, 0 if distance <= tolerance else alpha))
    image.putdata(pixels)
    return image


def pixel_art(
    input_path,
    output_path,
    preset="arcade",
    size=None,
    chroma_key=None,
    chroma_tolerance=0,
    **overrides,
):
    """Convert an image to retro pixel art.

    Args:
        input_path: path to source image
        output_path: path to save the resulting PNG
        preset: one of PRESETS (arcade, snes, nes, gameboy, pico8, c64, ...)
        size: optional exact output size as a (width, height) tuple
        chroma_key: optional RGB key formatted as RRGGBB, #RRGGBB, or a tuple
        chroma_tolerance: maximum per-channel distance removed with the key
        **overrides: optionally override any preset field. In particular:
            palette: int (adaptive N colors) OR str (named palette from PALETTES)
            block:   int pixel block size
            contrast / color / sharpness / posterize_bits: numeric enhancers

    Returns:
        The resulting PIL.Image.
    """
    if preset not in PRESETS:
        raise ValueError(
            f"Unknown preset {preset!r}. Choose from: {sorted(PRESETS)}"
        )
    cfg = {**PRESETS[preset], **overrides}

    source = Image.open(input_path).convert("RGBA")
    if chroma_key is not None:
        source = _apply_chroma_key(source, chroma_key, chroma_tolerance)
    if size is not None:
        width, height = size
        if width <= 0 or height <= 0:
            raise ValueError("size dimensions must be positive")
        source = source.resize((width, height), Image.Resampling.BOX)

    alpha = source.getchannel("A")
    img = source.convert("RGB")

    img = ImageEnhance.Contrast(img).enhance(cfg["contrast"])
    img = ImageEnhance.Color(img).enhance(cfg["color"])
    img = ImageEnhance.Sharpness(img).enhance(cfg["sharpness"])
    img = ImageOps.posterize(img, cfg["posterize_bits"])

    w, h = img.size
    block = cfg["block"]
    small = img.resize(
        (max(1, w // block), max(1, h // block)),
        Image.NEAREST,
    )

    # Quantize AFTER downscale so dithering aligns with the final pixel grid.
    pal = cfg["palette"]
    dither = Image.Dither.FLOYDSTEINBERG if cfg.get("dither", True) else Image.Dither.NONE
    if isinstance(pal, str):
        # Named hardware/artistic palette
        pal_img = build_palette_image(pal)
        quantized = small.quantize(palette=pal_img, dither=dither)
    else:
        # Adaptive N-color palette (original behavior)
        quantized = small.quantize(colors=int(pal), dither=dither)

    result = quantized.convert("RGBA").resize((w, h), Image.NEAREST)
    hard_alpha = alpha.point(lambda value: 255 if value >= 128 else 0)
    result.putalpha(hard_alpha)
    result.save(output_path, "PNG")
    return result


def main():
    import argparse
    p = argparse.ArgumentParser(description="Convert image to pixel art.")
    p.add_argument("input")
    p.add_argument("output")
    p.add_argument("--preset", default="arcade", choices=sorted(PRESETS))
    p.add_argument("--palette", default=None,
                   help=f"Override palette: int or name from {sorted(PALETTES)}")
    p.add_argument("--block", type=int, default=None)
    p.add_argument("--size", default=None,
                   help="Exact output dimensions formatted as WIDTHxHEIGHT")
    p.add_argument("--chroma-key", default=None,
                   help="RGB background key formatted as RRGGBB or #RRGGBB")
    p.add_argument("--chroma-tolerance", type=int, default=0,
                   help="Maximum per-channel key distance to make transparent")
    args = p.parse_args()

    overrides = {}
    if args.palette is not None:
        try:
            overrides["palette"] = int(args.palette)
        except ValueError:
            overrides["palette"] = args.palette
    if args.block is not None:
        overrides["block"] = args.block

    size = None
    if args.size is not None:
        try:
            width, height = (int(value) for value in args.size.lower().split("x", 1))
            size = (width, height)
        except (TypeError, ValueError):
            p.error("--size must be formatted as WIDTHxHEIGHT")

    pixel_art(
        args.input,
        args.output,
        preset=args.preset,
        size=size,
        chroma_key=args.chroma_key,
        chroma_tolerance=args.chroma_tolerance,
        **overrides,
    )
    print(f"Wrote {args.output}")


if __name__ == "__main__":
    main()
