extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
var light_radius: float = 0.1
var max_radius: float = 0.2
var min_radius: float = 0.0

@export var fade_speed: float = 0.005
@onready var point_light_2d: PointLight2D = $PointLight2D

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# handle candle
	if Input.is_action_just_pressed("increase_candle"):
		light_radius += 0.5
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left", "right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _process(delta: float) -> void:
	light_radius -= fade_speed * delta
	light_radius = clamp(light_radius, min_radius, max_radius)
	point_light_2d.texture_scale = light_radius
	
	
