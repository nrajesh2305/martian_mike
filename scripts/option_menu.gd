class_name OptionsMenu
extends Control

@onready var back_button = $Back_Button as Button
signal exit_options_menu

func _ready():
	Engine.time_scale = 1

func on_exit_pressed() -> void:
	exit_options_menu.emit()
	print("Going back...")
	TheSceneManager.go_back()
