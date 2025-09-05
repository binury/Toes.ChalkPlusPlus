# Copyright (c) 2025 binury
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

extends Node

signal changed_mode
signal changed_mask
signal applied_drawing

onready var Players = get_node("/root/ToesSocks/Players")
onready var Chat = get_node("/root/ToesSocks/Chat")
onready var main = get_node("/root/ToesChalkPlusPlus")

onready var Lure = get_node_or_null("/root/SulayreLure")
onready var ChromaChalk = get_node_or_null("/root/adamantrisChromaChalk")
onready var CC_API = ChromaChalk.get_node_or_null("Color_API")
# /root/adamantrisColorfulChalk/Color_API
# var UI

enum COLORS { WHITE, BLACK, RED, BLUE, YELLOW, SPECIAL, GREEN, NONE = -1 }
const COLOR_NAMES = ["white", "black", "red", "blue", "yellow", "special", "green"]

enum MODES { NONE, DITHER_CHECKER, DITHER_DOT, MASK, FILL, LINE, MIRROR }
const END_OF_MODES_INDEX = MODES.MIRROR
const MODE_NAMES = {
	MODES.NONE: "Off",
	MODES.DITHER_CHECKER: "Checkerboard (Half) Brush",
	MODES.DITHER_DOT: "Dotting (1/9th) Brush",
	MODES.MASK: "Freehand Masking",
	MODES.FILL: "Bucket Fill",
	MODES.LINE: "Line Tool",
	MODES.MIRROR: "Symmetrical Mirroring",
}

## Drawing stylus
var pen_is_connected := false
var last_pressure_reading := 0.0

var local_player: Node
var paint_node: Spatial

var chalk_canvasses := []
var chalk_canvas_node: Spatial
var GridMap_node: GridMap
var TileMap_node: TileMap
var chalk_canvas_id: int
var current_zone := "main_zone"
var mouse_pos: Vector3
var last_grid_pos: Vector2

## Whether or not holding eraser should count the same as a chalk
var should_use_eraser_as_chalk := true

var pencil_scene := preload("res://mods/Toes.ChalkPlusPlus/scenes/DrawingSound.tscn")
var chalk_long_scene := preload("res://mods/Toes.ChalkPlusPlus/scenes/ChalkSoundLong.tscn")
var chalk_short_scene := preload("res://mods/Toes.ChalkPlusPlus/scenes/ChalkSoundShort.tscn")
var audio_scenes = {
	"chalk_long": {"scene": chalk_long_scene, "db": -6.5},
	"chalk_short": {"scene": chalk_short_scene, "db": -5},
	"pencil": {"scene": pencil_scene, "db": -14.0},
}
var player
var CHALK_ITEMS := {
	"chalk_eraser": COLORS.NONE,
	"chalk_white": COLORS.WHITE,
	"chalk_black": COLORS.BLACK,
	"chalk_red": COLORS.RED,
	"chalk_blue": COLORS.BLUE,
	"chalk_yellow": COLORS.YELLOW,
	"chalk_special": COLORS.SPECIAL,
	"chalk_green": COLORS.GREEN
}
## Masking colors index lookup (find)
const masks := [
	COLORS.NONE,
	COLORS.WHITE,
	COLORS.BLACK,
	COLORS.RED,
	COLORS.GREEN,
	COLORS.BLUE,
	COLORS.YELLOW,
	COLORS.SPECIAL
]
## Masking color names lookup
const mask_names := {
	-1: "Alpha",
	COLORS.WHITE: "White",
	COLORS.BLACK: "Black",
	COLORS.RED: "Red",
	COLORS.GREEN: "Green",
	COLORS.BLUE: "Blue",
	COLORS.YELLOW: "Yellow",
	COLORS.SPECIAL: "Special",
}
var extra_color_names := {

}

## Index of color
var mask_selection := 0
## Masking color / chalk canvas value
var masking_color: int = COLORS.NONE

var current_mode: int = MODES.NONE

export var chroma_chalk_tile: int = INF
export var chroma_chalk_code: String = ""
export var chroma_chalk_name: String = ""

var mouse1_is_held := false
var alt_is_held := false
var control_is_held := false
var shift_is_held := false

