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

var cooldown_timer: Timer

func start_second_timer():
	var timer = Timer.new()
	timer.wait_time = 1.5
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_small_timer_timeout)
	timer.start()

func _on_small_timer_timeout():
	print("1.5 seconds have passed!")

func _process(delta):
	if cooldown_time > 0:
		animation_player.stop()
		on_cooldown = true
	else:
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
			
			pass
			
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
	cooldown_label.visible = true
	cooldown_label.text = str(cooldown_time)
	on_cooldown = true
	setup_timer()

func stop() -> void:
	cooldown_timer.stop()
	set_process(false)
