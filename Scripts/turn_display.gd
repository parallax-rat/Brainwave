extends Control

enum {PLAYER, ENEMY}

@onready var label = $Label


func _on_turn_started(current_turn):
	if current_turn == PLAYER:
		label.text = "YOUR TURN!"
		$TurnAnimation.play("player_turn_start")
	else:
		label.text = "ENEMY TURN!"
		$TurnAnimation.play("enemy_turn_start")
