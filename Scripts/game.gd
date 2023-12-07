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
		elif mind_state > FULL_NEUTRAL:
			mode = RIGHT
		else: 
			mode = NEUTRAL

var health_display : Label
var skill_buttons
var mode = NEUTRAL

@onready var left_progress_bar = $GUI/CenterContainer/VBoxContainer/HBoxContainer/LeftProgressBar
@onready var right_progress_bar = $GUI/CenterContainer/VBoxContainer/HBoxContainer/RightProgressBar

func _init():
	pass


func _enter_tree():
	pass


func _ready():
	skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
	mind_state = FULL_NEUTRAL
	printt("Starting Mind State: ",mind_state)
	call_deferred("connect_buttons")
	call_deferred("enable_buttons")


func connect_buttons():
	for i in skill_buttons:
		i.activate_skill.connect(_on_activate_skill)


func _on_activate_skill(skill):
	print(skill.skill_name + " activated.")
	
	for s in skill_buttons:
		s.disabled = true
	
	if skill.type == NEUTRAL and mode == LEFT:
		mind_shift(RIGHT,skill.step_value)
	elif skill.type == NEUTRAL and mode == RIGHT:
		mind_shift(LEFT,skill.step_value)
	elif skill.type == NEUTRAL and mode == NEUTRAL:
		match skill.skill_number:
			4: # by the book
				mind_shift(LEFT,skill.step_value)
			6: # intuition
				mind_shift(RIGHT,skill.step_value)
	else:
		mind_shift(skill.type,skill.step_value)
	
	enable_buttons()
	print(mode)


func mind_shift(direction, step_val):
	printt("Mind shifting...",str(direction),str(step_val))
	if step_val == FULL_NEUTRAL:
		mind_state = FULL_NEUTRAL
	elif direction == LEFT:
		mind_state -= step_val
	elif direction == RIGHT:
		mind_state += step_val


func enable_buttons():
	var left = mind_state
	var center = mind_state + 1
	var right = mind_state + 2
	
	if mind_state == FULL_LEFT:
		skill_buttons[FULL_LEFT].disabled = false
	elif mind_state == FULL_RIGHT:
		skill_buttons[FULL_RIGHT].disabled = false
	else:
		skill_buttons[left].disabled = false
		skill_buttons[center].disabled = false
		skill_buttons[right].disabled = false
