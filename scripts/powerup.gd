extends Sprite2D

var cooldown_time = 5
@onready var on_cooldown = true
var target_color: Color = Color(1, 1, 1, 1)
var current_color: Color = Color(0, 0, 0, 1)
var the_current_color: Color = Color(0, 0, 0, 1)
@onready var cooldown_label = $CooldownLabel
var step_size = 1.0 / cooldown_time
@onready var animation_player = $"../AnimationPlayer"
@onready var sprite_2d = $"."
var is_powerup_active = false
var num_jumps_left = 2
var cooldown_timer: Timer
var player = preload("res://scenes/player.tscn")


#func start_second_timer():
	##var timer = Timer.new()
	##timer.wait_time = 1.5
	##timer.one_shot = true
	##add_child(timer)
	##timer.timeout.connect(_on_small_timer_timeout)
	##timer.start()
	#
func start_second_timer():
# Only stop the timer, don't queue_free it
	if cooldown_timer.is_inside_tree() and cooldown_timer.is_stopped() == false:
		cooldown_timer.stop()  # Temporarily stop the timer, not destroy it

	# Start the powerup timer
	var timer = Timer.new()
	timer.wait_time = 1.5
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_small_timer_timeout)
	timer.start()
	animation_player.stop()

	# Indicate powerup is active and freeze the label
	is_powerup_active = true
	cooldown_label.text = str(5)  # Display as '5' during the powerup
	cooldown_label.visible = true

func _on_small_timer_timeout():
	print("1.5 seconds have passed!")
	is_powerup_active = false  # Indicate that the powerup period has ended

	# Ensure the cooldown timer restarts from a paused state
	if cooldown_timer.is_inside_tree():
		cooldown_timer.start()  # This ensures the timer resumes
		
func _process(delta):
	if cooldown_time > 0 and not is_powerup_active:  # Check if powerup is not active to manage cooldown
		animation_player.stop()
		on_cooldown = true
	elif not is_powerup_active:  # Ensure this block only runs when not in powerup
		animation_player.play()
		on_cooldown = false
		
	if not on_cooldown and Input.is_action_just_pressed("activate_ability"):
		is_powerup_active = true
		start_second_timer()
		# Since the powerup is active for the next
		# 1.5 seconds, we must allow the player to
		# use his ability for the next 1.5 seconds.
		# If they are in the air or not, they can double jump,
		# aka jump twice in a row before going down.
		if Input.is_action_just_pressed("jump"):
			num_jumps_left -= 1
			if num_jumps_left == 0:
				return # I think if we don't want to do anything here, we just put pass correct?
				
			# If we are in the air or not, we are able to jump one more time.
			if player.is_on_floor() or not player.is_on_floor():
				print("The double jump has been activated.")
				player.jump()
			
		on_cooldown = true
		reset_cooldown()
		self_modulate = the_current_color
		setup_timer()

func _ready():
	self_modulate = current_color
	setup_timer()

func setup_timer():
	if cooldown_timer:
		cooldown_timer.queue_free()

	# Create a new Timer
	cooldown_timer = Timer.new()
	cooldown_timer.name = "CooldownTimer"
	add_child(cooldown_timer)
	cooldown_timer.wait_time = 1
	cooldown_timer.timeout.connect(_on_Timer_timeout)
	cooldown_timer.start()

func _on_Timer_timeout() -> void:
	if not is_powerup_active:
		cooldown_time -= 1
		cooldown_label.text = str(cooldown_time)
		print(cooldown_time)

		current_color = current_color.lerp(target_color, step_size)
		self_modulate = current_color

		if cooldown_time <= 0:
			cooldown_label.visible = false
			cooldown_timer.stop()
			self_modulate = target_color
			on_cooldown = false
			animation_player.play()
			print(cooldown_time)

func reset_cooldown():
	cooldown_time = 5
	current_color = the_current_color
	cooldown_label.text = str(cooldown_time)
	cooldown_label.visible = true
	on_cooldown = true
	# Do not start the timer here; it will be restarted after the powerup ends


func stop() -> void:
	cooldown_timer.stop()
	set_process(false)
