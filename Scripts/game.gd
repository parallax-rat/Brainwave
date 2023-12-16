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
@export var mind_state : int = FULL_NEUTRAL :
	get:
		return mind_state
	set(new_state):
		mind_state = clamp(new_state,0,8)
		mind_state_changed.emit(mind_state)
		if mind_state < FULL_NEUTRAL:
			mode = LEFT
			#if mind_state == FULL_LEFT:
				#skill_buttons[0].visible = true
		if mind_state > FULL_NEUTRAL:
			mode = RIGHT
			#if mind_state == FULL_RIGHT:
				#skill_buttons[10].visible = true
		if mind_state == FULL_NEUTRAL: 
			mode = NEUTRAL

@onready var canvas_modulate = %CanvasModulate

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
@onready var debuff_immune_display = $CanvasLayer/GUI/DebuffImmune

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
var skill_buttons
var mode : int :
	get:
		return mode
	set(new_mode):
		if new_mode != mode:
			mode = clamp(new_mode,0,2)

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
var turn_ending : bool = true
var debuff_immune : bool = false


###############################################################################


func _ready() -> void:
	Global.player = self
	hp = max_hp
	skill_buttons = get_tree().get_nodes_in_group("skill_buttons")
	for s in skill_buttons:
			s.disabled = true
	call_deferred("connect_buttons")
	call_deferred("enable_buttons")
	await get_tree().create_timer(0.75).timeout
	mode = NEUTRAL
	_player_turn()


func connect_buttons() -> void:
	for i in skill_buttons:
		i.activate_skill.connect(_on_activate_skill)


func enable_buttons() -> void:
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
			s.arrow(s.skill.type)
			s.visible = true
			
			if turn_ending == false:
				for i in mode_range[mind_state]:
					if s.skill.skill_number == i:
						s.disabled = false
						if s.skill.skill_name == "By The Book":
							if mind_state != FULL_NEUTRAL:
								s.skill.description = "Deal 1 damage and return towards neutrality. Prevents enemy actions from shifting your mind next turn."
								s.tooltip_text = s.skill.description
								s.arrow(RIGHT)
							else:
								s.skill.description = "Deal 1 damage and shift left. Prevents enemy actions from shifting your mind next turn."
								s.tooltip_text = s.skill.description
								s.arrow(LEFT)
						if s.skill.skill_name == "Intuition":
							if mind_state > FULL_NEUTRAL:
								s.arrow(LEFT)
							else:
								s.arrow(RIGHT)
		lucid_daydream.visible = false
		logic_paradox.visible = false
		return


func _player_turn() -> void:
	turn_ending = false
	debuff_immune = false
	debuff_immune_display.visible = false
	Global.turn += 1
	Global.player_turns += 1
	player_turn_started.emit(PLAYER)
	enable_buttons()
	await player_skill_activated
	await get_tree().create_timer(1.5).timeout
	for s in skill_buttons:
			s.disabled = true
			s.arrow(NEUTRAL)
	player_turn_ended.emit()


func _on_activate_skill(skill:Skill) -> void:
	_execute_skill(skill)
	turn_ending = true
	enable_buttons()
	await get_tree().create_timer(1.0).timeout
	player_turn_ended.emit()


func mind_shift(direction, val) -> void:
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


func do_damage(dmg:float, type:int) -> void:
	Global.enemy.take_damage(dmg, type)


func take_damage(dmg) -> void:
	hp -= dmg
	animation_player.play("take_damage")


func heal(amount:int) -> void:
	hp += amount


func play_sound(sound:String) -> void:
	Global.audio_bus.play(sound)


func _execute_skill(skill:Skill) -> void:
	
	if skill.skill_name == "By The Book":
		do_damage(skill.damage, skill.type)
		Global.audio_bus.play("Attack")
		debuff_immune = true
		debuff_immune_display.visible = true
		match mode:
			LEFT:
				mind_shift(RIGHT,skill.step_value)
			NEUTRAL:
				mind_shift(LEFT,skill.step_value)
	
	elif skill.skill_name == "Intuition":
		do_damage(skill.damage, skill.type)
		Global.audio_bus.play("Attack")
		match mode:
			RIGHT:
				mind_shift(LEFT,skill.value)
			NEUTRAL:
				mind_shift(RIGHT,skill.step_value)
	
	elif skill.skill_name == "Meditation":
		heal(skill.healing)
		Global.audio_bus.play("Heal")
		match mode:
			NEUTRAL:
				pass
			RIGHT:
				mind_shift(LEFT,skill.step_value)
			LEFT:
				mind_shift(RIGHT,skill.step_value)
	
	else:
		do_damage(skill.damage, skill.type)
		Global.audio_bus.play("Attack")
		mind_shift(skill.type,skill.step_value)


###################### DEBUG ##################################################


func _on_full_left_debug_pressed() -> void:
	mind_state = FULL_LEFT
	enable_buttons()


func _on_full_right_debug_pressed() -> void:
	mind_state = FULL_RIGHT
	enable_buttons()


func _on_full_neutral_debug_pressed() -> void:
	mind_state = FULL_NEUTRAL
	enable_buttons()


func _on_plus_one_pressed(shift_dir) -> void:
	mind_shift(shift_dir, 1)


func _on_minus_one_pressed(shift_dir) -> void:
	mind_shift(shift_dir, -1)


func screen_flash(color) -> void:
	var tween = create_tween()
	tween.tween_property(canvas_modulate, "color", color, 0.25)
