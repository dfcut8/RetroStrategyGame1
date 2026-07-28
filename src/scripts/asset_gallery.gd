extends Node2D

const COLORS := {
	"shadow": Color("#09080d"),
	"ink": Color("#17141f"),
	"panel": Color("#24202d"),
	"panel_2": Color("#302a3a"),
	"paper": Color("#e4ddcc"),
	"muted": Color("#aaa2b2"),
	"line": Color("#5d536b"),
	"violet": Color("#8a7fc8"),
	"ochre": Color("#c58b32"),
	"rust": Color("#b55737"),
	"cyan": Color("#65c6bd"),
	"olive": Color("#8d9652"),
	"white": Color("#f4efe2"),
}

const GROUND := preload("res://assets/textures/camp_ground.png")

const ASSETS := [
	{
		"texture": preload("res://assets/sprites/camp/tarp_shelter.png"),
		"position": Vector2(128, 196),
		"label": "TARP SHELTER",
		"tag": "MAKESHIFT",
	},
	{
		"texture": preload("res://assets/sprites/camp/water_collector.png"),
		"position": Vector2(272, 196),
		"label": "WATER COLLECTOR",
		"tag": "+ WATER",
	},
	{
		"texture": preload("res://assets/sprites/camp/scrap_cache.png"),
		"position": Vector2(416, 196),
		"label": "SCRAP CACHE",
		"tag": "+ SCRAP",
	},
	{
		"texture": preload("res://assets/sprites/camp/permanent_hub.png"),
		"position": Vector2(536, 188),
		"label": "PERMANENT HUB",
		"tag": "MILESTONE",
	},
]

const FONT := {
	"A": ["01110", "10001", "10001", "11111", "10001", "10001", "10001"],
	"B": ["11110", "10001", "10001", "11110", "10001", "10001", "11110"],
	"C": ["01111", "10000", "10000", "10000", "10000", "10000", "01111"],
	"D": ["11110", "10001", "10001", "10001", "10001", "10001", "11110"],
	"E": ["11111", "10000", "10000", "11110", "10000", "10000", "11111"],
	"F": ["11111", "10000", "10000", "11110", "10000", "10000", "10000"],
	"G": ["01111", "10000", "10000", "10111", "10001", "10001", "01111"],
	"H": ["10001", "10001", "10001", "11111", "10001", "10001", "10001"],
	"I": ["11111", "00100", "00100", "00100", "00100", "00100", "11111"],
	"J": ["00111", "00010", "00010", "00010", "10010", "10010", "01100"],
	"K": ["10001", "10010", "10100", "11000", "10100", "10010", "10001"],
	"L": ["10000", "10000", "10000", "10000", "10000", "10000", "11111"],
	"M": ["10001", "11011", "10101", "10101", "10001", "10001", "10001"],
	"N": ["10001", "11001", "10101", "10011", "10001", "10001", "10001"],
	"O": ["01110", "10001", "10001", "10001", "10001", "10001", "01110"],
	"P": ["11110", "10001", "10001", "11110", "10000", "10000", "10000"],
	"Q": ["01110", "10001", "10001", "10001", "10101", "10010", "01101"],
	"R": ["11110", "10001", "10001", "11110", "10100", "10010", "10001"],
	"S": ["01111", "10000", "10000", "01110", "00001", "00001", "11110"],
	"T": ["11111", "00100", "00100", "00100", "00100", "00100", "00100"],
	"U": ["10001", "10001", "10001", "10001", "10001", "10001", "01110"],
	"V": ["10001", "10001", "10001", "10001", "10001", "01010", "00100"],
	"W": ["10001", "10001", "10001", "10101", "10101", "10101", "01010"],
	"X": ["10001", "10001", "01010", "00100", "01010", "10001", "10001"],
	"Y": ["10001", "10001", "01010", "00100", "00100", "00100", "00100"],
	"0": ["01110", "10001", "10011", "10101", "11001", "10001", "01110"],
	"4": ["00110", "01010", "10010", "11111", "00010", "00010", "00010"],
	"6": ["01110", "10000", "10000", "11110", "10001", "10001", "01110"],
	"+": ["00000", "00100", "00100", "11111", "00100", "00100", "00000"],
	":": ["00000", "00100", "00100", "00000", "00100", "00100", "00000"],
	"-": ["00000", "00000", "00000", "11111", "00000", "00000", "00000"],
	"/": ["00001", "00010", "00100", "01000", "10000", "00000", "00000"],
	" ": ["00000", "00000", "00000", "00000", "00000", "00000", "00000"],
}


func _ready() -> void:
	get_viewport().canvas_item_default_texture_filter = Viewport.DEFAULT_CANVAS_ITEM_TEXTURE_FILTER_NEAREST
	queue_redraw()


func _draw() -> void:
	if GROUND:
		draw_texture(GROUND, Vector2(0, 40))
	else:
		draw_rect(Rect2(0, 40, 640, 360), Color("#8f6427"))

	_draw_status_bar()
	_draw_asset_cards()
	_draw_footer()


func _draw_status_bar() -> void:
	draw_rect(Rect2(0, 0, 640, 40), COLORS.ink)
	draw_rect(Rect2(0, 38, 640, 2), COLORS.ochre)
	_draw_text("ASHFALL // CAMP ASSET KIT", Vector2(8, 9), COLORS.white, 2)
	_draw_text("640X480 / NATIVE", Vector2(454, 13), COLORS.cyan, 1)


func _draw_asset_cards() -> void:
	for asset in ASSETS:
		var position: Vector2 = asset.position
		var texture: Texture2D = asset.texture
		draw_rect(Rect2(position.x - 58, 106, 116, 176), Color(COLORS.shadow, 0.55))
		draw_rect(Rect2(position.x - 56, 104, 112, 176), COLORS.panel)
		draw_rect(Rect2(position.x - 56, 104, 112, 2), COLORS.line)
		draw_rect(Rect2(position.x - 56, 260, 112, 20), COLORS.panel_2)
		if texture:
			var top_left := position - Vector2(texture.get_width(), texture.get_height()) / 2.0
			draw_texture(texture, top_left.round())
		_draw_text(asset.label, Vector2(position.x - 50, 242), COLORS.paper, 1)
		_draw_text(asset.tag, Vector2(position.x - 50, 266), COLORS.ochre, 1)


func _draw_footer() -> void:
	draw_rect(Rect2(0, 400, 640, 80), COLORS.ink)
	draw_rect(Rect2(0, 400, 640, 2), COLORS.line)
	_draw_text("INITIAL CAMP ASSETS", Vector2(8, 414), COLORS.violet, 2)
	_draw_text("LIMITED PALETTE / HARD PIXELS / NO SCALING", Vector2(8, 448), COLORS.muted, 1)


func _draw_text(text: String, origin: Vector2, color: Color, scale: int) -> void:
	var cursor := origin
	for character in text.to_upper():
		var glyph: Array = FONT.get(character, FONT[" "])
		for row in range(glyph.size()):
			for column in range(5):
				if glyph[row][column] == "1":
					draw_rect(
						Rect2(cursor + Vector2(column, row) * scale, Vector2.ONE * scale),
						color
					)
		cursor.x += 6 * scale
