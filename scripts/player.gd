extends CharacterBody2D

const SPEED = 600.0
const JUMP_VELOCITY = -600.0
@export var light_radius: float = 0.2

@export var fade_speed: float = 0.005 # use smth different in the actual thing
@onready var point_light_2d: PointLight2D = $PointLight2D

var start_position: Vector2
var distance: float = 0.0

func _ready() -> void:
	start_position = position

func _physics_process(delta: float) -> void:
	if !Global.get_game_status(): # true = paused, false = normal
		# Add the gravity.
		if not is_on_floor():
			velocity += get_gravity() * delta

		# Handle jump.
		if Input.is_action_pressed("jump") and is_on_floor():
			velocity.y = JUMP_VELOCITY
		
		# handle candle
		if Input.is_action_just_pressed("increase_candle"):
			light_radius += 0.5
			GlobalTime.set_radius(light_radius)
		
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var direction := Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()

func _process(delta: float) -> void:
	if !Global.get_game_status():
		light_radius = GlobalTime.update_radius(delta)
		point_light_2d.texture_scale = light_radius
	
	var delta_distance = position.distance_to(start_position) / 100.0 # px to metres
	if delta_distance > 0.0:
		Global.set_distance(delta_distance)
	
	
