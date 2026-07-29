# Ashfall runtime asset specification

## Core palette

Use no more than these 16 opaque colors per runtime asset:

| Name | Hex |
| --- | --- |
| Shadow | `#09080d` |
| Ink | `#17141f` |
| Panel | `#24202d` |
| Panel 2 | `#302a3a` |
| Line | `#5d536b` |
| Muted | `#aaa2b2` |
| Paper | `#e4ddcc` |
| White | `#f4efe2` |
| Violet | `#8a7fc8` |
| Ochre | `#c58b32` |
| Rust | `#b55737` |
| Cyan | `#65c6bd` |
| Olive | `#8d9652` |
| Earth | `#6f4d2e` |
| Metal | `#7a746b` |
| Lantern | `#d9b65f` |

Transparency is allowed in sprites and does not count as an opaque palette color.

## Existing scale anchors

- Small Camp structures: `96×80`
- Permanent Hub-sized milestone: `112×96`
- Settlement gallery ground: `640×360`
- Game canvas: `640×480`, native size with no stretch or runtime scaling

Choose new dimensions deliberately from their intended on-screen footprint. Do not upscale a
runtime asset in Godot.

## Visual construction

- Use three-quarter top-down orthographic perspective for settlement objects.
- Use flat top-down perspective for terrain.
- Favor a strong silhouette, hard ink outline, clustered pixels, and a small number of readable
  material groups.
- Use ochre, rust, olive, cyan, or violet as controlled accents rather than equal-area noise.
- Avoid gradients, antialiasing, soft shadows, photographic texture, tiny decoration, text,
  watermarks, and isolated single-pixel noise.
- Keep permanent structures visibly sturdier than makeshift structures without implying a later
  gameplay unlock.

## Prompt scaffold

```text
Use case: stylized-concept
Asset type: Ashfall game runtime asset
Input images: repository concept images are style references only
Primary request: <one asset and its gameplay meaning>
Subject: <silhouette, materials, essential details>
Style/medium: unusually polished late-era Commodore 64 pixel art; chunky square pixels; hard dark
outline; strict Ashfall palette
Composition/framing: <perspective>; one centered asset; generous padding
Constraints: no text; no UI unless requested; no antialiasing; no gradients; no watermark
```

For a transparent sprite, add:

```text
Scene/backdrop: perfectly flat solid #ff00ff chroma-key background
Constraints: one uniform background color; no shadow, floor, gradient, texture, or reflection; do
not use #ff00ff in the subject
```
