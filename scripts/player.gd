extends CharacterBody2D

const SPEED: float = 300.0
var JUMP_VELOCITY: float = -600.0
var input_enabled: bool = true
var elapsed_time: float = 0.0

var dashing = false
var canDash = true

var dir = 1 # declaring early bc dashing breaks

@export var light_radius: float = 0.2

@export var fade_speed: float = 0.005 # use smth different in the actual thing
@onready var point_light_2d: PointLight2D = $PointLight2D

var start_position: Vector2
var distance: float = 0.0

func _ready() -> void:
	start_position = position
	Global.set_jump_boost(JUMP_VELOCITY)

func _physics_process(delta: float) -> void:
	if !Global.get_game_status(): # pause for shop
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_pressed("jump"):
			if is_on_floor() or (is_on_wall() and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"))):
				velocity.y = JUMP_VELOCITY
			
		# handle candle
		if Input.is_action_just_pressed("increase_candle"):
			light_radius += 0.5
		
		var direction = Input.get_axis("left", "right") # set direction for dash
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		if input_enabled:
			if direction:
				velocity.x = direction * SPEED
			else:
				velocity.x = move_toward(velocity.x, 0, SPEED)

		if is_on_wall() and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and Input.is_action_pressed("ui_up"):
			velocity.x = -velocity.x*1.5
			disable_input(0.5)
			
		if direction and input_enabled:
			velocity.x = direction * SPEED
			dir = direction

		if not dashing:
			$sprite.scale.x = lerp($sprite.scale.x, 1.0, 0.2)
			$sprite.scale.y = lerp($sprite.scale.y, 1.0, 0.2)
			
		if dashing:
			velocity.x = dir*3000
			$sprite.scale.x = 1.5
			$sprite.scale.y = 0.8
			
		if Input.is_action_just_pressed("dash") and canDash and input_enabled and Global.check_dashing():
			dashing = true
			canDash = false
			$dashTimer.start()
			$dashCooldown.start()
			
		move_and_slide()
		
		for i in get_slide_collision_count():
			var collision = get_slide_collision(i)
			
			if not collision:
				continue
			
			if collision.get_collider().is_in_group("Kill"):
				die()

func die() -> void:
	position = Vector2(167, 470)

func disable_input(duration: float) -> void:
	input_enabled = false
	await get_tree().create_timer(duration).timeout
	input_enabled = true

func _process(delta: float) -> void:
	elapsed_time += delta
	Global.set_elapsed_time(elapsed_time)
	if !Global.get_game_status():
		light_radius = GlobalTime.update_radius(delta)
		point_light_2d.texture_scale = light_radius
	
	var delta_distance = position.distance_to(start_position) / 100.0 # px to metres
	if delta_distance > 0.0:
		Global.set_distance(delta_distance)
		
	if GlobalTime.get_time() <= 0.0:
		await get_tree().create_timer(2).timeout
		get_tree().change_scene_to_file("res://scenes/end_screen.tscn")
	

func _on_dash_timer_timeout() -> void:
	canDash = true

func _on_dash_cooldown_timeout() -> void:
	dashing = false
	$sprite.scale = Vector2(1.0,1.0)
