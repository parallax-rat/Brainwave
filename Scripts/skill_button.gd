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

@onready var shift_right_arrow = %ShiftRightArrow
@onready var shift_left_arrow = %ShiftLeftArrow
@onready var damage = %Damage
@onready var healing = %Healing

var description : String
var bonus_effect: String


###############################################################################


func _enter_tree():
	add_to_group("skill_buttons")


func _ready():
	if skill.damage != 0:
		damage.text = str(skill.damage)
	else:
		damage.visible = false
		damage.get_parent().visible = false
	
	if skill.healing != 0:
		healing.text = str(skill.healing)
	else:
		healing.visible = false
		healing.get_parent().visible = false
	call_deferred("update_skill_data")


func update_skill_data():
	name_label.text = skill.skill_name
	icon = skill.skill_icon
	self.tooltip_text = skill.get_description()
	
	if skill.type == LEFT:
		self_modulate = Color(1, 0.3, 1, 1)
		if skill.skill_number != 0:
			%ShiftLeftArrow.visible = true
	elif skill.type == NEUTRAL:
		self_modulate = Color(.9, .9, .9, 1)
	elif skill.type == RIGHT:
		self_modulate = Color(1 ,0.4, 0, 1)
		if skill.skill_number != 10:
			%ShiftRightArrow.visible = true


func _on_pressed():
	activate_skill.emit(skill)
