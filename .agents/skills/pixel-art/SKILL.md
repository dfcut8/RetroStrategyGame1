---
name: pixel-art
description: Create or convert Ashfall and generic retro raster art with deterministic pixel-grid, palette, transparency, native-size, and optional animation processing. Use for Ashfall runtime sprites, buildings, terrain, UI imagery, concepts, documentation, and promotional art, and for NES, Game Boy, PICO-8, C64, arcade, or SNES conversions.
---

# Pixel Art

Create or convert raster sources into controlled retro pixel art, then optionally animate generic
art into a short MP4 or GIF.

## Ashfall Authority

This is the repository's authoritative workflow for Ashfall raster art.

- For Ashfall work, first read the relevant parts of `docs/GAME_DESIGN_DOCUMENT.md`,
  `docs/DESIGN_STYLE.md`, and `docs/CONTROL_SCHEME.md`, then inspect the applicable images under
  `docs/visual-concepts/`.
- Use the `ashfall` preset for final runtime conversion. It defaults to the eight-color
  `ASHFALL_CORE` palette to favor simple graphics and large color clusters. Use `ASHFALL_16` only
  when a background or UI asset genuinely needs the extended palette.
- Target 6–9 opaque colors per sprite. The 16-color palette is a ceiling, not a target.
- Use three-quarter top-down orthographic perspective for settlement objects and flat top-down
  perspective for terrain.
- Preserve the established native scale anchors: 96×80 for small Camp structures, 112×96 for
  milestone-sized structures, 640×360 for settlement ground, and 640×480 for the game canvas.
- Reject sources with unnecessary bolts, seams, loose props, micro-highlights, or more than three
  readable material groups. Quantization does not repair an overdesigned silhouette.
- Preserve aggregate-population framing and Camp/Settlement capability gates.
- Do not apply optional weather or particle animation overlays to runtime assets.

Two scripts ship with this skill:

- `scripts/pixel_art.py` — photo → pixel-art PNG (Floyd-Steinberg dithering)
- `scripts/pixel_art_video.py` — pixel-art PNG → animated MP4 (+ optional GIF)

Each is importable or runnable directly. Presets snap to hardware palettes
when you want era-accurate colors (NES, Game Boy, PICO-8, etc.), or use
adaptive N-color quantization for arcade/SNES-style looks.

## Workflow

### Step 1 — Determine the source path

- For a new Ashfall asset, use the built-in ImageGen capability only to create a deliberately
  simple source. Request one dominant mass, one secondary form, one identifying feature, no tiny
  decoration, and a flat removable chroma-key background.
- For an existing image, use it directly as the conversion source.
- ImageGen and this skill are not the same: ImageGen synthesizes a raster source; this skill
  deterministically controls the final pixel grid, palette, dimensions, and optional animation.

### Step 2 — Select the style

- For Ashfall, use `ashfall` without asking for a generic era preset.
- For non-Ashfall work with unclear intent, offer up to four relevant presets:

- `arcade` — bold, chunky 80s cabinet feel (16 colors, 8px)
- `nes` — Nintendo 8-bit hardware palette (54 colors, 8px)
- `gameboy` — 4-shade green Game Boy DMG
- `snes` — cleaner 16-bit look (32 colors, 4px)

When the user names an era, use the matching preset
directly without asking again.

### Step 3 — Convert

- Remove a flat chroma-key background during conversion with `--chroma-key ff00ff`; use a small
  `--chroma-tolerance` only when the supposedly flat source contains minor key-color variation.
- Convert directly to the final native dimensions with `size=(width, height)`.
- Inspect the result at original resolution. Reject unclear silhouettes, noisy dithering,
  fragmented color clusters, excessive material groups, fringe, or style drift.
- For Godot runtime PNGs, verify lossless import, mipmaps disabled, nearest filtering, and no
  runtime scaling.

### Step 4 — Animate only when requested

For non-runtime art, run `pixel_art_video()` after conversion when the user requests motion.

## Preset Catalog

| Preset | Era | Palette | Block | Best for |
|--------|-----|---------|-------|----------|
| `ashfall` | Ashfall | fixed 8-color core | 2px | Ashfall runtime sprites and structures |
| `arcade` | 80s arcade | adaptive 16 | 8px | Bold posters, hero art |
| `snes` | 16-bit | adaptive 32 | 4px | Characters, detailed scenes |
| `nes` | 8-bit | NES (54) | 8px | True NES look |
| `gameboy` | DMG handheld | 4 green shades | 8px | Monochrome Game Boy |
| `gameboy_pocket` | Pocket handheld | 4 grey shades | 8px | Mono GB Pocket |
| `pico8` | PICO-8 | 16 fixed | 6px | Fantasy-console look |
| `c64` | Commodore 64 | 16 fixed | 8px | 8-bit home computer |
| `apple2` | Apple II hi-res | 6 fixed | 10px | Extreme retro, 6 colors |
| `teletext` | BBC Teletext | 8 pure | 10px | Chunky primary colors |
| `mspaint` | Windows MS Paint | 24 fixed | 8px | Nostalgic desktop |
| `mono_green` | CRT phosphor | 2 green | 6px | Terminal/CRT aesthetic |
| `mono_amber` | CRT amber | 2 amber | 6px | Amber monitor look |
| `neon` | Cyberpunk | 10 neons | 6px | Vaporwave/cyber |
| `pastel` | Soft pastel | 10 pastels | 6px | Kawaii / gentle |

