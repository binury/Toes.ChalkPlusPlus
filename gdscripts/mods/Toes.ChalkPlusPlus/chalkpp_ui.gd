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

onready var title := $"Info/Panel/VBoxContainer/Title"
onready var details := $"Info/Panel/VBoxContainer/Details"
onready var main = $"/root/ToesChalkPlusPlus"

onready var PlayerAPI = get_node("/root/ToesSocks/Players")

const Chalk := preload("res://mods/Toes.ChalkPlusPlus/controls.gd")
const COLORS := Chalk.COLORS
const COLOR_NAMES := Chalk.COLOR_NAMES
const MODES := Chalk.MODES
const MODE_NAMES := Chalk.MODE_NAMES
const MASKS := Chalk.masks
const MASK_NAMES := Chalk.mask_names


func _ready():
	main.ChalkPP.connect("changed_mode", self, "change_mode")
	main.ChalkPP.connect("changed_mask", self, "change_mask")
#	while title == null and details == null:
#		yield(get_tree(), "idle_frame")
	title.bbcode_text = ""
	details.bbcode_text = " Mask: [b]Alpha[/b]"
	self.visible = false


func _process(_d):
	if PlayerAPI.in_game == false:
		self.queue_free()

	var MASK_ACTIVE_MSG = " [color=black][ACTIVE][/color]"
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


func make_visible():
	self.visible = true


func change_mode(mode: int) -> void:
	self.visible = not (mode == MODES.NONE)
	title.bbcode_text = " [i]%s[/i]" % MODE_NAMES[mode]


func change_mask(mask: int) -> void:
	for i in range(3):
		yield(get_tree(), "idle_frame")
	var mask_color = MASKS[mask]
	var mask_color_name = COLOR_NAMES[mask_color]
	if mask_color == COLORS.SPECIAL:
		details.bbcode_text = "[rainbow] Mask: %s[/rainbow]" % mask_color_name
	elif mask_color == COLORS.NONE:
		details.bbcode_text = " Mask: Alpha"
	else:
		details.bbcode_text = ("[color=%s] Mask: %s[/color]" % [mask_color_name, mask_color_name])
