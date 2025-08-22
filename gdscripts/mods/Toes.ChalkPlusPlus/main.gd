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

onready var KeybindsAPI = get_node("/root/BlueberryWolfiAPIs/KeybindsAPI")
onready var Players = get_node("/root/ToesSocks/Players")
onready var TackleBox = get_node("/root/TackleBox")

onready var ChalkPP = preload("res://mods/Toes.ChalkPlusPlus/controls.gd").new()
onready var ChalkPP_UI = preload("res://mods/Toes.ChalkPlusPlus/chalkpp_ui.tscn").instance()

const MOD_ID = "Toes.ChalkPlusPlus"
const CYCLE_ACTION_NAME = "cycle_chalk++_mode"
var default_config := {
	"modeSelectKey": 89,
	"instantFill": true,
}
var config := {}

var editor = OS.has_feature("editor")

signal cycle_chalk_mode


func _ready():
	init_config()
	init_keybind()

	Players.connect("ingame", self, "_on_ingame")
	KeybindsAPI.connect("_keybind_changed", self, "_on_keybind_changed")



func _cycle_pattern():
	emit_signal("cycle_chalk_mode")


func _on_ingame():
	if ChalkPP and ChalkPP.is_inside_tree():
		ChalkPP.queue_free()
		ChalkPP = null
	if ChalkPP == null or not ChalkPP.is_inside_tree():
		ChalkPP = preload("res://mods/Toes.ChalkPlusPlus/controls.gd").new()
		add_child(ChalkPP)
	ChalkPP_UI = preload("res://mods/Toes.ChalkPlusPlus/chalkpp_ui.tscn").instance()
	get_tree().root.add_child(ChalkPP_UI)



func init_config() -> void:
	var saved_config = TackleBox.get_mod_config(MOD_ID)
	if not saved_config:
		saved_config = default_config.duplicate()
	for key in default_config.keys():
		if not saved_config.has(key):
			saved_config[key] = default_config[key]
	config = saved_config
	save_config()



func save_config() -> void:
	TackleBox.set_mod_config(MOD_ID, config)

func init_keybind() -> void:
	if KeybindsAPI.is_connected(CYCLE_ACTION_NAME + "_up", self, "_cycle_pattern"):
		KeybindsAPI.disconnect(CYCLE_ACTION_NAME + "_up", self, "_cycle_pattern")
	KeybindsAPI.register_keybind(
		{
			"action_name": CYCLE_ACTION_NAME,
			"title": "Cycle Chalk++ Mode",
			"key": config.modeSelectKey,
		}
	)
	KeybindsAPI.connect(CYCLE_ACTION_NAME + "_up", self, "_cycle_pattern")



func _on_keybind_changed(action_name: String, title: String, event: InputEvent) -> void:
	if not (action_name == CYCLE_ACTION_NAME and event is InputEventKey):
		return
	config.modeSelectKey = event.scancode
	save_config()


