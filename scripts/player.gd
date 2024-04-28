extends CharacterBody2D
class_name Player
@export var gravity = 400
@export var speed = 125
@export var jump_force = 200

@onready var animated_sprite = $AnimatedSprite2D
@onready var pause_menu = $CanvasLayer/PauseMenu

var active = true
var paused = false

var jump_count = 2  # Initialize to allow up to two jumps when ability is active

func _process(_delta):
	if Input.is_action_just_pressed("quit"):
		pauseMenu()

func pauseMenu():
	if !paused:
		pause_menu.show()
		paused = true
		Engine.time_scale = 0
	else:
		pause_menu.hide()
		paused = false
		Engine.time_scale = 1
	paused = !paused

func set_active(is_active):
	active = is_active
	if !active:
		animated_sprite.stop()
	else:
		animated_sprite.play()
	velocity = Vector2.ZERO

func _physics_process(delta):
	if !active:
		return

	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 500:
			velocity.y = 500

	if is_on_floor():
		jump_count = 2  # Reset jump count when on floor

	var direction = 0
	if active:
		if Input.is_action_just_pressed("jump") and (is_on_floor() or jump_count > 0):
			jump(jump_force)
			jump_count -= 1  # Decrement jump counter each jump
		
		direction = Input.get_axis("move_left", "move_right")

	if direction != 0:
		animated_sprite.flip_h = (direction == -1)
	
	velocity.x = direction * speed
	move_and_slide()
	update_animations(direction)

func jump(force):
	AudioPlayer.play_sfx("jump")
	velocity.y = -force

func update_animations(direction):
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("Idle")
		else:
			animated_sprite.play("run")
	else:
		if velocity.y < 0:
			animated_sprite.play("jump")
		else:
			animated_sprite.play("fall")
