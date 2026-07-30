extends Control

const COLORS := {
	"shadow": Color("#09080d"),
	"ink": Color("#17141f"),
	"panel": Color("#24202d"),
	"panel_2": Color("#302a3a"),
	"line": Color("#5d536b"),
	"muted": Color("#aaa2b2"),
	"paper": Color("#e4ddcc"),
	"white": Color("#f4efe2"),
	"violet": Color("#8a7fc8"),
	"ochre": Color("#c58b32"),
	"rust": Color("#b55737"),
	"cyan": Color("#65c6bd"),
	"olive": Color("#8d9652"),
	"earth": Color("#6f4d2e"),
	"metal": Color("#7a746b"),
	"lantern": Color("#d9b65f"),
}

const BUILDINGS := {
	"bunkhouse": {
		"name": "BUNKHOUSE",
		"texture": "res://assets/sprites/settlement/bunkhouse.png",
		"cost": 36,
		"labor": 8,
		"turns": 1,
		"effect_key": "shelter",
		"effect_label": "SHELTER",
		"effect_value": 8,
		"cohesion": 1,
		"description": "More durable beds expand shelter.",
	},
	"clinic": {
		"name": "CLINIC",
		"texture": "res://assets/sprites/settlement/clinic.png",
		"cost": 30,
		"labor": 6,
		"turns": 1,
		"effect_key": "health",
		"effect_label": "HEALTH",
		"effect_value": 7,
		"cohesion": 4,
		"description": "Care improves survival and trust.",
	},
	"greenhouse": {
		"name": "GREENHOUSE",
		"texture": "res://assets/sprites/settlement/greenhouse.png",
		"cost": 28,
		"labor": 7,
		"turns": 1,
		"effect_key": "food_capacity",
		"effect_label": "FOOD OUTPUT",
		"effect_value": 8,
		"cohesion": 3,
		"description": "Reliable food steadies growth.",
	},
	"workshop": {
		"name": "WORKSHOP",
		"texture": "res://assets/sprites/settlement/workshop.png",
		"cost": 32,
		"labor": 10,
		"turns": 1,
		"effect_key": "workshop_capacity",
		"effect_label": "WORKSHOP",
		"effect_value": 6,
		"cohesion": 1,
		"description": "Repairs strengthen local industry.",
	},
	"commons_hall": {
		"name": "COMMONS HALL",
		"texture": "res://assets/sprites/settlement/commons_hall.png",
		"cost": 34,
		"labor": 9,
		"turns": 1,
		"effect_key": "migration_appeal",
		"effect_label": "MIGRATION APPEAL",
		"effect_value": 6,
		"cohesion": 8,
		"description": "Shared space attracts migrants.",
	},
}

const BUILD_ORDER := [
	"bunkhouse",
	"clinic",
	"greenhouse",
	"workshop",
	"commons_hall",
]

const PLOT_POSITIONS := [
	Vector2(44, 91),
	Vector2(170, 78),
	Vector2(302, 101),
	Vector2(73, 224),
	Vector2(205, 215),
	Vector2(328, 236),
]

var population := 24
var shelter_capacity := 28
var health := 52
var food_capacity := 48
var workshop_capacity := 0
var migration_appeal := 10
var cohesion := 54
var available_workforce := 18
var reserved_workers := 0
var scrap := 180
var turn := 6
var selected_building := "bunkhouse"
var selected_plot := 0
var built_plots: Array[String] = ["", "", "", "", "", ""]
var pending_building := ""
var pending_plot := -1
var last_resolution := "No project resolved yet."

var population_label: Label
var morale_label: Label
var scrap_label: Label
var build_title: Label
var details_label: Label
var report_label: Label
var build_button: Button
var end_turn_button: Button
var building_buttons: Dictionary = {}
var plot_buttons: Array[Button] = []


