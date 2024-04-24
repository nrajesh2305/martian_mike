extends Node2D

var jump_count = GameData.total_jumps
var time_elapsed = 0
@onready var score_label = get_node("UserInterface/ScoreLabel")
@onready var best_score_label = get_node("UserInterface/BestScoreLabel")

func _process(_delta):
	update_score_display()

func update_score_display():
	score_label.text = "Score\n" + str(GameData.total_jumps)
	best_score_label.text = "Best Score\n" + str(GameData.total_jumps)