var last_hover_pos := Vector2.INF
var last_hover_color := INF

## Shortcut is held
var eraser_shortcut_requested := false
## Eraser is online
var eraser_shortcut_active := false

## Origin point of player's current line
var line_tool_origin: Vector2 = Vector2.INF

## The originating mode
var temp_chalk_mode := -1
## The canvas (id) to apply the preview
var temp_chalk_canvas_id := -1
## Preview tiles history, for undoing
var temp_chalk_tiles := []


func _debug(msg, data = null):
	if not main.DEBUG:
		return
	print("[CHALK++]: %s" % msg)
	if data != null:
		print(JSON.print(data, "\t"))


func _ready():
	main.connect("cycle_chalk_mode", self, "cycle_chalk_mode")
	Players.connect("ingame", self, "_on_ingame")
	Players.connect("outgame", self, "_on_outgame")
	self.set_process_unhandled_input(true)
	should_use_eraser_as_chalk = main.config["useEraserAsChalk"]



func _input(event: InputEvent):
	if event is InputEventKey:
		match event.scancode:
			KEY_SHIFT:
				shift_is_held = event.is_pressed()
			KEY_CONTROL:
				control_is_held = event.is_pressed()

			## Don't try to do these here. it doesn't work well- use process
#			KEY_ALT:
#				alt_is_held = event.is_pressed()

	elif event is InputEventMouseButton:
		if alt_is_held:
			if Input.is_action_just_released("zoom_in"):
				local_player.camera_zoom += 0.5
			cycle_mask(false)
			if Input.is_action_just_released("zoom_out"):
				local_player.camera_zoom -= 0.5
			cycle_mask(true)

	elif event is InputEventMouseMotion and main.config["experimentalStylusControls"]:
		last_pressure_reading = event.pressure
		if last_pressure_reading > 0.0:
			if pen_is_connected == false:
				Chat.notify("[Chalk++] Detected drawing stylus -- Experimental controls activated!")
				Chat.write("[Chalk++] Detected drawing stylus -- Experimental controls activated!")
			_debug("last pressure reading %s" % last_pressure_reading)
			pen_is_connected = true


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT:
			mouse1_is_held = event.is_pressed()
			if not mouse1_is_held:
				self._stop_sounds()
				last_grid_pos = Vector2.INF


func _notify(msg: String) -> void:
	return
	Chat.notify("[Chalk++] " + msg)


func vec2_has_inf(v: Vector2) -> bool:
	return is_inf(v.x) or is_inf(v.y)


func _on_ingame() -> void:
	randomize()
	get_canvasses()
	# UI = get_node("/root/Chalk++ UI")
	# UI.connect("scrolled_up", self, "cycle_chalk_mode", [false])
	# UI.connect("scrolled_down", self, "cycle_chalk_mode", [true])

	var paint: Spatial = Players.local_player.get_node("paint_node")
	var audio = _get_random_sound()
	paint.add_child(audio.scene.instance(), true)


func _on_outgame() -> void:
	chalk_canvasses.clear()
	set_canvas(-1)
	last_grid_pos = Vector2.INF
	line_tool_origin = Vector2.INF

	set_mode(MODES.NONE)
	set_mask_color(COLORS.NONE)

	# Just in case?
	last_pressure_reading = 0.0
	pen_is_connected = false


func _process(__) -> void:
	if Lure != null and ChromaChalk != null:
		chroma_chalk_tile = CC_API.get_chalk_color()
		chroma_chalk_code = CC_API.get_string_by_id(chroma_chalk_tile)
		chroma_chalk_name = main.color_db.find_name_for_color(chroma_chalk_code)


func _physics_process(__: float) -> void:
	# To prevent any accidents...
	if not OS.is_window_focused():
		# TODO: Test this approach for conflict with auto-fishing mod
		mouse1_is_held = false
