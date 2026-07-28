extends SceneTree


func _initialize() -> void:
	call_deferred("_render_gallery")


func _render_gallery() -> void:
	var packed_scene := load("res://scenes/asset_gallery.tscn") as PackedScene
	if packed_scene == null:
		push_error("Could not load asset gallery scene.")
		quit(1)
		return

	var gallery := packed_scene.instantiate()
	root.add_child(gallery)
	await process_frame
	await process_frame
	await RenderingServer.frame_post_draw

	var image := root.get_texture().get_image()
	if image.is_empty():
		push_error("Viewport capture was empty.")
		quit(1)
		return

	var output_directory := ProjectSettings.globalize_path("res://artifacts")
	DirAccess.make_dir_recursive_absolute(output_directory)
	var output_path := output_directory.path_join("asset_gallery.png")
	var result := image.save_png(output_path)
	if result != OK:
		push_error("Could not save asset gallery preview: %s" % error_string(result))
		quit(1)
		return

	print("Saved %dx%d gallery preview to %s" % [image.get_width(), image.get_height(), output_path])
	quit()
