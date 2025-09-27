extends Node

var paused: bool = false # used to pause the game when on the shop menu
var distance: float = 0.0 # the players distance

signal distance_changed(new_distance: float)

func toggle_game_status(status: bool):
	paused = status
	
func get_game_status():
	return paused

func reset_distance():
	distance = 0.0
	emit_signal("distance_changed", distance)
	
func add_distance(metres: float):
	distance += metres
	emit_signal("distance_changed", distance)

func set_distance(metres: float):
	distance = metres
	emit_signal("distance_changed", distance)
