class_name SkillButton
extends Button

signal activate_skill(skill_name:Skill)

@export var skill : Skill :
	get:
		return skill
	set(new_skill):
		if new_skill is Skill:
			skill = new_skill
			update_skill_data()
		else:
			push_error("Cannot assign the non-skill: " + str(new_skill) + " to this location.")

@export var enable_skill : SkillButton
@export var disable_skill : SkillButton
@export_group("Display") 
@export var name_label : Label
@export var shift_label : Label


var description : String
var bonus_effect: String

func update_skill_data():
	name_label.text = skill.skill_name
	tooltip_text = skill.get_description()
	shift_label.text = skill.get_shift_direction()[0]
	shift_label.horizontal_alignment = skill.get_shift_direction()[1]

func _on_pressed():
	activate_skill.emit(skill)
