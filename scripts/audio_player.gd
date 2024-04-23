extends Node

var hurt = preload("res://martian_mike_assets/audio/hurt.wav")
var jump = preload("res://martian_mike_assets/audio/jump.wav")
var music = preload("res://martian_mike_assets/audio/Lily Wasp.mp3") # Adjust path as needed

var sfx_volume_db = -10.0 # Set the volume for SFX AudioStreamPlayers
var music_volume_db = -20.0 # Set the volume for the Music AudioStreamPlayer

func _ready():
	# To play music at the start of the scene, you can use:
	play_music()

func play_sfx(sfx_name: String):
	var stream = null

	if sfx_name == "hurt":
		stream = hurt
	elif sfx_name == "jump":
		stream = jump
	else:
		print("Invalid sfx name")
		return

	var asp = AudioStreamPlayer.new()
	asp.stream = stream
	asp.volume_db = sfx_volume_db
	asp.bus = "sfx"
	asp.name = "SFX_Player_" + sfx_name

	add_child(asp)
	asp.play()
	await asp.finished
	asp.queue_free()

func play_music():
	var asp = AudioStreamPlayer.new()
	asp.stream = music
	asp.volume_db = music_volume_db
	asp.bus = "music" # Make sure this matches your bus name in Godot
	asp.name = "Music_Player"
	asp.autoplay = true # If you want it to start automatically
	print("The music is playing")
	add_child(asp)
	asp.play()
	# Note: We're not queue_free'ing the music player since it's likely to be continuous