#		Input.action_release('primary_action')
		alt_is_held = false
		Input.action_release("move_sneak")
		control_is_held = false
		Input.action_release("move_walk")
		shift_is_held = false
		Input.action_release("move_sprint")

	alt_is_held = Input.is_key_pressed(KEY_ALT)
	eraser_shortcut_requested = Input.is_action_pressed("cpp_erase") and not Players.is_busy()
	if Players.in_game == false:
		return
	local_player = Players.local_player

	paint_node = local_player.get_node("paint_node")
	if not paint_node:
		return

	if current_mode != MODES.LINE:
		_reset_line_origin()
		# _undo_temp_paint()

	if temp_chalk_mode != current_mode:
		_undo_temp_paint()

	mouse_pos = paint_node.global_transform.origin
	var canvas_id = find_canvas_id(mouse_pos)
	if canvas_id < 0:
		# Do this as two separate steps so that we don't
		# immediately clear the canvas every we look away from it.
		# This is important to facilitate the delayed fill...
		# So that looking away from the canvas doesn't stop an in-progress fill.
		return
	set_canvas(canvas_id)
	if not chalk_canvas_node:
		return

	var held_chalk_color = get_held_chalk_color()
	activate_cpp(
		(
			current_mode != MODES.NONE
			and (held_chalk_color == null or (held_chalk_color > -1 or should_use_eraser_as_chalk))
		)
	)
	var cpp_active = chalk_canvas_node.paused
	var hovered_canvas_vector = _get_hovered_canvas_vector()
	if vec2_has_inf(hovered_canvas_vector):
		_undo_temp_paint()  # If any
		return

	var should_render_new_preview = (
		cpp_active
		and held_chalk_color != null
		and current_mode == MODES.LINE
		and (!last_hover_pos.is_equal_approx(hovered_canvas_vector) or !last_hover_color == held_chalk_color)
		and not alt_is_held
	)
	last_hover_pos = hovered_canvas_vector
	if should_render_new_preview:
		_undo_temp_paint()
		_preview_paint(draw_line([[hovered_canvas_vector.x, hovered_canvas_vector.y, held_chalk_color]]), canvas_id)
		last_hover_color = held_chalk_color

	if cpp_active:
		apply_chalkpp()


func _get_random_sound() -> Dictionary:
	var scene_names: Array = audio_scenes.keys()
	var selected_scene: String = scene_names[randi() % scene_names.size()]
	var audio: Dictionary = audio_scenes[selected_scene]
	return audio


func _play_random_section():
	if is_instance_valid(player) and player.playing or main.config["drawingSounds"] == false:
		return
	var audio = _get_random_sound()
	player = audio.scene.instance()
	player.unit_db = audio.db
	var start_time = rand_range(0, player.stream.get_length() - 2.0)  # ensure at least 2s left
	player.seek(start_time)
	player.play()

	var paint: Spatial = Players.local_player.get_node("paint_node")
	paint.add_child(player, true)


func _stop_sounds() -> void:
	if is_instance_valid(player) and player.playing:
		player.stop()
		player.queue_free()
		var paint: Spatial = Players.local_player.get_node("paint_node")
		paint.remove_child(player)


func activate_cpp(active: bool) -> void:
	for canvas in chalk_canvasses:
		canvas.paused = active
		# Optional Features:
		var mi: MeshInstance = canvas.get_child(2)
		var mi_mat: SpatialMaterial = mi["material/0"]
		mi_mat["flags_albedo_tex_force_srgb"] = main.config.get("useFixedChalkTextures", false)
		mi_mat["flags_unshaded"] = main.config.get("glowInTheDarkChalk", true)
	_set_spawn_prop_visibility(!active)


func get_held_chalk() -> String:
	var held_item = local_player.held_item["id"]
	return held_item if held_item in CHALK_ITEMS.keys() else null


func get_held_chalk_color() -> String:
	var chalk := get_held_chalk()
	return CHALK_ITEMS[chalk] if chalk != null else null


func cycle_chalk_mode(forward = true) -> void:
	if Players.is_busy():
		return

	var mode_to_set: int
	if forward:
		mode_to_set = MODES.NONE if current_mode == END_OF_MODES_INDEX else (current_mode + 1)
	else:
		mode_to_set = END_OF_MODES_INDEX if current_mode == MODES.NONE else (current_mode - 1)
	set_mode(mode_to_set)


func set_mode(mode: int = MODES.NONE) -> void:
	if current_mode == mode:
		return
	current_mode = mode
	emit_signal("changed_mode", current_mode)


