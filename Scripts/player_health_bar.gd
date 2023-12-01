extends ProgressBar

@export var hp_display_val : Label

func _on_hp_changed(new_hp):
	value = new_hp
	hp_display_val.text = str(new_hp)
