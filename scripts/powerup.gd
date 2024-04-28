extends Sprite2D

@onready var player = GameData.player
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
var num_jumps_left = 1
var cooldown_timer: Timer
var jump_force = 200

func start_second_timer():
	if cooldown_timer.is_inside_tree() and cooldown_timer.is_stopped() == false:
		cooldown_timer.stop()

	var timer = Timer.new()
	timer.wait_time = 3
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(_on_small_timer_timeout)
	timer.start()
	animation_player.stop()

	is_powerup_active = true
	cooldown_label.text = str(5)
	cooldown_label.visible = true

func _on_small_timer_timeout():
	GameData.get_player().max_jumps = 1
	is_powerup_active = false

	if cooldown_timer.is_inside_tree():
		cooldown_timer.start()
		
func _process(delta):
	if cooldown_time > 0 and not is_powerup_active:
		animation_player.stop()
		on_cooldown = true
	elif not is_powerup_active:
		animation_player.play()
		on_cooldown = false
		
	if not on_cooldown and Input.is_action_just_pressed("activate_ability"):
		is_powerup_active = true
		start_second_timer()
		GameData.get_player().max_jumps = 2
		GameData.get_player().jump_count += 1
			
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

		current_color = current_color.lerp(target_color, step_size)
		self_modulate = current_color

		if cooldown_time <= 0:
			cooldown_label.visible = false
			cooldown_timer.stop()
			self_modulate = target_color
			on_cooldown = false
			animation_player.play()

func reset_cooldown():
	cooldown_time = 5
	current_color = the_current_color
	cooldown_label.text = str(cooldown_time)
	cooldown_label.visible = true
	on_cooldown = true

func stop() -> void:
	cooldown_timer.stop()
	set_process(false)