func _ready() -> void:
	set_process_input(true)
	_build_interface()
	_refresh_interface()
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(0, 0, 640, 480), COLORS.shadow)
	draw_rect(Rect2(0, 50, 418, 350), COLORS.earth)
	draw_rect(Rect2(0, 50, 418, 44), COLORS.violet)

	for ridge_x in range(10, 410, 44):
		var ridge_height := 10 + (ridge_x % 25)
		draw_colored_polygon(
			PackedVector2Array([
				Vector2(ridge_x, 94),
				Vector2(ridge_x + 18, 94 - ridge_height),
				Vector2(ridge_x + 38, 94),
			]),
			COLORS.panel_2
		)
		draw_line(
			Vector2(ridge_x + 18, 94 - ridge_height),
			Vector2(ridge_x + 38, 94),
			COLORS.line,
			2.0
		)

	for speck_x in range(12, 410, 29):
		var speck_y := 112 + ((speck_x * 37) % 270)
		draw_rect(Rect2(speck_x, speck_y, 3, 2), COLORS.ochre)

	draw_polyline(
		PackedVector2Array([
			Vector2(0, 330),
			Vector2(92, 316),
			Vector2(176, 337),
			Vector2(260, 319),
			Vector2(418, 345),
		]),
		COLORS.ochre,
		3.0
	)

	draw_rect(Rect2(418, 50, 222, 430), COLORS.panel)
	draw_line(Vector2(418, 50), Vector2(418, 480), COLORS.line, 2.0)
	draw_rect(Rect2(0, 400, 418, 80), COLORS.panel_2)
	draw_line(Vector2(0, 400), Vector2(418, 400), COLORS.line, 2.0)


func _build_interface() -> void:
	var title := _make_label("ASHFALL  /  SETTLEMENT", Vector2(14, 10), Vector2(218, 28), 18)
	title.add_theme_color_override("font_color", COLORS.white)

	population_label = _make_label("", Vector2(240, 8), Vector2(136, 34), 14)
	morale_label = _make_label("", Vector2(384, 8), Vector2(124, 34), 14)
	scrap_label = _make_label("", Vector2(516, 8), Vector2(116, 34), 14)

	build_title = _make_label("", Vector2(430, 60), Vector2(198, 24), 16)
	build_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	for index in BUILD_ORDER.size():
		var building_id: String = BUILD_ORDER[index]
		var data: Dictionary = BUILDINGS[building_id]
		var button := Button.new()
		button.position = Vector2(430, 88 + index * 44)
		button.size = Vector2(198, 38)
		button.text = "%s  /  %d SCRAP" % [data.name, data.cost]
		button.alignment = HORIZONTAL_ALIGNMENT_LEFT
		button.add_theme_font_size_override("font_size", 12)
		button.pressed.connect(_select_building.bind(building_id))
		add_child(button)
		building_buttons[building_id] = button

	details_label = _make_label("", Vector2(430, 314), Vector2(198, 92), 12)
	details_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	details_label.vertical_alignment = VERTICAL_ALIGNMENT_TOP

	build_button = Button.new()
	build_button.position = Vector2(430, 414)
	build_button.size = Vector2(198, 48)
	build_button.add_theme_font_size_override("font_size", 15)
	build_button.pressed.connect(_build_selected)
	add_child(build_button)

	for index in PLOT_POSITIONS.size():
		var button := Button.new()
		button.position = PLOT_POSITIONS[index]
		button.size = Vector2(88, 82)
		button.add_theme_font_size_override("font_size", 11)
		button.pressed.connect(_select_plot.bind(index))
		add_child(button)
		plot_buttons.append(button)

	report_label = _make_label("", Vector2(14, 405), Vector2(274, 70), 11)
	report_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	end_turn_button = Button.new()
	end_turn_button.position = Vector2(296, 414)
	end_turn_button.size = Vector2(108, 48)
	end_turn_button.text = "END TURN"
	end_turn_button.add_theme_font_size_override("font_size", 14)
	end_turn_button.pressed.connect(_end_turn)
	add_child(end_turn_button)


func _make_label(text_value: String, at: Vector2, extent: Vector2, font_size: int) -> Label:
	var label := Label.new()
	label.text = text_value
	label.position = at
	label.size = extent
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", COLORS.paper)
	add_child(label)
	return label


func _select_building(building_id: String) -> void:
	selected_building = building_id
	_refresh_interface()


func _select_plot(plot_index: int) -> void:
	selected_plot = plot_index
	_refresh_interface()


func _build_selected() -> void:
	if pending_building != "":
		pending_building = ""
		pending_plot = -1
		reserved_workers = 0
		last_resolution = "Pending project canceled; no resources spent."
		_refresh_interface()
		return

	var data: Dictionary = BUILDINGS[selected_building]
	if (
		built_plots[selected_plot] != ""
		or scrap < data.cost
		or available_workforce < data.labor
	):
		return

	pending_building = selected_building
	pending_plot = selected_plot
	reserved_workers = data.labor
	last_resolution = "%s queued on plot %d." % [data.name, selected_plot + 1]
	_refresh_interface()


