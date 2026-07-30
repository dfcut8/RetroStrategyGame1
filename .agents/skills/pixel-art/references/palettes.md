# Named Palettes

30 project, hardware-accurate, and artistic palettes are available to `pixel_art()`.
Hardware and generic artistic palette values are sourced from `pixel-art-studio` (MIT); the
Ashfall palettes are project-specific. See ATTRIBUTION.md in the skill root.

Usage: pass the palette name as `palette=` or let a preset select it.

```python
pixel_art("in.png", "out.png", preset="nes")           # preset selects NES
pixel_art("in.png", "out.png", preset="arcade", palette="PICO_8", block=6)
```

## Project Palettes

| Name | Colors | Use |
|------|--------|-----|
| `ASHFALL_CORE` | 8 | Default for simple Ashfall sprites and structures |
| `ASHFALL_16` | 16 | Extended ceiling for Ashfall backgrounds and UI |

## Hardware Palettes

| Name | Colors | Source |
|------|--------|--------|
| `NES` | 54 | Nintendo NES |
| `C64` | 16 | Commodore 64 |
| `COMMODORE_64` | 16 | Commodore 64 (alt) |
| `ZX_SPECTRUM` | 8 | Sinclair ZX Spectrum |
| `APPLE_II_LO` | 16 | Apple II lo-res |
| `APPLE_II_HI` | 6 | Apple II hi-res |
| `GAMEBOY_ORIGINAL` | 4 | Game Boy DMG (green) |
| `GAMEBOY_POCKET` | 4 | Game Boy Pocket (grey) |
| `GAMEBOY_VIRTUALBOY` | 4 | Virtual Boy (red) |
| `PICO_8` | 16 | PICO-8 fantasy console |
| `TELETEXT` | 8 | BBC Teletext |
| `CGA_MODE4_PAL1` | 4 | IBM CGA |
| `MSX` | 15 | MSX |
| `MICROSOFT_WINDOWS_16` | 16 | Windows 3.x default |
| `MICROSOFT_WINDOWS_PAINT` | 24 | MS Paint classic |
| `MONO_BW` | 2 | Black and white |
| `MONO_AMBER` | 2 | Amber monochrome |
| `MONO_GREEN` | 2 | Green monochrome |

## Artistic Palettes

| Name | Colors | Feel |
|------|--------|------|
| `PASTEL_DREAM` | 10 | Soft pastels |
| `NEON_CYBER` | 10 | Cyberpunk neon |
| `RETRO_WARM` | 10 | Warm 70s |
| `OCEAN_DEEP` | 10 | Blue gradient |
| `FOREST_MOSS` | 10 | Green naturals |
| `SUNSET_FIRE` | 10 | Red to yellow |
| `ARCTIC_ICE` | 10 | Cool blues and whites |
| `VINTAGE_ROSE` | 10 | Rose mauves |
| `EARTH_CLAY` | 10 | Terracotta browns |
| `ELECTRIC_VIOLET` | 10 | Violet gradient |
