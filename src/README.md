# Ashfall Godot project

The Godot project lives entirely in this `src` directory.

## Native presentation

- Canvas and window: **640×480**
- Window resizing: disabled
- Stretch mode: disabled
- Canvas texture filter: nearest
- Mipmaps: nearest when explicitly used; current 2D assets do not generate mipmaps
- 2D transforms and vertices: snapped to whole pixels
- Renderer: Compatibility

Godot 4 no longer stores filtering in each texture's import options. Filtering is enforced through
the project-wide CanvasItem setting and again on the root viewport. PNG imports remain lossless
with mipmap generation disabled, which is Godot's default for 2D textures.

## Initial asset scope

This first kit deliberately covers the Camp chapter described by the GDD:

- ash-wasteland ground;
- makeshift tarp shelter;
- improvised water collector;
- local scrap cache;
- Permanent Hub defining project.

Raw image-generation sources are retained under `assets/source/imagegen` for iteration and excluded
from Godot imports by `.gdignore`. Runtime assets are cropped, nearest-neighbor reduced, keyed to
transparency where applicable, and quantized to the 16-color Ashfall palette.

Rebuild the runtime PNGs from the retained sources with:

```powershell
.\tools\process_pixel_art.ps1 -ProjectDirectory (Get-Location).Path
```

Run the project to open the 640×480 native-resolution asset gallery.
