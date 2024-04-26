extends Node

var hurt = preload("res://martian_mike_assets/audio/hurt.wav")
var jump = preload("res://martian_mike_assets/audio/jump.wav")
var music = preload("res://martian_mike_assets/audio/Lily Wasp.mp3")

var sfx_volume_db = -10.0
var music_volume_db = -20.0

func _ready():
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
	asp.bus = "music"
	asp.name = "Music_Player"
	asp.autoplay = true
	add_child(asp)
	asp.play()
