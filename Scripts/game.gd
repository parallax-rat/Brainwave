extends Node2D
# main body to process most game functions

signal hp_changed(new_hp)
signal mind_state_changed(new_mind_state)

enum {LEFT, NEUTRAL, RIGHT}
enum {
	FULL_LEFT, 
	LEFT_3, 
	LEFT_2, 
	LEFT_1,  
	FULL_NEUTRAL, 
	RIGHT_1, 
	RIGHT_2, 
	RIGHT_3, 
	FULL_RIGHT,
	}

@export var health : int :
	get:
		return health
	set(new_health):
		health = new_health
		hp_changed.emit(new_health)
@export var mind_state : int :
	get:
		return mind_state
	set(new_state):
		mind_state = clamp(new_state,0,10)
		mind_state_changed.emit(new_state)
		if mind_state < FULL_NEUTRAL:
			mode = LEFT
			if mind_state == FULL_LEFT:
				skill_buttons[0].visible = true
		if mind_state > FULL_NEUTRAL:
			mode = RIGHT
			if mind_state == FULL_RIGHT:
				skill_buttons[10].visible = true
		if mind_state == FULL_NEUTRAL: 
			mode = NEUTRAL
		printt("New mind state: ",str(mind_state))

var health_display : Label
var skill_buttons
var mode : int :
	get:
		return mode
	set(new_mode):
		if new_mode != mode:
			mode = clamp(new_mode,0,2)
			printt("New mode: ",str(mode))
		
var mode_range = {
	FULL_LEFT: 0,
	LEFT_3: range(1,4),
	LEFT_2: range(2,5),
	LEFT_1: range(3,6),
	FULL_NEUTRAL: range(4,7),
	RIGHT_1: range(5,8),
	RIGHT_2: range(6,9),
	RIGHT_3: range(7,10),
	FULL_RIGHT: 10,
}

@onready var left_progress_bar = $GUI/CenterContainer/VBoxContainer/HBoxContainer/LeftProgressBar
@onready var right_progress_bar = $GUI/CenterContainer/VBoxContainer/HBoxContainer/RightProgressBar

func _init():
	pass


func _enter_tree():
	pass


func _ready():
	skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
	mind_state = FULL_NEUTRAL
	mode
	printt("Starting Mind State: ",mind_state)
	call_deferred("connect_buttons")
	call_deferred("enable_buttons")


func connect_buttons():
	for i in skill_buttons:
		i.activate_skill.connect(_on_activate_skill)


func _on_activate_skill(skill):
	print(skill.skill_name + " activated.")
	printt("Type:",str(skill.type),"Step:",str(skill.step_value))
	
	for s in skill_buttons:
		s.disabled = false
		s.visible = false
		
	if skill.type == NEUTRAL:
		match mode:
			LEFT:
				mind_shift(RIGHT,skill.step_value)
			NEUTRAL:
				if skill.skill_name == "By The Book":
						mind_shift(LEFT,skill.step_value)
				if skill.skill_name == "Intuition":
						mind_shift(RIGHT,skill.step_value)
			RIGHT:
				mind_shift(LEFT,skill.step_value)
	else:
		printt("Skill NOT neutral","Skill:",str(skill.type))
		mind_shift(skill.type,skill.step_value)
	
	enable_buttons()


func mind_shift(direction, val):
	printt("Mind shifting...",str(direction),str(val))
	
	if val == 4:
		mind_state = FULL_NEUTRAL
	elif direction == LEFT:
		mind_state = mind_state - val
	elif direction == RIGHT:
		mind_state = mind_state + val
	
	print("Mind arrived at " + str(mind_state))


func enable_buttons():
	if mind_state == FULL_LEFT:
		for s in skill_buttons:
			if s.skill.skill_name != "Logic Paradox":
				s.visible = false
		return
	elif mind_state >= FULL_RIGHT:
		for s in skill_buttons:
			if s.skill.skill_name != "Lucid Daydream":
				s.visible = false
		return

	for n in mode_range[mind_state]:
		skill_buttons[n].visible = true
