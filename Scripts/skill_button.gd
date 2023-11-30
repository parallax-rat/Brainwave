extends Button

const LEFT = "Left"
const NEUTRAL = "Neutral"
const RIGHT = "Right"

@export var skill : Skill:
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

var description : String
var bonus_effect: String

func _ready():
	update_skill_data()

func update_skill_data():
	name_label.text = skill.skill_name
	tooltip_text = skill.get_description()
	shift_label.text = skill.get_shift_direction()[0]
	shift_label.horizontal_alignment = skill.get_shift_direction()[1]