## false = -1, true = +1
func cycle_mask(forward: bool = true):
	var selection: int
	if forward:
		selection = 0 if mask_selection == (masks.size() - 1) else (mask_selection + 1)
	else:
		selection = masks.size() - 1 if mask_selection == 0 else (mask_selection - 1)
	set_mask(selection)


func set_mask_color(color: int = COLORS.NONE) -> void:
	var selection = masks.find(color)
	if selection == -1:
		if ChromaChalk != null:
			mask_selection = selection
			masking_color = color

			# Might need to set chalk color too later
			# CC_API.set_chalk_color(color)

			# chroma_chalk_code = CC_API.get_string_by_id(chroma_chalk_tile)
			# chroma_chalk_name = main.color_db.find_name_for_color(chroma_chalk_code)
			# _debug("Now using %s as mask" % chroma_chalk_name)
			chroma_chalk_tile = color
			emit_signal("changed_mask", mask_selection)
			return
		else:
			breakpoint
	set_mask(selection)



func set_mask(selection: int) -> void:
	if mask_selection == selection:
		_debug("Skipping new mask selection", selection)
		# TODO: Throttle instead to prevent dupe notifications
		return
	_debug("Setting new mask", selection)
	mask_selection = selection
	masking_color = masks[mask_selection]
	var mask_name = mask_names[masking_color]
	emit_signal("changed_mask", mask_selection)
	_notify("Now using " + mask_name + " mask")


func find_canvas_id(pos: Vector3) -> int:
	var x = pos.x
	var z = pos.z

	var canvas_id := -1
	if current_zone == "main_zone":
		if (x > 38.572 and x < 58.572) and (z > -61.041 and z < -41.041):
			canvas_id = 0
		elif (x > 59.572 and x < 79.572) and (z > -64.953 and z < -44.953):
			canvas_id = 1
		elif (x > -64.7896 and x < -44.7896) and (z > -125.719 and z < -105.719):
			canvas_id = 2
		elif (x > -35.7811 and x < -15.7811) and (z > -44.5681 and z < -24.5681):
			canvas_id = 3
	return canvas_id


func get_canvasses() -> Array:
	chalk_canvasses.clear()
	var scene = get_tree().current_scene
	for canvas_name in ["", "2", "3", "4"]:
		var canvas = scene.get_node_or_null(
			"Viewport/main/map/main_map/zones/main_zone/chalk_zones/chalk_canvas" + canvas_name
		)
		chalk_canvasses.append(canvas)
	return chalk_canvasses


func set_canvas(canvas_id: int) -> void:
	if canvas_id in range(4):
		var canvasses := get_canvasses() if chalk_canvasses.empty() else chalk_canvasses
		if canvasses[canvas_id]:
			chalk_canvas_node = canvasses[canvas_id]
			chalk_canvas_id = canvas_id
			TileMap_node = chalk_canvas_node.get_node("Viewport/TileMap")
			GridMap_node = chalk_canvas_node.get_node("GridMap")
	else:
		chalk_canvas_id = -1
		chalk_canvas_node = null
		TileMap_node = null
		GridMap_node = null


## Returns the horizontal midpoint
func get_canvas_midpoint() -> int:
	# These are all eyeballed approximations
	match chalk_canvas_id:
		_, 0:
			return 100
		1:
			return 50
		2:
			return 80
		3:
			return 90


func _get_hovered_canvas_vector() -> Vector2:
	mouse_pos = paint_node.global_transform.origin
	var grid_diff = chalk_canvas_node.global_transform.origin - mouse_pos
	if grid_diff.length() > chalk_canvas_node.canvas_size:
		return Vector2.INF

	var x = int(floor(100 - grid_diff.x * 10))
	var z = int(floor(100 - grid_diff.z * 10))
	var pos := Vector2(x, z)
	return pos


