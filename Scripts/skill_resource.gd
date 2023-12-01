class_name Skill
extends Resource

enum SkillType {LEFT = -1, NEUTRAL = 0, RIGHT = 1}
enum StepValue {ONE_STEP = 1, TWO_STEPS = 2}

const DAMAGE = "[d]"
const HEALING = "[h]"
const MULTIPLIER = "[m]"
@export var skill_name : String
@export var skill_icon : Texture2D
@export_group("Display Info")
@export_multiline var description : String
@export_multiline var bonus_effect: String
@export var skill_type : SkillType
@export var step_value : StepValue
@export var damage : float
@export var healing : int
@export var multiplier : float = 1.0
@export var linked_skills : Array[Skill]

func get_description() -> String:
	return description.format({DAMAGE: str(damage),HEALING: str(healing), MULTIPLIER: str(multiplier)})

func get_bonus_effect() -> String:
	return bonus_effect.format({DAMAGE: str(damage),HEALING: str(healing), MULTIPLIER: str(multiplier)})

func get_shift_direction():
	return [str(SkillType.keys()[skill_type]),skill_type]

func get_damage() -> float:
	return (damage * multiplier)

func get_healing() -> float:
	return (healing * multiplier)
