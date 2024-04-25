extends Node2D

var jump_count = GameData.total_jumps
var time_wasted = GameData.time_elapsed
var death_count = GameData.times_died
@onready var score_label = get_node("UserInterface/ScoreLabel")
@onready var best_score_label = get_node("UserInterface/BestScoreLabel")

func _process(_delta):
	update_score_display()

func update_score_display():
	score_label.text = "Score\n" + str(calculate_score())
	best_score_label.text = "Best Score\n" + str(calculate_score()) # temporary, have to compare with other scores in saves file.

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
