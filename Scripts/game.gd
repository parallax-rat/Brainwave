extends Node2D

signal hp_changed(new_hp)
enum MindStates {
	FULL_LEFT, LEFT_3, LEFT_2, LEFT_1, 
	FULL_NEUTRAL, 
	RIGHT_1, RIGHT_2, RIGHT_3, FULL_RIGHT}

@export var health : int :
	get:
		return health
	set(new_health):
		health = new_health
		hp_changed.emit(new_health)
@export var mind_state : MindStates
var health_display : Label
var active_skills = {}
var skill_buttons

func _ready():
	skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
	mind_state = MindStates.FULL_NEUTRAL
	printt("Starting Mind State: ",MindStates.keys()[mind_state])
	call_deferred("connect_buttons")

func connect_buttons():
	for i in skill_buttons:
		i.activate_skill.connect(_on_activate_skill)

func _on_activate_skill(skill):
	if mind_state != MindStates.FULL_NEUTRAL:
		if skill.skill_type == skill.SkillTypes.NEUTRAL:
			pass
