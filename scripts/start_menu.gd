extends Control

@onready var transition = $Transition
var level1 = preload("res://scenes/level.tscn")
@onready var settings_menu = $Settings_Menu
@onready var title = $Title
@onready var start_button = $StartButton
@onready var quit_button = $QuitButton
@onready var settings_button = $SettingsButton
@onready var saw = $Saw
@onready var spike_ball = $SpikeBall
@onready var spike_ball_2 = $SpikeBall2
@onready var jump_pad = $JumpPad
@onready var jump_pad_2 = $JumpPad2
@export var previous_scene = "."

func _ready() -> void:
	$SettingsButton.pressed.connect(toggle_settings_menu)
	
func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://scenes/level.tscn")
	transition.play("fade_out")
	
func _on_quit_button_pressed():
	get_tree().quit()

func on_exit_settings_menu() -> void:
	settings_menu.set_state(false)

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_packed(level1)

func toggle_settings_menu() -> void:
	#settings_menu.visible = true
	#settings_menu.set_process(true)
	#title.visible = !title.visible
	#start_button.visible = !start_button.visible
	#quit_button.visible = !quit_button.visible
	#settings_button.visible = !settings_button.visible
	#saw.visible = !saw.visible
	#spike_ball.visible = !spike_ball.visible
	#spike_ball_2.visible = !spike_ball_2.visible
	#jump_pad.visible = !jump_pad.visible
	#jump_pad_2.visible = !jump_pad_2.visible
	settings_menu.set_state(true)
	
