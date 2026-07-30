extends SceneTree


func _initialize() -> void:
	call_deferred("_run")


func _run() -> void:
	var scene: Control = load("res://scenes/settlement/SettlementScene.tscn").instantiate()
	root.add_child(scene)
	await process_frame

	scene._preview_building("clinic")
	assert("CLINIC" in scene.details_label.text)
	assert("HEALTH" in scene.details_label.text)
	scene._clear_hover_preview()

	scene._preview_plot(0)
	assert("PLOT 1 / EMPTY" in scene.details_label.text)
	assert("PREVIEW" in scene.details_label.text)
	scene._clear_hover_preview()

	for index in scene.BUILD_ORDER.size():
		var building_id: String = scene.BUILD_ORDER[index]
		var building: Dictionary = scene.BUILDINGS[building_id]
		var scrap_before: int = scene.scrap
		var cohesion_before: int = scene.cohesion
		var effect_before: int = scene.get(building.effect_key)

		scene._select_building(building_id)
		scene._select_plot(index)
		scene._build_selected()

		assert(scene.pending_building == building_id)
		assert(scene.reserved_workers == building.labor)
		assert(scene.scrap == scrap_before, "A queued project must not spend Scrap before resolution.")
		scene._end_turn()

		assert(scene.built_plots[index] == building_id)
		assert(scene.scrap == scrap_before - building.cost)
		assert(scene.get(building.effect_key) == effect_before + building.effect_value)
		assert(scene.cohesion == cohesion_before + building.cohesion)
		assert(scene.reserved_workers == 0)

	scene._preview_plot(0)
	assert("BUNKHOUSE" in scene.details_label.text)
	assert("CONDITION: STABLE" in scene.details_label.text)
	scene._clear_hover_preview()

	var scrap_after_builds: int = scene.scrap
	scene._select_plot(0)
	scene._build_selected()
	assert(scene.scrap == scrap_after_builds, "An occupied plot must not charge Scrap twice.")

	scene.scrap = 100
	scene._select_plot(5)
	scene._select_building("bunkhouse")
	scene._build_selected()
	assert(scene.pending_building == "bunkhouse")
	scene._build_selected()
	assert(scene.pending_building == "", "A pending project must be cancelable before resolution.")
	assert(scene.scrap == scrap_after_builds)

	print("Settlement scene smoke test passed.")
	quit()
