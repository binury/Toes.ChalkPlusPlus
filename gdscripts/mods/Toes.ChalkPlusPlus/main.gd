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

signal cycle_chalk_mode
signal eraser_button_press

onready var Chat = get_node("/root/ToesSocks/Chat")
onready var Players = get_node("/root/ToesSocks/Players")
onready var Hotkeys = get_node("/root/ToesSocks/Hotkeys")
onready var TackleBox = get_node("/root/TackleBox")

onready var ChalkPP = preload("res://mods/Toes.ChalkPlusPlus/controls.gd").new()
onready var ChalkPP_UI = preload("res://mods/Toes.ChalkPlusPlus/chalkpp_ui.tscn").instance()

const MOD_ID = "Toes.ChalkPlusPlus"
const CYCLE_ACTION_NAME = "cycle_chalk++_mode"
var default_config := {
	"modeSelectKey": 89,
	# "instantFill": true,
	"useEraserAsChalk": true,
	"eraserKey": KEY_E,
	"experimentalStylusControls": false,
	"drawingSounds": true,
	"useFixedChalkTextures": true,
	"glowInTheDarkChalk": true,
	"hideCanvasObstructions": true,
	"alwaysHideObstructions": true,
}
var config := {}
	
var DEBUG := OS.has_feature("editor") and false

var last_used_mode: int = 0


func _ready():
	init_config()
	save_config()
	init_keybind()

	# Mod conflict resolution
	var calico_config = TackleBox.get_mod_config("Teemaw.Calico")
	if calico_config != null and calico_config.get("MeshGpuInstancingEnabled", false):
		if config.get("hideCanvasObstructions"):
			calico_config["MeshGpuInstancingEnabled"] = false
			TackleBox.set_mod_config("Teemaw.Calico", calico_config)

	Players.connect("ingame", self, "_on_ingame")
	TackleBox.connect("mod_config_updated", self, "_config_updated")


func _cycle_pattern(forward):
	emit_signal("cycle_chalk_mode", forward)


func _toggle_on_cpp():
	print("TOGGLING ON")
	if last_used_mode == ChalkPP.MODES.NONE:
		last_used_mode = ChalkPP.current_mode
		ChalkPP.set_mode(ChalkPP.MODES.NONE)
	else:
		ChalkPP.set_mode(last_used_mode)
		last_used_mode = ChalkPP.MODES.NONE


func _activate_eraser():
	# TODO
	emit_signal("eraser_button_press")


func _on_ingame():
	if ChalkPP and ChalkPP.is_inside_tree():
		ChalkPP.queue_free()
		ChalkPP = null
	if ChalkPP == null or not ChalkPP.is_inside_tree():
		ChalkPP = preload("res://mods/Toes.ChalkPlusPlus/controls.gd").new()
		add_child(ChalkPP, true)
	ChalkPP_UI = preload("res://mods/Toes.ChalkPlusPlus/chalkpp_ui.tscn").instance()
	get_tree().root.add_child(ChalkPP_UI, true)


func _config_updated(id: String, new_config: Dictionary):
	if id == MOD_ID:
		Chat.write("[color=blue]Chalk++ Settings Reloaded ✅[/color]")
		init_config()

func init_config() -> void:
	var saved_config = TackleBox.get_mod_config(MOD_ID)
	if not saved_config:
		saved_config = default_config.duplicate()
	for key in default_config.keys():
		if not saved_config.has(key):
			print("[CHALK++] Using defaulted option %s : %s" % [key, default_config[key]])
			saved_config[key] = default_config[key]
	config = saved_config


func save_config() -> void:
	TackleBox.set_mod_config(MOD_ID, config)


func init_keybind() -> void:
	Hotkeys.connect(Hotkeys.add({
		"name": CYCLE_ACTION_NAME,
		"label": "Cycle Chalk++ Mode",
		"key_code": config.modeSelectKey,
		"modifiers": [],
		"repeat": true,
	}), self, "_cycle_pattern", [true])
	Hotkeys.connect(Hotkeys.add({
		"name": CYCLE_ACTION_NAME + "_prev",
		"label": "Cycle Chalk++ Mode" + " Prev.",
		"key_code": config.modeSelectKey,
		"modifiers": ["shift"],
		"repeat": true,
	}), self, "_cycle_pattern", [false])
	Hotkeys.connect(Hotkeys.add({
		"name": "toggle_on_chalk++",
		"label": "Toggle On/Off Chalk++",
		"key_code": config.modeSelectKey,
		"modifiers": ["control"],
		"repeat": false,
	}), self, "_toggle_on_cpp", [])
	Hotkeys.connect(Hotkeys.add({
		"name": "cpp_erase",
		"label": "Chalk++ Eraser Button",
		"key_code": config.eraserKey,
		"modifiers": [],
		"repeat": false,
	}), self, "_activate_eraser", [false])
