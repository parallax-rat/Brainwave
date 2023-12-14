extends Control
# main body to process most game functions
# handles:
# 1. mind state
# 2. mind mode
# 3. skill button display
# 4. 

signal player_hp_changed(new_hp,max_hp)
signal player_mind_shifted()
signal player_skill_activated(skill:Skill)
signal mind_state_changed(new_mind_state)
signal player_turn_started(player)
signal player_turn_ended()

enum {
	PLAYER, 
	ENEMY,
	}
enum {
	LEFT, 
	NEUTRAL, 
	RIGHT,
	}
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

@export var max_hp : float = 10
@export var mind_state : int :
	get:
		return mind_state
	set(new_state):
		mind_state = clamp(new_state,0,8)
		mind_state_changed.emit(mind_state)
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


@onready var logic_paradox = %LogicParadox
@onready var death_date = %DeathDate
@onready var interpret = %Interpret
@onready var step_in_line = %StepInLine
@onready var by_the_book = %ByTheBook
@onready var meditate = %Meditate
@onready var intuition = %Intuition
@onready var holistic_mind = %HolisticMind
@onready var deceive = %Deceive
@onready var binaural_trance = %BinauralTrance
@onready var lucid_daydream = %LucidDaydream

@onready var combat_log = %RichTextLabel
@onready var audio_bus = %AudioBus
@onready var animation_player = %AnimationPlayer
@onready var left_progress_bar = %LeftProgressBar
@onready var right_progress_bar = %RightProgressBar

var hp : float :
	get:
		return hp
	set(new_health):
		new_health = clamp(new_health,0,max_hp)
		hp = new_health
		player_hp_changed.emit(hp,max_hp)
		print("Player HP: "+str(hp))
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
var turn_ending : bool

###############################################################################


func _init():
	mind_state = FULL_NEUTRAL


func _ready():
	hp = max_hp
	skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
	call_deferred("connect_buttons")
	call_deferred("enable_buttons")
	get_tree().set_group("skill_buttons", "disabled", true)
	await get_tree().create_timer(0.5).timeout
	_player_turn()


func connect_buttons():
	for i in skill_buttons:
		i.activate_skill.connect(_on_activate_skill)


func enable_buttons():
	if mind_state == FULL_LEFT:
		for s in skill_buttons:
			s.disabled = true
			s.visible = false
		logic_paradox.visible = true
		logic_paradox.disabled = false
		return
	elif mind_state == FULL_RIGHT:
		for s in skill_buttons:
			s.disabled = true
			s.visible = false
		lucid_daydream.visible = true
		lucid_daydream.disabled = false
		return
	else:
		for s in skill_buttons:
			s.disabled = true
			s.visible = true
			if turn_ending == false:
				for i in mode_range[mind_state]:
					if s.skill.skill_number == i:
						s.disabled = false
						if s.skill.skill_name == "By The Book":
							if mind_state < FULL_NEUTRAL:
								s.shift_left_arrow.visible = false
								s.shift_right_arrow.visible = true
							else:
								s.shift_left_arrow.visible = true
								s.shift_right_arrow.visible = false
						if s.skill.skill_name == "Intuition":
							if mind_state > FULL_NEUTRAL:
								s.shift_left_arrow.visible = true
								s.shift_right_arrow.visible = false
							else:
								s.shift_left_arrow.visible = false
								s.shift_right_arrow.visible = true
		lucid_daydream.visible = false
		logic_paradox.visible = false
		return


func _player_turn():
	turn_ending = false
	Global.turn += 1
	Global.player_turns += 1
	player_turn_started.emit(PLAYER)
	
	await get_tree().create_timer(1.0).timeout
	enable_buttons()
	await player_skill_activated
	await get_tree().create_timer(1.5).timeout
	
	player_turn_ended.emit()


func _on_activate_skill(skill:Skill):
	turn_ending = true
	get_tree().set_group("skill_buttons", "disabled", true)
	enable_buttons()
	
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
	
	await get_tree().create_timer(0.3).timeout
	player_skill_activated.emit(skill)


func mind_shift(direction, val):
	var text_dir : String
	match direction:
		0: text_dir = "shifts left"
		1: text_dir = "shifts toward neutrality"
		2: text_dir = "shifts right"
		
	Global._print("Your mind " + text_dir + " by " + str(val))
	
	if val == 4:
		mind_state = FULL_NEUTRAL
	elif direction == LEFT:
		mind_state = mind_state - val
	elif direction == RIGHT:
		mind_state = mind_state + val
	
	print("Mind arrived at " + str(mind_state))
	enable_buttons()


func _on_enemy_attacked(attack:Skill):
	if attack.skill_name == "Taunt":
		print("Taunt shifted your mind to the right.")
		mind_shift(RIGHT, 1)
		print("Player HP: "+str(hp))
	else:
		hp -= attack.damage
		animation_player.play("take_damage")


func _on_player_skill_activated(_skill:Skill):
	if _skill.healing != 0:
		hp += _skill.healing


###################### DEBUG ##################################################


func _on_full_left_debug_pressed():
	mind_state = FULL_LEFT
	enable_buttons()


func _on_full_right_debug_pressed():
	mind_state = FULL_RIGHT
	enable_buttons()


func _on_full_neutral_debug_pressed():
	mind_state = FULL_NEUTRAL
	enable_buttons()


func _on_plus_one_pressed(shift_dir):
	mind_shift(shift_dir, 1)


func _on_minus_one_pressed(shift_dir):
	mind_shift(shift_dir, -1)
