extends Node

var total_jumps = 0
var time_elapsed = 0
var times_died = 0

func increment_jump_count():
	total_jumps += 1
	return total_jumps

func increment_time_elapsed():
	time_elapsed += 1
	return time_elapsed

func increment_times_died():
	times_died += 1
	return times_died