func apply_chalkpp():
	if not mouse1_is_held:
		last_grid_pos = Vector2.INF
	if not (mouse1_is_held or eraser_shortcut_requested):
		self._stop_sounds()

	var size = 1

	if current_mode in [MODES.MASK] or eraser_shortcut_requested:
		size = 2
		if shift_is_held:
			size = 4
		elif control_is_held:
			size = 1

	# TODO: Refactor this out - duplicate code in _get_hovered_canvas_vector
	mouse_pos = paint_node.global_transform.origin

	var grid_diff = chalk_canvas_node.global_transform.origin - mouse_pos
	if grid_diff.length() > chalk_canvas_node.canvas_size:
		# if mouse1_is_held: Chat.notify("You can't draw here")
		return

	var x = int(floor(100 - grid_diff.x * 10))
	var z = int(floor(100 - grid_diff.z * 10))
	var new_grid_pos := Vector2(x, z)

	var data := []

	# Mouse left chalk area handling/tickrate compensation, copied from Player _chalk_draw
	if last_grid_pos and not is_inf(last_grid_pos.x):
		var dist = last_grid_pos.distance_to(new_grid_pos)
		var steps = 1 + int(floor(dist / size))
		for step in range(steps):
			var direction = (last_grid_pos - new_grid_pos).normalized()
			var interpolation = new_grid_pos + direction * (step * size)
			var ix = int(interpolation.x)
			var iz = int(interpolation.y)

			for dx in range(size):
				for dz in range(size):
					data.append([ix + dx, iz + dz, get_held_chalk_color()])
	else:
		for dx in range(size):
			for dz in range(size):
				data.append([x + dx, z + dz, get_held_chalk_color()])

	if eraser_shortcut_requested:
		eraser_shortcut_active = true
		for cell in data:
			cell[2] = -1
		_update_canvas_node(data, chalk_canvas_id)
		emit_signal("applied_drawing")
		eraser_shortcut_active = false

	if get_held_chalk_color() == null:
		return
	elif mouse1_is_held:
		var cell = data[0]

		# Masking color picker
		if alt_is_held:
			var current_cell_color = TileMap_node.get_cell(cell[0], cell[1])
			set_mask_color(current_cell_color)
			return

		match current_mode:
			MODES.DITHER_DOT:
				data = dotting_brush(data)

			MODES.DITHER_CHECKER:
				data = checkerboard_brush(data)

			MODES.MASK:
				data = masking_tool(data)

			MODES.FILL:
				var painting = paint_bucket(data)  # TODO Throttling

			MODES.LINE:
				if vec2_has_inf(line_tool_origin):
					_set_line_origin(Vector2(cell[0], cell[1]))
					_debug("Line origin was set to a new pos")
					data = draw_line(data)
				else:
					data = []
					# (Waiting on endpoint, mouse button release)
			MODES.MIRROR:
				data = mirror_tool(data)

		emit_signal("applied_drawing")
		_update_canvas_node(data, chalk_canvas_id)
		last_grid_pos = new_grid_pos
	else:
		# Mouse up
		match current_mode:
			MODES.DITHER_DOT:
				pass
			MODES.DITHER_CHECKER:
				pass
			MODES.MASK:
				pass
			MODES.FILL:
				pass
			MODES.MIRROR:
				pass
			MODES.LINE:
				if not(vec2_has_inf(line_tool_origin) or temp_chalk_tiles.empty()):
					data = _apply_temp_paint()
					_reset_line_origin()
					_update_canvas_node(data, chalk_canvas_id)


func checkerboard_brush(transformations, offset = shift_is_held):
	var result := []
	for entry in transformations:
		var x = entry[0]
		var y = entry[1]
		if control_is_held:
			var current_cell_color = TileMap_node.get_cell(x, y)
			if current_cell_color != masking_color:
				continue
		if ((x + y) + (1 if offset else 0)) % 2 == 0:
			result.append(entry)
	return result


func dotting_brush(transformations):
	var result := []
	for entry in transformations:
		var x = entry[0]
		var y = entry[1]
		var color = entry[2]
		if control_is_held:
			var current_cell_color = TileMap_node.get_cell(x, y)
			if current_cell_color != masking_color:
				continue
		if x % 2 == 0 or y % 2 == 0:
			continue
		result.append(entry)
	return result


func masking_tool(data: Array) -> Array:
	var result := []
	for node in data:
		var x = node[0]
		var y = node[1]
		var current_cell_color = TileMap_node.get_cell(x, y)
		if current_cell_color != masking_color:
			continue
		result.append(node)
	return result


