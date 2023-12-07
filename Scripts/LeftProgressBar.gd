extends ProgressBar


func _on_combat_test_mind_state_changed(new_mind_state):
	if new_mind_state < 4:
		match new_mind_state:
			3:
				value = 1
			2:
				value = 2
			1:
				value = 3
			0:
				value = 4
	else:
		value = 0
