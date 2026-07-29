# Ashfall Godot project

The Godot project lives entirely in this `src` directory.

## Native presentation

- Logical canvas: **640×480**
- Default window: **1920×1440** (3× integer scale)
- Window resizing: enabled; the game canvas scales by whole-number steps
- Stretch mode: viewport, with 4:3 aspect preserved and integer scaling
- Canvas texture filter: nearest
- Mipmap filtering: disabled; current 2D assets do not generate mipmaps
- 2D transforms: snapped to whole pixels; global vertex snapping stays off to avoid double-snap jitter
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

Runtime PNGs are final game assets. Asset generation and conversion live outside the Godot project
in the repository-local `.agents/skills/generate-ashfall-assets` skill.