func _in_bounds(x: int, y: int) -> bool:
	var should_use_offset_hack = chalk_canvas_node != chalk_canvasses[0]
	var width = (chalk_canvas_node.canvas_boundry * 2) + (12 if should_use_offset_hack else 0)
	var height = width
	var center_x = width / 2.0  # TODO
	var center_y = height / 2.0  # TODO
	var radius = width / 2.0
	var radius_sq = radius * radius
	if x < 0 or x >= width or y < 0 or y >= height:
		return false

	var dx = x - center_x
	var dy = y - center_y
	return (dx * dx + dy * dy) <= radius_sq


## ! Mutates transformations arg - This is in order to yield and throttle fills
func paint_bucket(transformations: Array) -> Array:
	var limit = 25000
	var iterations = 0

	var start = transformations[0]
	var start_x = start[0]
	var start_y = start[1]
	var new_color = start[2]
	transformations.clear()

	var target_color = TileMap_node.get_cell(start_x, start_y)

	if target_color == new_color:
		return transformations
	if chalk_canvasses[1] == chalk_canvas_node:
		# TODO: Throttle this
		Chat.notify(
			"[Chalk++] Due to game limitations outside our control, the fill tool does not currently work on this chalk canvas, sorry!"
		)
		return transformations

	var queue = [Vector2(start_x, start_y)]
	while queue.size() > 0:
		var cell = queue.pop_front()
		var cx = int(cell.x)
		var cy = int(cell.y)

		if not _in_bounds(cx, cy):
			continue
		if TileMap_node.get_cell(cx, cy) != target_color:
			continue

		# yield(get_tree().create_timer(0.001), "timeout")
		# _update_canvas_node([[cx, cy, new_color]], chalk_canvas_id)

		# If this is local update is not done, crawling will be infinite
		TileMap_node.set_cell(cx, cy, new_color)
		transformations.append([cx, cy, new_color])

		queue.append(Vector2(cx + 1, cy))
		queue.append(Vector2(cx - 1, cy))
		queue.append(Vector2(cx, cy + 1))
		queue.append(Vector2(cx, cy - 1))
	return transformations


func _set_line_origin(origin: Vector2):
	_debug("Setting line origin %s, %s" % [origin.x, origin.y])
	line_tool_origin = origin


func _reset_line_origin():
	self.line_tool_origin = Vector2.INF


func draw_line(transformations: Array) -> Array:
	## [x, y, color]
	var cell = transformations[0]
	var cellV = Vector2(cell[0], cell[1])
	var color = cell[2]
	var result := []

	if vec2_has_inf(cellV):
		breakpoint
		return []

	# Start or reset line origin
	if vec2_has_inf(line_tool_origin):
		result.append([cellV.x, cellV.y, color])
		return result

	var x0 = line_tool_origin.x
	var y0 = line_tool_origin.y
	var x1 = cell[0]
	var y1 = cell[1]

	var dx = abs(x1 - x0)
	var dy = abs(y1 - y0)
	var sx = 1 if x0 < x1 else -1
	var sy = 1 if y0 < y1 else -1
	var err = dx - dy

	while x0 != x1 or y0 != y1:
		# Masking
		if control_is_held and not shift_is_held:
			var current_cell_color = TileMap_node.get_cell(x0, y0)
			if current_cell_color == masking_color:
				result.append([x0, y0, color])
		else:
			result.append([x0, y0, color])
		var e2 = 2 * err
		if e2 > -dy:
			err -= dy
			x0 += sx
		if e2 < dx:
			err += dx
			y0 += sy
	return result


func mirror_tool(transformations: Array) -> Array:
	var result := []
	for entry in transformations:
		var x = entry[0]
		var y = entry[1]
		var color = entry[2]

		var x_mid = get_canvas_midpoint()
		var x_diff = abs(x_mid - x)
		var t1 = [x_mid - x_diff, y, color]
		var t2 = [x_mid + x_diff, y, color]

		if control_is_held:
			var tx = t1[0]
			var ty = t1[1]
			# Only masking t1. t2 applied no matter what
			var current_cell_color = TileMap_node.get_cell(tx, ty)
			if current_cell_color != masking_color:
				continue

		result.append(t1)
		result.append(t2)

	return result


