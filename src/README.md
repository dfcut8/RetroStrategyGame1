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
the project-wide CanvasItem setting. PNG imports remain lossless with mipmap generation disabled,
which is Godot's default for 2D textures.

## Current prototype scope

The runtime assets cover the Camp chapter described by the GDD:

- ash-wasteland ground;
- makeshift tarp shelter;
- improvised water collector;
- local scrap cache;
- Permanent Hub defining project.

The playable Settlement prototype adds:

- a compact aggregate population report;
- aggregate Shelter, Health, Food Output, Workshop, Migration Appeal, and Cohesion effects;
- six selectable build plots;
- five permanent buildings: Bunkhouse, Clinic, Greenhouse, Workshop, and Commons Hall;
- visible Scrap costs and projected effects before building.

Runtime PNGs are final game assets. Raster generation, conversion, palette control, and optional
animation use the repository-local `.agents/skills/pixel-art` skill.
