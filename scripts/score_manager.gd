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
		print(node_data)

func check_best():
	# Check if the score we just got is less than our File's score, if so, return, else, set the high score label to the new score, and save.
	var current_score = calculate_score()
	if current_score > high_score:
		high_score = current_score
		save_game()
		best_score_label.text = "Best Score\n" + str(high_score)
	

func update_score_display():
	score_label.text = "Score\n" + str(calculate_score())
	best_score_label.text = "Best Score\n" + str(high_score) # temporary, have to compare with other scores in saves file.

func calculate_score():
	var base_score = 1000  # Max score
	var jump_penalty = pow(1.05, GameData.total_jumps)  # Exponential growth for jumps
	var time_penalty = pow(1.02, GameData.time_elapsed / 60.0)  # Time penalty per minute
	var death_base = 1.5  # Base rate for death penalty
	var death_multiplier = 1.25  # Multiplier rate for death exponential growth
	var death_penalty = pow(death_multiplier, GameData.times_died)  # Calculate death penalty

	# Calculate the final score by subtracting penalties from the base score
	var final_score = base_score - (jump_penalty + time_penalty + death_penalty)
	final_score = max(min(final_score, 1000), 0)  # Ensure score stays within 0 to 1000

	return floor(final_score)  # Round down to the nearest whole number
