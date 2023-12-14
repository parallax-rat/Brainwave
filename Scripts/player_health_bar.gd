extends ProgressBar

@export var hp_display_val : Label

func _on_hp_changed(new_hp, max_hp):
	new_hp = clamp(new_hp,0,max_hp)
	value = new_hp
	hp_display_val.text = str(new_hp)
