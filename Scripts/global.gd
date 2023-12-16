extends Node

signal log_append_requested(message)

var turn = 0
var player_turns = 0
var enemy_turns = 0

var player
var enemy
var audio_bus

const COLOR_LEFT : Color = Color(1, 0.3, 1, 0.5)
const COLOR_RIGHT : Color = Color(1 ,0.4, 0, 0.5)

func _print(message) -> void:
	log_append_requested.emit(message)
