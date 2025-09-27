extends CharacterBody2D

const SPEED: float = 600.0
var JUMP_VELOCITY: float = -600.0
var input_enabled: bool = true

@export var light_radius: float = 0.2

@export var fade_speed: float = 0.005 # use smth different in the actual thing
@onready var point_light_2d: PointLight2D = $PointLight2D

var start_position: Vector2
var distance: float = 0.0

func _ready() -> void:
	start_position = position
	Global.set_jump_boost(JUMP_VELOCITY)

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("ui_up"):
		if is_on_floor() or (is_on_wall() and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"))):
			velocity.y = JUMP_VELOCITY
		
	# handle candle
	if Input.is_action_just_pressed("increase_candle"):
		light_radius += 0.5
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	if input_enabled:
		var direction := Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

	if is_on_wall() and (Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right")) and Input.is_action_pressed("ui_up"):
		velocity.x = -velocity.x*1.5
		disable_input(0.5)
		
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		if collision.get_collider().is_in_group("Kill"):
			die()

func die() -> void:
	position = Vector2(67, 440)

func disable_input(duration: float) -> void:
	input_enabled = false
	await get_tree().create_timer(duration).timeout
	input_enabled = true

func _process(delta: float) -> void:
	if !Global.get_game_status():
		light_radius = GlobalTime.update_radius(delta)
		point_light_2d.texture_scale = light_radius
	
	var delta_distance = position.distance_to(start_position) / 100.0 # px to metres
	if delta_distance > 0.0:
		Global.set_distance(delta_distance)
	
	
