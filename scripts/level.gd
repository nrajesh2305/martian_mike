extends Node2D

@export var next_level: PackedScene = null
@export var is_final_level : bool = false
@export var level_time = 15
@onready var start = $Start
@onready var exit = $Exit
@onready var death_zone = $Deathzone
@onready var hud = $UILayer/HUD
@onready var ui_layer = $UILayer
@onready var transition = $Transition
@onready var score_manager = $ScoreManager

var player = null
var timer_node = null
var time_left
var win = false

var num_jumps = GameData.total_jumps # probably useless, but I don't want to get rid of it to make script work, if not.
var died_amount = 0

func _ready():
	transition.play("fade_in")
	player = get_tree().get_first_node_in_group("player")
	if player != null:
		player.global_position = start.get_spawn_pos()
	var traps = get_tree().get_nodes_in_group("traps")
	for trap in traps:
		trap.touched_player.connect(_on_trap_touched_player)

	exit.body_entered.connect(_on_exit_body_entered)
	death_zone.body_entered.connect(_on_deathzone_body_entered)
	
	time_left = level_time
	hud.set_time_label(time_left)
	
	timer_node = Timer.new()
	timer_node.name = "Level Timer"
	timer_node.wait_time = 1
	timer_node.timeout.connect(_on_level_timer_timeout)
	add_child(timer_node)
	timer_node.start(1)

func _on_level_timer_timeout():
	if not win:
		time_left -= 1
		var seconds_wasted = GameData.increment_time_elapsed()
		print("You have wasted " + str(seconds_wasted) + " seconds")
		hud.set_time_label(time_left)
		if time_left < 0:
			AudioPlayer.play_sfx("hurt")
			died_amount = GameData.increment_times_died()
			print("You have died " + str(died_amount) + " times.")
			reset_player()
			time_left = level_time
			hud.set_time_label(time_left)
		
func _on_deathzone_body_entered(_body):
	AudioPlayer.play_sfx("hurt")
	died_amount = GameData.increment_times_died()
	print("You have died " + str(died_amount) + " times.")
	reset_player()

func _on_trap_touched_player():
	AudioPlayer.play_sfx("hurt")
	died_amount = GameData.increment_times_died()
	print("You have died " + str(died_amount) + " times.")
	reset_player()

func reset_player():
	player.velocity = Vector2.ZERO
	player.global_position = start.get_spawn_pos()

func _on_exit_body_entered(body):
	transition.play("fade_in")
	if body is Player:
		if is_final_level || next_level != null:
			exit.animate()
			player.active = false
			win = true
			await get_tree().create_timer(1.5).timeout
			if is_final_level:
				score_manager.update_score_display()
				ui_layer.show_win_screen(true)
				print("Score for all: " + str(GameData.total_jumps))
			else:
				get_tree().change_scene_to_packed(next_level)
