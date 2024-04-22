extends Node2D

func change_scene_to_file(target: String):
	$AnimationPlayer.play("dissolve")
	await($AnimationPlayer)
	get_tree().change_scene(target)
	$AnimationPlayer.play_backwards("dissolve")
	
