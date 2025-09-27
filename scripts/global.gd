extends Node

var paused: bool = false

func toggle_game_status(status: bool):
	paused = status
	
func get_game_status():
	return paused
