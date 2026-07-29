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
		"description": "Durable communal shelter.",
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
		"description": "Care made from scavenged rooms.",
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
		"description": "Protected crops against the ash.",
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
		"description": "Tools, repairs, and fabrication.",
	},
	"commons_hall": {
		"name": "COMMONS HALL",
		"texture": "res://assets/sprites/settlement/commons_hall.png",
		"cost": 34,
		"labor": 9,
		"turns": 1,
		"effect_key": "migration_appeal",
		"effect_label": "MIGRATION",
		"effect_value": 6,
		"cohesion": 8,
		"description": "A shared roof for hard choices.",
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
	Vector2(116, 142),
	Vector2(196, 126),
	Vector2(282, 150),
	Vector2(142, 226),
	Vector2(226, 212),
	Vector2(310, 236),
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

var turn_label: Label
var population_label: Label
var cohesion_label: Label
var scrap_label: Label
var details_label: Label
var report_label: Label
var build_button: Button
var end_turn_button: Button
var building_buttons: Dictionary = {}
var building_labels: Dictionary = {}
var plot_buttons: Array[Button] = []
var hover_preview_text := ""


func _ready() -> void:
	_build_interface()
	_refresh_interface()
	queue_redraw()


func _draw() -> void:
	draw_rect(Rect2(0, 0, 640, 480), COLORS.shadow)

	# Compact ruler-style status bar.
	draw_rect(Rect2(0, 0, 640, 32), COLORS.shadow)
	for divider_x in [142, 276, 410, 526]:
		draw_line(Vector2(divider_x, 4), Vector2(divider_x, 28), COLORS.line, 1.0)

	# Dusty horizon and broad, flat terrain.
	draw_rect(Rect2(0, 32, 450, 42), COLORS.paper)
	draw_rect(Rect2(0, 74, 450, 318), COLORS.earth)
	draw_rect(Rect2(450, 32, 190, 360), COLORS.panel)
	draw_line(Vector2(450, 32), Vector2(450, 392), COLORS.paper, 2.0)

	for ridge_x in range(-10, 450, 42):
		var peak := 43 + ((ridge_x * 7) % 15)
		draw_colored_polygon(
			PackedVector2Array([
				Vector2(ridge_x, 72),
				Vector2(ridge_x + 20, peak),
				Vector2(ridge_x + 42, 72),
			]),
			COLORS.violet
		)
		draw_colored_polygon(
			PackedVector2Array([
				Vector2(ridge_x + 8, 72),
				Vector2(ridge_x + 24, peak + 9),
				Vector2(ridge_x + 42, 72),
			]),
			COLORS.line
		)

	# Irradiated river edge and cracked banks.
	draw_colored_polygon(
		PackedVector2Array([
			Vector2(403, 230),
			Vector2(450, 214),
			Vector2(450, 392),
			Vector2(368, 392),
			Vector2(388, 346),
			Vector2(382, 302),
		]),
		COLORS.cyan
	)
	draw_polyline(
		PackedVector2Array([
			Vector2(403, 230),
			Vector2(388, 270),
			Vector2(382, 302),
			Vector2(388, 346),
			Vector2(368, 392),
		]),
		COLORS.ink,
		3.0
	)
	draw_line(Vector2(420, 254), Vector2(445, 242), COLORS.paper, 2.0)
	draw_line(Vector2(410, 318), Vector2(442, 300), COLORS.paper, 2.0)
	draw_line(Vector2(396, 278), Vector2(446, 260), COLORS.violet, 3.0)
	draw_line(Vector2(396, 352), Vector2(438, 332), COLORS.violet, 3.0)

	# Settlement paths: a few broad lines instead of texture noise.
	for path_end in [
		Vector2(128, 158),
		Vector2(210, 144),
		Vector2(296, 166),
		Vector2(154, 242),
		Vector2(240, 230),
		Vector2(322, 252),
	]:
		draw_line(Vector2(232, 192), path_end, COLORS.ochre, 6.0)

	for index in PLOT_POSITIONS.size():
		_draw_plot_marker(index)

	_draw_crop_field(Vector2(42, 112))
	_draw_crop_field(Vector2(54, 276))
	_draw_crop_field(Vector2(334, 302))
	_draw_scrap_patch(Vector2(360, 112))
	_draw_scrap_patch(Vector2(72, 198))
	_draw_scrap_patch(Vector2(100, 330))

	# Existing tiny camp fabric makes the map read as a community.
	for hut_data in [
		[Vector2(178, 180), COLORS.paper],
		[Vector2(204, 188), COLORS.rust],
		[Vector2(250, 176), COLORS.paper],
		[Vector2(268, 204), COLORS.olive],
		[Vector2(190, 230), COLORS.rust],
		[Vector2(286, 252), COLORS.paper],
		[Vector2(126, 204), COLORS.olive],
		[Vector2(214, 164), COLORS.olive],
		[Vector2(242, 158), COLORS.rust],
		[Vector2(218, 214), COLORS.paper],
		[Vector2(250, 230), COLORS.rust],
		[Vector2(174, 210), COLORS.paper],
		[Vector2(302, 202), COLORS.olive],
		[Vector2(164, 270), COLORS.rust],
		[Vector2(264, 272), COLORS.paper],
		[Vector2(196, 292), COLORS.olive],
		[Vector2(328, 218), COLORS.paper],
	]:
		_draw_hut(hut_data[0], hut_data[1])
	_draw_hub(Vector2(228, 184))
	_draw_radio_mast(Vector2(342, 172))

	# Bottom report ledger.
	draw_rect(Rect2(0, 392, 640, 88), COLORS.paper)
	draw_rect(Rect2(4, 396, 410, 80), COLORS.paper)
	draw_rect(Rect2(4, 396, 410, 80), Color.TRANSPARENT, false, 1.0)
	draw_line(Vector2(414, 392), Vector2(414, 480), COLORS.ink, 2.0)
	draw_line(Vector2(520, 392), Vector2(520, 480), COLORS.ink, 2.0)


func _draw_crop_field(at: Vector2) -> void:
	for row in range(3):
		for column in range(5):
			draw_rect(
				Rect2(at + Vector2(column * 7 + row * 2, row * 5), Vector2(5, 3)),
				COLORS.olive
			)


func _draw_scrap_patch(at: Vector2) -> void:
	draw_rect(Rect2(at, Vector2(10, 6)), COLORS.metal)
	draw_rect(Rect2(at + Vector2(8, 3), Vector2(8, 5)), COLORS.rust)
	draw_rect(Rect2(at + Vector2(4, 7), Vector2(11, 3)), COLORS.ink)


func _draw_hut(at: Vector2, roof_color: Color) -> void:
	draw_rect(Rect2(at + Vector2(1, 5), Vector2(12, 7)), COLORS.ink)
	draw_colored_polygon(
		PackedVector2Array([
			at,
			at + Vector2(7, 0),
			at + Vector2(15, 6),
			at + Vector2(6, 6),
		]),
		roof_color
	)
	draw_rect(Rect2(at + Vector2(5, 7), Vector2(3, 5)), COLORS.shadow)


func _draw_hub(at: Vector2) -> void:
	draw_rect(Rect2(at, Vector2(24, 15)), COLORS.ink)
	draw_rect(Rect2(at + Vector2(2, 2), Vector2(20, 11)), COLORS.paper)
	draw_rect(Rect2(at + Vector2(8, 0), Vector2(8, 15)), COLORS.metal)
	draw_rect(Rect2(at + Vector2(10, 8), Vector2(4, 5)), COLORS.shadow)


func _draw_radio_mast(at: Vector2) -> void:
	draw_line(at, at + Vector2(0, 25), COLORS.ink, 2.0)
	draw_line(at + Vector2(-6, 5), at + Vector2(6, 5), COLORS.ink, 1.0)
	draw_line(at + Vector2(-4, 0), at + Vector2(4, 10), COLORS.rust, 1.0)
	draw_line(at + Vector2(4, 0), at + Vector2(-4, 10), COLORS.rust, 1.0)


func _draw_plot_marker(index: int) -> void:
	var at: Vector2 = PLOT_POSITIONS[index] + Vector2(5, 10)
	var color: Color = COLORS.ochre
	if pending_plot == index:
		color = COLORS.lantern
	elif selected_plot == index:
		color = COLORS.paper
	elif built_plots[index] != "":
		color = COLORS.line

	draw_polyline(
		PackedVector2Array([
			at + Vector2(5, 0),
			at + Vector2(37, 0),
			at + Vector2(44, 7),
			at + Vector2(44, 19),
			at + Vector2(37, 26),
			at + Vector2(5, 26),
			at + Vector2(0, 19),
			at + Vector2(0, 7),
			at + Vector2(5, 0),
		]),
		color,
		2.0 if selected_plot == index else 1.0
	)
	if pending_plot == index:
		draw_line(at + Vector2(7, 5), at + Vector2(35, 21), COLORS.lantern, 1.0)
		draw_line(at + Vector2(7, 21), at + Vector2(35, 5), COLORS.lantern, 1.0)


func _build_interface() -> void:
	turn_label = _make_label("", Vector2(8, 4), Vector2(128, 24), 12, COLORS.paper)
	population_label = _make_label("", Vector2(150, 4), Vector2(120, 24), 12, COLORS.paper)
	cohesion_label = _make_label("", Vector2(284, 4), Vector2(120, 24), 12, COLORS.paper)
	scrap_label = _make_label("", Vector2(418, 4), Vector2(100, 24), 12, COLORS.paper)
	var stage_label := _make_label("SETTLEMENT", Vector2(534, 4), Vector2(98, 24), 11, COLORS.lantern)
	stage_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT

	var build_title := _make_label("BUILD LEDGER", Vector2(458, 39), Vector2(174, 20), 14, COLORS.paper)
	build_title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	for index in BUILD_ORDER.size():
		var building_id: String = BUILD_ORDER[index]
		var data: Dictionary = BUILDINGS[building_id]
		var button := Button.new()
		button.position = Vector2(458, 64 + index * 42)
		button.size = Vector2(174, 40)
		button.pressed.connect(_select_building.bind(building_id))
		button.mouse_entered.connect(_preview_building.bind(building_id))
		button.mouse_exited.connect(_clear_hover_preview)
		_apply_button_style(button)
		add_child(button)

		var icon := TextureRect.new()
		icon.texture = load(data.texture)
		icon.position = Vector2(2, 0)
		icon.size = Vector2(48, 40)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP
		icon.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(icon)

		var ledger_label := Label.new()
		ledger_label.position = Vector2(54, 2)
		ledger_label.size = Vector2(116, 36)
		ledger_label.add_theme_font_size_override("font_size", 9)
		ledger_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
		ledger_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(ledger_label)
		building_buttons[building_id] = button
		building_labels[building_id] = ledger_label

	details_label = _make_label("", Vector2(458, 278), Vector2(174, 62), 10, COLORS.paper)
	details_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART

	build_button = Button.new()
	build_button.position = Vector2(458, 346)
	build_button.size = Vector2(174, 36)
	build_button.add_theme_font_size_override("font_size", 11)
	build_button.pressed.connect(_build_selected)
	_apply_button_style(build_button)
	add_child(build_button)

	for index in PLOT_POSITIONS.size():
		var button := Button.new()
		button.position = PLOT_POSITIONS[index]
		button.size = Vector2(54, 46)
		button.add_theme_font_size_override("font_size", 9)
		button.pressed.connect(_select_plot.bind(index))
		button.mouse_entered.connect(_preview_plot.bind(index))
		button.mouse_exited.connect(_clear_hover_preview)
		_apply_plot_style(button, index == selected_plot)
		add_child(button)
		plot_buttons.append(button)

	report_label = _make_label("", Vector2(12, 400), Vector2(394, 70), 11, COLORS.ink)
	report_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	report_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	var pressure_label := _make_label("PRESSURE\nLOW\n\nTHREAT\nRAIDERS", Vector2(424, 402), Vector2(86, 72), 10, COLORS.ink)
	pressure_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER

	end_turn_button = Button.new()
	end_turn_button.position = Vector2(530, 410)
	end_turn_button.size = Vector2(100, 52)
	end_turn_button.text = "END TURN"
	end_turn_button.add_theme_font_size_override("font_size", 13)
	end_turn_button.pressed.connect(_end_turn)
	_apply_button_style(end_turn_button, true)
	add_child(end_turn_button)


func _make_label(
	text_value: String,
	at: Vector2,
	extent: Vector2,
	font_size: int,
	font_color: Color
) -> Label:
	var label := Label.new()
	label.text = text_value
	label.position = at
	label.size = extent
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", font_color)
	add_child(label)
	return label


func _style_box(background: Color, border: Color, width: int = 1) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(width)
	style.corner_radius_top_left = 0
	style.corner_radius_top_right = 0
	style.corner_radius_bottom_left = 0
	style.corner_radius_bottom_right = 0
	return style


func _apply_button_style(button: Button, primary: bool = false) -> void:
	var normal_bg: Color = COLORS.paper if primary else COLORS.panel_2
	var normal_fg: Color = COLORS.ink if primary else COLORS.paper
	button.add_theme_stylebox_override("normal", _style_box(normal_bg, COLORS.line))
	button.add_theme_stylebox_override("hover", _style_box(COLORS.line, COLORS.paper, 2))
	button.add_theme_stylebox_override("pressed", _style_box(COLORS.ochre, COLORS.paper, 2))
	button.add_theme_stylebox_override("focus", _style_box(normal_bg, COLORS.lantern, 2))
	button.add_theme_stylebox_override("disabled", _style_box(COLORS.panel, COLORS.line))
	button.add_theme_color_override("font_color", normal_fg)
	button.add_theme_color_override("font_hover_color", COLORS.white)
	button.add_theme_color_override("font_pressed_color", COLORS.shadow)
	button.add_theme_color_override("font_disabled_color", COLORS.muted)


func _apply_plot_style(button: Button, selected: bool) -> void:
	var transparent := Color(0, 0, 0, 0)
	button.add_theme_stylebox_override("normal", _style_box(transparent, transparent, 0))
	button.add_theme_stylebox_override("hover", _style_box(Color(0, 0, 0, 0.15), transparent, 0))
	button.add_theme_stylebox_override("pressed", _style_box(Color(0, 0, 0, 0.25), transparent, 0))
	button.add_theme_stylebox_override("focus", _style_box(transparent, transparent, 0))
	button.add_theme_color_override("font_color", COLORS.paper if selected else COLORS.ink)
	button.add_theme_color_override("font_hover_color", COLORS.white)


func _select_building(building_id: String) -> void:
	selected_building = building_id
	hover_preview_text = ""
	_refresh_interface()


func _select_plot(plot_index: int) -> void:
	selected_plot = plot_index
	hover_preview_text = ""
	_refresh_interface()


func _preview_building(building_id: String) -> void:
	var data: Dictionary = BUILDINGS[building_id]
	hover_preview_text = "%s / %d SCRAP / %d LABOR\n+%d %s / +%d COHESION\n%s" % [
		data.name,
		data.cost,
		data.labor,
		data.effect_value,
		data.effect_label,
		data.cohesion,
		data.description,
	]
	_refresh_details()


func _preview_plot(index: int) -> void:
	if pending_plot == index:
		var pending_data: Dictionary = BUILDINGS[pending_building]
		hover_preview_text = "PLOT %d / %s QUEUED\nCONDITION: WORK SITE\nCOMPLETES AT END TURN" % [
			index + 1,
			pending_data.name,
		]
	elif built_plots[index] == "":
		var selected_data: Dictionary = BUILDINGS[selected_building]
		hover_preview_text = "PLOT %d / EMPTY\nCONDITION: BUILDABLE\nPREVIEW: +%d %s" % [
			index + 1,
			selected_data.effect_value,
			selected_data.effect_label,
		]
	else:
		var building_id := built_plots[index]
		var data: Dictionary = BUILDINGS[building_id]
		hover_preview_text = "PLOT %d / %s\nCONDITION: STABLE\nOUTPUT: +%d %s" % [
			index + 1,
			data.name,
			data.effect_value,
			data.effect_label,
		]
	_refresh_details()


func _clear_hover_preview() -> void:
	hover_preview_text = ""
	_refresh_details()


func _build_selected() -> void:
	if pending_building != "":
		pending_building = ""
		pending_plot = -1
		reserved_workers = 0
		last_resolution = "ORDER CANCELED / NO SCRAP SPENT"
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
	last_resolution = "%s QUEUED ON PLOT %d" % [data.name, selected_plot + 1]
	_refresh_interface()


func _end_turn() -> void:
	turn += 1
	if pending_building == "":
		last_resolution = "TURN ADVANCED / NO PROJECT"
		_refresh_interface()
		return

	var data: Dictionary = BUILDINGS[pending_building]
	built_plots[pending_plot] = pending_building
	scrap -= data.cost
	_apply_building_effect(data.effect_key, data.effect_value)
	cohesion = mini(100, cohesion + data.cohesion)
	reserved_workers = 0
	last_resolution = "%s COMPLETE / +%d %s / +%d COHESION" % [
		data.name,
		data.effect_value,
		data.effect_label,
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
	turn_label.text = "TURN  %d / 40" % turn
	population_label.text = "POP  %d / %d" % [population, shelter_capacity]
	cohesion_label.text = "COHESION  %d%%" % cohesion
	scrap_label.text = "SCRAP  %d" % scrap

	for building_id in BUILD_ORDER:
		var button: Button = building_buttons[building_id]
		var ledger_label: Label = building_labels[building_id]
		var data: Dictionary = BUILDINGS[building_id]
		button.text = ""
		ledger_label.text = "%s%s\n%dS / %dL" % [
			"> " if building_id == selected_building else "",
			data.name,
			data.cost,
			data.labor,
		]
		ledger_label.add_theme_color_override(
			"font_color",
			COLORS.lantern if building_id == selected_building else COLORS.paper
		)

	for index in plot_buttons.size():
		_refresh_plot(index)

	var selected_data: Dictionary = BUILDINGS[selected_building]
	_refresh_details()

	if pending_building != "":
		build_button.disabled = false
		build_button.text = "CANCEL ORDER"
	elif built_plots[selected_plot] != "":
		build_button.disabled = true
		build_button.text = "PLOT OCCUPIED"
	elif scrap < selected_data.cost:
		build_button.disabled = true
		build_button.text = "NEEDS %d SCRAP" % (selected_data.cost - scrap)
	elif available_workforce < selected_data.labor:
		build_button.disabled = true
		build_button.text = "NEEDS %d LABOR" % selected_data.labor
	else:
		build_button.disabled = false
		build_button.text = "QUEUE / PLOT %d" % (selected_plot + 1)

	var spare_capacity := shelter_capacity - population
	var arrival_ready := (
		spare_capacity >= 6
		and food_capacity >= 50
		and health >= 50
		and cohesion >= 50
	)
	var arrival_outlook := "ARRIVALS FAVORED" if arrival_ready else "GROWTH PRESSURED"
	report_label.text = (
		"POPULATION  %d    SHELTER  %d    FREE LABOR  %d\n"
		+ "HEALTH  %d    FOOD OUTPUT  %d    %s\n"
		+ "%s"
	) % [
		population,
		shelter_capacity,
		available_workforce - reserved_workers,
		health,
		food_capacity,
		arrival_outlook,
		last_resolution,
	]
	queue_redraw()


func _refresh_details() -> void:
	if hover_preview_text != "":
		details_label.text = hover_preview_text
		return

	var selected_data: Dictionary = BUILDINGS[selected_building]
	details_label.text = "%s\n+%d %s / +%d COHESION\n%d TURN / %s" % [
		selected_data.name,
		selected_data.effect_value,
		selected_data.effect_label,
		selected_data.cohesion,
		selected_data.turns,
		selected_data.description,
	]


func _refresh_plot(index: int) -> void:
	var button: Button = plot_buttons[index]
	for child in button.get_children():
		child.queue_free()

	_apply_plot_style(button, index == selected_plot)

	if pending_plot == index:
		var pending_data: Dictionary = BUILDINGS[pending_building]
		button.text = "PENDING\n%s" % pending_data.name
	elif built_plots[index] == "":
		button.text = "P%d" % (index + 1)
	else:
		var building_id := built_plots[index]
		var data: Dictionary = BUILDINGS[building_id]
		button.text = ""

		var texture_rect := TextureRect.new()
		texture_rect.texture = load(data.texture)
		texture_rect.position = Vector2(3, 3)
		texture_rect.size = Vector2(48, 40)
		texture_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		texture_rect.stretch_mode = TextureRect.STRETCH_KEEP
		texture_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		button.add_child(texture_rect)
