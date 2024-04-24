extends Control

#@onready var player = $""
@onready var settings_button = $SettingsButton
@onready var settings_menu = $Settings_Menu
@onready var v_box_container = $MarginContainer/VBoxContainer
@onready var background_color = $BackgroundColor

func _on_resume_pressed():
	get_tree().paused = false
	# Hide the pause menu and resume time scale
	visible = !visible
	Engine.time_scale = 1

func _on_quit_pressed():
	get_tree().paused = false
	hide()
	get_tree().change_scene_to_file("res://scenes/start_menu.tscn")
	Engine.time_scale = 1
	GameData.total_jumps = 0

func _on_settings_pressed():
	get_tree().paused = false
	Engine.time_scale = 0
	#get_tree().current_scene.visible = !get_tree().current_scene.visible # hiding the pause menu, works, now we have to show the settings menu, and hide everything else.
	print("You have pressed the settings button. You will go to the settings, everything else is going to be hidden for the time being.")
	settings_menu.set_state(true)
	background_color.visible = false
	#v_box_container.visible = false
	#settings_button.visible = false
