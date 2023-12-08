class_name SkillButton
extends Button

signal activate_skill(skill:Skill)

enum {LEFT, NEUTRAL, RIGHT}

@export var skill : Skill :
	get:
		return skill
	set(new_skill):
		if new_skill is Skill:
			skill = new_skill
			update_skill_data()
		else:
			push_error("Cannot assign the non-skill: " + str(new_skill) + " to this location.")

@export_group("Display") 
@export var name_label : Label
@export var shift_label : Label
@export_color_no_alpha var left_color : Color
@export_color_no_alpha var neutral_color : Color
@export_color_no_alpha var right_color : Color
@export_group("Interactions")
@export var button_activate : SkillButton
@export var button_deactivate : SkillButton

var description : String
var bonus_effect: String


func _enter_tree():
	add_to_group("skill_buttons")

func update_skill_data():
	name_label.text = skill.skill_name
	tooltip_text = skill.get_description()
	shift_label.text = skill.get_shift_direction()[0]
	shift_label.horizontal_alignment = skill.get_shift_direction()[1]

func _on_pressed():
	
	activate_skill.emit(skill)
