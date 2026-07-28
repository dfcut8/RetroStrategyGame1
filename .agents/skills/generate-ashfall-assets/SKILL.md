---
name: generate-ashfall-assets
description: Generate, process, and validate game-ready Ashfall pixel-art assets for the Godot project. Use when creating or revising settlement sprites, buildings, terrain, resource art, interface imagery, map objects, or other raster assets that must follow the repository GDD, design style, 16-color palette, exact native pixel dimensions, transparency, and nearest-neighbor rendering requirements.
---

# Generate Ashfall Assets

Create final runtime PNGs, not raw concept art. Keep generation machinery outside `src`; place only
game-ready assets and their Godot import metadata in the Godot project.

## Workflow

1. Read the relevant sections of `docs/GAME_DESIGN_DOCUMENT.md`,
   `docs/DESIGN_STYLE.md`, and `docs/CONTROL_SCHEME.md`. Inspect the applicable images under
   `docs/visual-concepts/`.
2. Define the runtime contract before generating:
   - destination under `src/assets/`;
   - exact width and height;
   - `sprite` for transparent isolated objects or `opaque` for backgrounds;
   - gameplay stage and visual meaning;
   - required silhouette and palette accents.
3. Read [references/asset-spec.md](references/asset-spec.md). Use the built-in image-generation
   workflow and treat repository screenshots as style references, not edit targets.
4. Generate one source image per distinct asset. For sprites, require a perfectly flat `#ff00ff`
   background with no shadow, floor, gradient, or magenta in the subject.
5. Convert the source directly into its final destination:

   ```powershell
   .\.agents\skills\generate-ashfall-assets\scripts\prepare_pixel_asset.ps1 `
     -InputPath <generated-source.png> `
     -OutputPath <src/assets/path/final.png> `
     -Width <pixels> `
     -Height <pixels> `
     -Mode <sprite|opaque>
   ```

6. Inspect the final PNG at original resolution. Reject and regenerate assets with unclear
   silhouettes, key-color fringe, excessive noise, inconsistent perspective, unreadable scale, or
   style drift. Do not rely on post-processing to rescue structurally poor source art.
7. Import through Godot and verify lossless compression and disabled mipmaps. Keep filtering at
   nearest through the existing project-wide CanvasItem setting; do not add runtime scaling.
8. Run the project asset validation when applicable and report the final path, size, color count,
   prompt, and generation method.

## Repository boundaries

- Keep raw generated sources in the generator's external output location or temporary storage.
- Do not commit raw source images, chroma-key intermediates, prompts, or processing scripts under
  `src`.
- Do not overwrite an existing runtime asset unless the user requested replacement.
- Do not change gameplay meaning to accommodate attractive art. Escalate conflicts with the GDD.
- Preserve aggregate-population framing and Camp/Settlement capability gates.
