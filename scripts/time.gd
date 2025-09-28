extends Node

@export var size_rate: float = 1500
@export var duration: float = 10.0 # seconds to go from 0.2 to 0
@export var current_radius: float = 0.2
var max_radius: float = 0.2
var min_radius: float = 0.0
 
signal time_changed(new_time: float)

func get_time() -> float:
	# remaining time proportional to distance between min and max
	return (current_radius - min_radius) / (max_radius - min_radius) * duration
func subtract_time(time: float):
	# subtracts time directly from current_radius
	var ratio = time / duration
	current_radius -= (max_radius - min_radius) * ratio
	current_radius = clamp(current_radius, min_radius, max_radius)
	emit_signal("time_changed", get_time())
	
func update_radius(delta: float):
	# reduce radius every second
	current_radius -= (max_radius - min_radius) / duration * delta
	current_radius = clamp(current_radius, min_radius, max_radius)
	emit_signal("time_changed", get_time())
	return current_radius
	
func get_radius() -> float:
	return current_radius
	
func set_radius(radius: float) -> void:
	current_radius = clamp(radius, min_radius, max_radius)
	emit_signal("time_changed", get_time())
