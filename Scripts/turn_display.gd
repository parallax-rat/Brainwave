extends Control

enum {PLAYER, ENEMY}

@onready var label = $Label


func _on_turn_started(current_turn):
	if current_turn == PLAYER:
		label.text = "YOUR TURN!"
	else:
		label.text = "ENEMY TURN!"
	$TurnAnimation.play("turn_start")
