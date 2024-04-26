extends Node2D

var jump_count = GameData.total_jumps
var time_wasted = GameData.time_elapsed
var death_count = GameData.times_died
@onready var score_label = get_node("UserInterface/ScoreLabel")
@onready var best_score_label = get_node("UserInterface/BestScoreLabel")
var high_score = 0

func _ready():
	load_game()

func _process(_delta):
	update_score_display()
	check_best()
	
func save():
	var save_dict = {
		"score": calculate_score(),
		"high_score": high_score
	}
	return save_dict

func save_game():
	var save_game = FileAccess.open("user://savegame.save", FileAccess.WRITE)
	
	var json_string = JSON.stringify(save())
	
	save_game.store_line(json_string)

func load_game():
	if not FileAccess.file_exists("user://savegame.save"):
		return
	
	var save_game = FileAccess.open("user://savegame.save", FileAccess.READ)
	
	while save_game.get_position() < save_game.get_length():
		var json_string = save_game.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_string)
		var node_data = json.get_data()
		high_score = node_data.get("high_score", 0)

func check_best():
	var current_score = calculate_score()
	if current_score > high_score:
		high_score = current_score
		save_game()
		best_score_label.text = "Best Score\n" + str(high_score)
	

func update_score_display():
	score_label.text = "Score\n" + str(calculate_score())
	best_score_label.text = "Best Score\n" + str(high_score)

func calculate_score():
	var base_score = 1000
	var jump_penalty = pow(1.05, GameData.total_jumps)
	var time_penalty = pow(1.02, GameData.time_elapsed / 60.0)
	var death_multiplier = 1.25
	var death_penalty = pow(death_multiplier, GameData.times_died)

	var final_score = base_score - (jump_penalty + time_penalty + death_penalty)
	final_score = max(min(final_score, 1000), 0)

	return floor(final_score)
