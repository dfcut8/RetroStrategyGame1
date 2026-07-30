extends SceneTree


func _initialize() -> void:
	assert(
		ProjectSettings.get_setting("display/window/size/viewport_width") == 640,
		"Ashfall must retain a 640-pixel logical viewport width."
	)
	assert(
		ProjectSettings.get_setting("display/window/size/viewport_height") == 480,
		"Ashfall must retain a 480-pixel logical viewport height."
	)
	assert(
		ProjectSettings.get_setting("display/window/size/window_width_override") == 1920,
		"The default window must be a 3x integer scale."
	)
	assert(
		ProjectSettings.get_setting("display/window/size/window_height_override") == 1440,
		"The default window must be a 3x integer scale."
	)
	assert(
		ProjectSettings.get_setting("display/window/size/resizable"),
		"The game window must support alternate integer scales."
	)
	assert(
		ProjectSettings.get_setting("display/window/stretch/mode") == "viewport",
		"The complete 640x480 framebuffer must scale as one pixel-art surface."
	)
	assert(
		ProjectSettings.get_setting("display/window/stretch/aspect") == "keep",
		"The 4:3 game canvas must retain its aspect ratio."
	)
	assert(
		ProjectSettings.get_setting("display/window/stretch/scale_mode") == "integer",
		"Fractional canvas scaling would blur or distort pixel art."
	)
	assert(
		ProjectSettings.get_setting("rendering/textures/canvas_textures/default_texture_filter") == 0,
		"Canvas textures must use nearest-neighbor filtering."
	)
	assert(
		not ProjectSettings.get_setting("rendering/textures/default_filters/use_nearest_mipmap_filter"),
		"Pixel-art textures must not introduce nearest-mipmap transitions."
	)
	assert(
		ProjectSettings.get_setting("rendering/2d/snap/snap_2d_transforms_to_pixel"),
		"2D transforms must stay on the logical pixel grid."
	)
	assert(
		not ProjectSettings.get_setting("rendering/2d/snap/snap_2d_vertices_to_pixel"),
		"Global vertex snapping must stay off when transform snapping is enabled."
	)
	assert(
		ProjectSettings.get_setting("rendering/anti_aliasing/quality/msaa_2d") == 0,
		"2D MSAA must remain disabled for pixel-art output."
	)

	print("Pixel-perfect project settings smoke test passed.")
	quit()
