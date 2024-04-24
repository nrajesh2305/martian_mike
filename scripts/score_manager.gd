extends Node2D

var jump_count = GameData.total_jumps
var time_elapsed = 0
@onready var score_label = get_node("UserInterface/ScoreLabel")
@onready var best_score_label = get_node("UserInterface/BestScoreLabel")

func _ready():
	score_label.text = "Score\n" + str(jump_count)
	best_score_label.text = score_label.text # temporary
#func calculate_score():
	##var max_time = 15
	##var time_score = max_time - (time_elapsed * 2)
	##var jump_penalty = 1 - pow(jump_count1 / 10, 2)
	##var score = time_score * jump_penalty
	##score = max(0, int(100 * score / max_time))  # Ensure score is non-negative and normalized
	#var score = 10
	#score_label += str(score)
	#print(score_label.text)
