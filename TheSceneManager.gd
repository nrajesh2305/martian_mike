extends Node

var scene_stack: Array = []

func push_scene(scene_path: String) -> void:
	print("Pushing scene: %s" % scene_path)
	scene_stack.append(scene_path)

func pop_scene() -> String:
	if scene_stack.size() > 0:
		var scene = scene_stack.pop_back()
		print("Popping scene: %s" % scene)
		print(scene_stack)
		return scene
	return ""

func change_scene(new_scene_path: String):
	print("Changing to new scene: %s" % new_scene_path)
	
	# Instead of trying to get the filename from the current scene,
	# we directly store the new_scene_path before changing scenes.
	push_scene(new_scene_path)
	
	var new_scene = load(new_scene_path).instantiate()
	
	# Set the new scene as the current scene
	get_tree().current_scene = new_scene
	get_tree().root.add_child(new_scene)
	
	# Remove the previous current scene from the scene tree
	var current_scene = get_tree().current_scene
	if current_scene:
		current_scene.queue_free()
	print(scene_stack)

func go_back() -> void:
	if scene_stack.size() > 1:  # Ensure there's a previous scene to go back to
		# Remove the current (top) scene since we're about to leave it
		scene_stack.pop_back()
		print("Going back to the previous scene.")
		var previous_scene_path = pop_scene()
		change_scene(previous_scene_path)
	else:
		print("No previous scene to return to.")
	print(scene_stack)
