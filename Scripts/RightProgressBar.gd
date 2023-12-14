extends ProgressBar


func _on_combat_test_mind_state_changed(new_mind_state):
	
	if new_mind_state > 4:
		match new_mind_state:
			5:
				value = 1
			6:
				value = 2
			7:
				value = 3
			8:
				value = 4
	else:
		value = 0
