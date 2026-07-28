extends SceneTree

const EXPECTED_SETTINGS := {
	"display/window/size/viewport_width": 640,
	"display/window/size/viewport_height": 480,
	"display/window/size/window_width_override": 640,
	"display/window/size/window_height_override": 480,
	"display/window/size/resizable": false,
	"display/window/stretch/mode": "disabled",
	"rendering/textures/canvas_textures/default_texture_filter": 0,
	"rendering/2d/snap/snap_2d_transforms_to_pixel": true,
	"rendering/2d/snap/snap_2d_vertices_to_pixel": true,
}

const EXPECTED_TEXTURES := {
	"res://assets/textures/camp_ground.png": Vector2i(640, 360),
	"res://assets/sprites/camp/tarp_shelter.png": Vector2i(96, 80),
	"res://assets/sprites/camp/water_collector.png": Vector2i(96, 80),
	"res://assets/sprites/camp/scrap_cache.png": Vector2i(96, 80),
	"res://assets/sprites/camp/permanent_hub.png": Vector2i(112, 96),
}


func _initialize() -> void:
	var failed := false
	for setting in EXPECTED_SETTINGS:
		var actual = ProjectSettings.get_setting(setting)
		var expected = EXPECTED_SETTINGS[setting]
		if actual != expected:
			push_error("%s: expected %s, got %s" % [setting, expected, actual])
			failed = true

	for path in EXPECTED_TEXTURES:
		var texture := load(path) as Texture2D
		if texture == null:
			push_error("Could not load %s" % path)
			failed = true
			continue
		var actual_size := texture.get_size()
		var expected_size: Vector2i = EXPECTED_TEXTURES[path]
		if Vector2i(actual_size) != expected_size:
			push_error("%s: expected %s, got %s" % [path, expected_size, actual_size])
			failed = true

	if failed:
		quit(1)
		return

	print("Ashfall project settings and five runtime textures validated.")
	quit()
