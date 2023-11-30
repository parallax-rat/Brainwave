class_name Skill
extends Resource

const DAMAGE = "[d]"
const HEALING = "[h]"
const MULTIPLIER = "[m]"

enum WaveTypes {Left, Neutral, Right}


@export var skill_name : String
@export var skill_icon : Texture2D
@export_group("Display Info")
@export_multiline var description : String
@export_multiline var bonus_effect: String
@export var skill_type : WaveTypes
@export var shift_direction : WaveTypes
@export var damage : int
@export var healing : int
@export var multiplier : float
@export var linked_skills : Array[Skill]

func get_description() -> String:
	return description.format({DAMAGE: str(damage),HEALING: str(healing), MULTIPLIER: str(multiplier)})

func get_bonus_effect() -> String:
	return bonus_effect.format({DAMAGE: str(damage),HEALING: str(healing), MULTIPLIER: str(multiplier)})

func get_shift_direction():
	return [str(WaveTypes.keys()[shift_direction]),shift_direction]
