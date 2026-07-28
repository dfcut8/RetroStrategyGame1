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

## Initial asset scope

This first kit deliberately covers the Camp chapter described by the GDD:

- ash-wasteland ground;
- makeshift tarp shelter;
- improvised water collector;
- local scrap cache;
- Permanent Hub defining project.

Runtime PNGs are final game assets. Asset generation and conversion live outside the Godot project
in the repository-local `.agents/skills/generate-ashfall-assets` skill.

A gameplay main scene is intentionally deferred beyond this asset/bootstrap milestone.
