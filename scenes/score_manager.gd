extends Node2D

var jump_count = 0
var time_elapsed = 0

func calculate_score():
	var max_time = 15
	var score = (max_time - (time_elapsed * 2)) * \
				(((pow(time_elapsed / 2, 2) + pow(time_elapsed / 3, 3)) / (time_elapsed + 1))) * \
				(1 - pow(jump_count / 10, 2))
	score = int(100 * score / max_time)
	return score
