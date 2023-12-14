extends Control

@onready var console_animation = %ConsoleAnimation

var combat_log_open : bool = true

func _on_button_pressed():
	if combat_log_open:
		console_animation.play("close_console")
		combat_log_open = false
	else:
		console_animation.play("RESET")
		combat_log_open = true
