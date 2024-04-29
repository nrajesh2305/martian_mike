class_name OptionsMenu
extends Control
@onready var settings_menu = $"."
@onready var v_box_container = $MarginContainer/VBoxContainer
@onready var back_button = $Back_Button as Button
@onready var background = $Background

signal exit_options_menu

func _ready():
	Engine.time_scale = 1

func on_exit_pressed() -> void:
	exit_options_menu.emit()
	background.visible = false
	v_box_container.visible = false
	back_button.visible = false
	settings_menu.set_state(false)
	
func set_state(a):
	settings_menu.visible = a
	v_box_container.visible = a
	back_button.visible = a
	background.visible = a