func _end_turn() -> void:
	turn += 1
	if pending_building == "":
		last_resolution = "Turn advanced with no settlement project."
		_refresh_interface()
		return

	var data: Dictionary = BUILDINGS[pending_building]
	built_plots[pending_plot] = pending_building
	scrap -= data.cost
	_apply_building_effect(data.effect_key, data.effect_value)
	cohesion = mini(100, cohesion + data.cohesion)
	reserved_workers = 0
	last_resolution = "%s completed: +%d %s, +%d cohesion." % [
		data.name,
		data.effect_value,
		data.effect_label.to_lower(),
		data.cohesion,
	]
	pending_building = ""
	pending_plot = -1

	for index in built_plots.size():
		if built_plots[index] == "":
			selected_plot = index
			break

	_refresh_interface()


func _apply_building_effect(effect_key: String, value: int) -> void:
	match effect_key:
		"shelter":
			shelter_capacity += value
		"health":
			health = mini(100, health + value)
		"food_capacity":
			food_capacity += value
		"workshop_capacity":
			workshop_capacity += value
		"migration_appeal":
			migration_appeal += value


func _refresh_interface() -> void:
	population_label.text = "POP %d/%d" % [population, shelter_capacity]
	morale_label.text = "COHESION %d%%" % cohesion
	scrap_label.text = "SCRAP %d" % scrap
	build_title.text = "TURN %d  /  BUILD" % turn

	for building_id in BUILD_ORDER:
		var button: Button = building_buttons[building_id]
		var data: Dictionary = BUILDINGS[building_id]
		button.text = "%s%s  /  %d" % [
			"> " if building_id == selected_building else "",
			data.name,
			data.cost,
		]
		button.add_theme_color_override(
			"font_color",
			COLORS.lantern if building_id == selected_building else COLORS.paper
		)

	for index in plot_buttons.size():
		_refresh_plot(index)

	var selected_data: Dictionary = BUILDINGS[selected_building]
	details_label.text = "%s\n+%d %s   +%d COHESION\n%d LABOR / %d TURN\n\n%s" % [
		selected_data.name,
		selected_data.effect_value,
		selected_data.effect_label,
		selected_data.cohesion,
		selected_data.labor,
		selected_data.turns,
		selected_data.description,
	]

	if pending_building != "":
		build_button.disabled = false
		build_button.text = "CANCEL ORDER"
	elif built_plots[selected_plot] != "":
		build_button.disabled = true
		build_button.text = "PLOT OCCUPIED"
	elif scrap < selected_data.cost:
		build_button.disabled = true
		build_button.text = "NEEDS %d MORE SCRAP" % (selected_data.cost - scrap)
	elif available_workforce < selected_data.labor:
		build_button.disabled = true
		build_button.text = "NEEDS %d LABOR" % selected_data.labor
	else:
		build_button.disabled = false
		build_button.text = "QUEUE ON PLOT %d" % (selected_plot + 1)

	var spare_capacity := shelter_capacity - population
	var arrival_ready := (
		spare_capacity >= 6
		and food_capacity >= 50
		and health >= 50
		and cohesion >= 50
	)
	var arrival_outlook := "ARRIVALS FAVORED" if arrival_ready else "GROWTH PRESSURED"
	report_label.text = "POP REPORT / %d residents, %d spare / %d workers free\n%s / health %d / food %d\n%s" % [
		population,
		spare_capacity,
		available_workforce - reserved_workers,
		arrival_outlook,
		health,
		food_capacity,
		last_resolution,
	]


func _refresh_plot(index: int) -> void:
	var button: Button = plot_buttons[index]
	for child in button.get_children():
		child.queue_free()

	if pending_plot == index:
		var pending_data: Dictionary = BUILDINGS[pending_building]
		button.text = "PENDING\n%s" % pending_data.name
	elif built_plots[index] == "":
		button.text = "%sEMPTY\nPLOT %d" % [
			"> " if index == selected_plot else "",
			index + 1,
		]
	else:
		var building_id := built_plots[index]
		var data: Dictionary = BUILDINGS[building_id]
		button.text = ""

		var texture_rect := TextureRect.new()
		texture_rect.texture = load(data.texture)
		texture_rect.position = Vector2(-12, -7)
		texture_rect.size = Vector2(112, 96)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(texture_rect)

		var nameplate := Label.new()
		nameplate.text = data.name
		nameplate.position = Vector2(2, 62)
		nameplate.size = Vector2(84, 18)
		nameplate.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		nameplate.add_theme_font_size_override("font_size", 9)
		nameplate.add_theme_color_override("font_color", COLORS.white)
		nameplate.add_theme_color_override("font_shadow_color", COLORS.shadow)
		nameplate.add_theme_constant_override("shadow_offset_x", 1)
		nameplate.add_theme_constant_override("shadow_offset_y", 1)
		nameplate.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(nameplate)

	button.add_theme_color_override(
		"font_color",
		COLORS.lantern if index == selected_plot else COLORS.paper
	)
