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

extends CanvasLayer

signal scrolled_up
signal scrolled_down
signal mask_selected

const DEBUG := false

onready var title := $"Info/Panel/VBoxContainer/Title"
onready var details := $"Info/Panel/VBoxContainer/Details"
onready var main = $"/root/ToesChalkPlusPlus"

onready var PlayerAPI = get_node("/root/ToesSocks/Players")
# var ss: ScrollContainer

const Chalk := preload("res://mods/Toes.ChalkPlusPlus/controls.gd")
const COLORS := Chalk.COLORS
const COLOR_CODES := {
	COLORS.WHITE: "#faebd4",
	COLORS.BLACK: "#040c19",
	COLORS.RED: "#b40028",
	COLORS.BLUE: "#008886",
	COLORS.YELLOW: "#e59f02",
	COLORS.GREEN: "#7fa424",
	COLORS.NONE: "#FFDBB6",
}
const COLOR_NAMES := {
	COLORS.NONE: "Alpha",
	COLORS.WHITE: Chalk.COLOR_NAMES[0],
	COLORS.BLACK: Chalk.COLOR_NAMES[1],
	COLORS.RED: Chalk.COLOR_NAMES[2],
	COLORS.BLUE: Chalk.COLOR_NAMES[3],
	COLORS.YELLOW: Chalk.COLOR_NAMES[4],
	COLORS.SPECIAL: Chalk.COLOR_NAMES[5],
	COLORS.GREEN: Chalk.COLOR_NAMES[6],
}
const MODES := Chalk.MODES
const MODE_NAMES := Chalk.MODE_NAMES
const MASKS := Chalk.masks
const MASK_NAMES := Chalk.mask_names


func _ready():
	main.ChalkPP.connect("changed_mode", self, "change_mode")
	main.ChalkPP.connect("changed_mask", self, "change_mask")
	title.bbcode_text = ""
	details.bbcode_text = " Mask: [b]%s[/b]" % MASK_NAMES[COLORS.NONE]
	self.visible = false

	var mode_menu: MenuButton = get_node("Info/Panel/VBoxContainer/HBoxContainer/ModeButton")
	var mode_picker := mode_menu.get_popup()
	mode_picker.connect("id_pressed", self, "_handle_mode_menu_press")
	for mode in range(main.ChalkPP.END_OF_MODES_INDEX + 1):
		mode_picker.add_radio_check_item(
			MODE_NAMES[mode],
			mode
		)
	var color_menu: MenuButton = get_node("Info/Panel/VBoxContainer/HBoxContainer/MaskButton")
	var color_picker := color_menu.get_popup()
	color_picker.connect("id_pressed", self, "_handle_mask_menu_press")
	for mask in MASKS:
		color_picker.add_radio_check_item(
			MASK_NAMES[mask],
			# Offset this by +1 due to Alpha being -1
			mask + 1
		)


func _handle_mask_menu_press(color: int) -> void:
	# Offset this by -1 due to ID being offset by +1
	color -= 1
	_debug("MASK MENU PRESSED", color)
	main.ChalkPP.set_mask_color(color)


func _handle_mode_menu_press(mode: int) -> void:
	_debug("MODE MENU PRESSED", mode)
	main.ChalkPP.set_mode(mode)


func _process(_d):
	if PlayerAPI.in_game == false:
		self.queue_free()

	var HUD = $"/root/playerhud"
	self.visible = main.ChalkPP.current_mode != MODES.NONE and !HUD.hud_hidden
	if not self.visible:
		return

	var ERASER_ACTIVE_MSG = " [center][img=88]res://Assets/Textures/Items/toolicons22.png[/img][/center]"
	var MASK_ACTIVE_MSG = " [ACTIVE]"
	if (
		main.ChalkPP.current_mode == MODES.MASK
		or (
			main.ChalkPP.control_is_held
			and main.ChalkPP.current_mode in [MODES.DITHER_CHECKER, MODES.DITHER_DOT, MODES.MIRROR]
		)
	):
		if details.bbcode_text.find(MASK_ACTIVE_MSG) == -1:
			details.bbcode_text = details.bbcode_text + MASK_ACTIVE_MSG
	else:
		details.bbcode_text = details.bbcode_text.replace(MASK_ACTIVE_MSG, "")

	if Input.is_action_pressed("cpp_erase"):
		details.modulate = "#00ffffff"
		title.bbcode_text = ERASER_ACTIVE_MSG
	else:
		details.modulate = "#ffffffff"
		change_mode(main.ChalkPP.current_mode)


func make_visible():
	self.visible = true


func change_mode(mode: int) -> void:
	self.visible = not (mode == MODES.NONE)
	title.bbcode_text = " [i]%s[/i]" % MODE_NAMES[mode]


func change_mask(idx: int) -> void:
	_debug("Got mask change signal for color idx", idx)
	var mask_color = MASKS[idx]
	var mask_color_name = COLOR_NAMES[mask_color]
	if mask_color == COLORS.SPECIAL:
		details.bbcode_text = "[rainbow] Mask: %s[/rainbow]" % mask_color_name
	else:
		var color = COLOR_CODES[mask_color]
		details.bbcode_text = ("[color=%s] Mask: %s[/color]" % [color, mask_color_name])


func _debug(msg, data = null):
	var DEBUG = true
	if not DEBUG:
		return
	print("[CHALK++]: %s" % msg)
	if data != null:
		print(JSON.print(data, "\t"))