Named palettes live in `scripts/palettes.py` (see `references/palettes.md` for
the complete list — 30 named palettes total). Any preset can be overridden:

```python
pixel_art("in.png", "out.png", preset="snes", palette="PICO_8", block=6)
pixel_art("source.png", "building.png", preset="ashfall", size=(112, 96))
```

## Scene Catalog (for video)

| Scene | Effects |
|-------|---------|
| `night` | Twinkling stars + fireflies + drifting leaves |
| `dusk` | Fireflies + sparkles |
| `tavern` | Dust motes + warm sparkles |
| `indoor` | Dust motes |
| `urban` | Rain + neon pulse |
| `nature` | Leaves + fireflies |
| `magic` | Sparkles + fireflies |
| `storm` | Rain + lightning |
| `underwater` | Bubbles + light sparkles |
| `fire` | Embers + sparkles |
| `snow` | Snowflakes + sparkles |
| `desert` | Heat shimmer + dust |

## Invocation Patterns

### Python (import)

```python
import sys
from pathlib import Path

sys.path.insert(0, str(Path.cwd() / ".agents" / "skills" / "pixel-art" / "scripts"))
from pixel_art import pixel_art
from pixel_art_video import pixel_art_video

# 1. Convert to pixel art
pixel_art("/path/to/photo.jpg", "/tmp/pixel.png", preset="nes")

# 2. Animate (optional)
pixel_art_video(
    "/tmp/pixel.png",
    "/tmp/pixel.mp4",
    scene="night",
    duration=6,
    fps=15,
    seed=42,
    export_gif=True,
)
```

### CLI

```powershell
# Run from the repository root with a Python environment that provides Pillow.
python .\.agents\skills\pixel-art\scripts\pixel_art.py in.jpg out.png --preset gameboy
python .\.agents\skills\pixel-art\scripts\pixel_art.py in.jpg out.png --preset snes --palette PICO_8 --block 6
python .\.agents\skills\pixel-art\scripts\pixel_art.py source.png building.png `
  --preset ashfall --size 112x96 --chroma-key ff00ff --chroma-tolerance 48

python .\.agents\skills\pixel-art\scripts\pixel_art_video.py out.png out.mp4 --scene night --duration 6 --gif
```

## Pipeline Rationale

**Pixel conversion:**
1. Resize to the requested native output dimensions when supplied.
2. Boost contrast/color/sharpness (stronger for smaller palettes).
3. Posterize to simplify tonal regions before quantization.
4. Downscale by `block` with `Image.NEAREST` (hard pixels, no interpolation).
5. Quantize against either an adaptive
   N-color palette OR a named hardware palette
6. Upscale back with `Image.NEAREST` and restore hard transparency.

The `ashfall` preset disables dithering so flat clusters stay readable instead of becoming noisy.

**Video overlay:**
- Copies the base frame each tick (static background)
- Overlays stateless-per-frame particle draws (one function per effect)
- Encodes via ffmpeg `libx264 -pix_fmt yuv420p -crf 18`
- Optional GIF via `palettegen` + `paletteuse`

## Dependencies

- Python 3.9+
- Pillow (`pip install Pillow`)
- ffmpeg on PATH (only needed for video — Hermes installs package this)

In Codex Desktop, load the workspace dependencies and use the returned Python executable; its
bundled environment includes Pillow. Do not assume the system `python` command has Pillow.

## Pitfalls

- Pallet keys are case-sensitive (`"NES"`, `"PICO_8"`, `"GAMEBOY_ORIGINAL"`).
- Very small sources (<100px wide) collapse under 8-10px blocks. Upscale the
  source first if it's tiny.
- Fractional `block` or `palette` will break quantization — keep them positive ints.
- Animation particle counts are tuned for ~640x480 canvases. On very large
  images you may want a second pass with a different seed for density.
- `mono_green` / `mono_amber` force `color=0.0` (desaturate). If you override
  and keep chroma, the 2-color palette can produce stripes on smooth regions.
- `clarify` loop: call it at most twice per turn (style, then scene). Don't
  pepper the user with more picks.

## Verification

- PNG is created at the output path
- Clear square pixel blocks visible at the preset's block size
- Color count matches preset (eyeball the image or run `Image.open(p).getcolors()`)
- Ashfall sprites use 6–9 opaque colors by default, have a clear silhouette, and contain no
  antialiased alpha
- Video is a valid MP4 (`ffprobe` can open it) with non-zero size

## Attribution

Named hardware palettes and the procedural animation loops in `pixel_art_video.py`
are ported from [pixel-art-studio](https://github.com/Synero/pixel-art-studio)
(MIT). See `ATTRIBUTION.md` in this skill directory for details.