func _preview_paint(transformations: Array, canvas_id: int):
	if transformations.empty():
		# TODO: Can maybe skip this if no need to avoid changing temp_chalk_mode
		return
	temp_chalk_mode = current_mode
	for painting in transformations:
		var v = Vector2(painting[0], painting[1])
		temp_chalk_tiles.append([v, [TileMap_node.get_cellv(v), painting[2]]])
		_debug("Temp chalk tiles %s %s %s" % [painting[0], painting[1], painting[2]])
		TileMap_node.set_cellv(v, painting[2])


func _undo_temp_paint():
	while temp_chalk_tiles.size() > 0:
		var temp_paint_event: Array = temp_chalk_tiles.pop_back()
		var pos = temp_paint_event[0]
		var original_tile = temp_paint_event[1][0]
		var temp_tile = temp_paint_event[1][1]
		var current_tile = TileMap_node.get_cellv(pos)
		if temp_tile == current_tile:
			TileMap_node.set_cellv(pos, original_tile)
			_debug("Undoing temp chalk  %s %s %s" % [pos.x, pos.y, temp_tile])
		else:
			# Abort!
			_debug("Skipping changed paint??? %s %s" % [pos.x, pos.y])
			continue


func _apply_temp_paint() -> Array:
	var transformations := []
	while temp_chalk_tiles.size() > 0:
		var temp_paint_event: Array = temp_chalk_tiles.pop_back()
		var pos = temp_paint_event[0]
		var temp_tile = temp_paint_event[1][1]
		var current_tile = TileMap_node.get_cellv(pos)
		_debug("Applying temp chalk  %s %s %s" % [pos.x, pos.y, temp_tile])
		transformations.push_back([pos.x, pos.y, temp_tile])
	return transformations
	temp_chalk_canvas_id = -1


func _update_canvas_node(transformations: Array, canvasActorID: int):
	_play_random_section()
	var canvasData = []

	for pixelData in transformations:
		var x = pixelData[0]
		var y = pixelData[1]
		var color = pixelData[2]
		canvasData.append([Vector2(x, y), color])
		TileMap_node.set_cell(x, y, color)
		if canvasData.size() == 1000:
			Network._send_P2P_Packet(
				{"type": "chalk_packet", "data": canvasData, "canvas_id": canvasActorID},
				"peers",
				2,
				Network.CHANNELS.CHALK
			)
			call_deferred("clear", canvasData)

	Network._send_P2P_Packet(
		{"type": "chalk_packet", "data": canvasData, "canvas_id": canvasActorID},
		"peers",
		2,
		Network.CHANNELS.CHALK
	)


# TODO: Mod conflicts with Calico/Awwptomize?
func _set_spawn_prop_visibility(visible: bool) -> void:
	if chalk_canvas_id != 0 or chalk_canvas_node == null:
		return
	var scene = get_tree().current_scene
	var big_tree = scene.get_node_or_null("Viewport/main/map/main_map/zones/main_zone/trees/tree_a/big_tree")
#	if big_tree == null:
#		big_tree = scene.get_node_or_null("Viewport/main/map/main_map/zones/main_zone/trees/@@1698")
	if big_tree == null:
		# TODO
		# This will happen due sometimes due to Calico if config.MeshGpuInstancingEnabled = true
		# https://github.com/tma02/calico/blob/46f46722d3bdcf7f8f5da96861894e9abcefc766/Teemaw.Calico/ScriptMod/MainMapScriptModFactory.cs#L31
		return
	big_tree.visible = visible
	var big_tree_collision = big_tree.get_child(1).get_child(0)
	big_tree_collision.disabled = !visible
	for bench_num in [2, 3, 4]:
		var bench = scene.get_node_or_null("Viewport/main/map/main_map/zones/main_zone/props/bench" + str(bench_num))
		if bench == null:
			return
		var bench_children = bench.get_children()
		var bench_body = bench.get_child(1)
#		if bench_body == null:
#			bench_body = bench.get_child(0)
		bench_body.visible = visible
		for collision in bench_body.get_children():
			collision.disabled = !visible
		bench.visible = visible
	return
