class_name Skill
extends Resource

enum SkillType {LEFT, NEUTRAL, RIGHT}
enum StepValue {ONE_STEP = 1, TWO_STEPS = 2, RETURN_TO_CENTER = 4}

const DAMAGE = "[d]"
const HEALING = "[h]"
const MULTIPLIER = "[m]"
@export var skill_name : String
@export var skill_icon : Texture2D
@export_group("Display Info")
@export_multiline var description : String
@export_multiline var bonus_effect: String
@export var type : SkillType
@export var step_value : StepValue
@export var skill_number : int
@export var damage : float
@export var healing : int
@export var multiplier : float = 1.0

func get_description() -> String:
	return description.format({DAMAGE: str(damage),HEALING: str(healing), MULTIPLIER: str(multiplier)})

func get_bonus_effect() -> String:
	return bonus_effect.format({DAMAGE: str(damage),HEALING: str(healing), MULTIPLIER: str(multiplier)})

func get_shift_direction():
	return [str(SkillType.keys()[type]),type]

func get_damage() -> float:
	return (damage * multiplier)

func get_healing() -> float:
	return (healing * multiplier)

func get_skill_number() -> int:
	return skill_number

func check_skill_type(check) -> bool:
	if check == type:
		return true
	else:
		return false
