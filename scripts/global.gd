extends Node

var paused: bool = false # used to pause the game when on the shop menu
var distance: float = 0.0 # the players distance
var jump_boost: float = 0.0 # for shop item (not much boost) and enemy punishment (alot of boost)

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

func set_jump_boost(strength: float):
	jump_boost = strength

func set_high_jump_boost(naye: bool, time: int = -1): # naye is zsh lol but it just is turn on or not
	if naye:
		jump_boost = -1600.0
	else:
		jump_boost = -600.0
	if time == -1:
		time = randi_range(6,7)
	await get_tree().create_timer(time).timeout
	jump_boost = -600.0
	
func set_norm_jump_boost(naye: bool, time: int = -1): # naye is zsh lol but it just is turn on or not
	if naye:
		jump_boost = -900.0
	else:
		jump_boost = -600.0
	if time == -1:
		time = randi_range(6,7)
	await get_tree().create_timer(time).timeout
	jump_boost = -600.0
	
		
func get_jump_boost():
	return jump_boost
