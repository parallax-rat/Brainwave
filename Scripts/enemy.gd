class_name Enemy
extends Control

signal enemy_attacked(attack:Skill)
signal enemy_healed(healing:int)
signal enemy_debuffed(debuff)
signal enemy_mind_state_changed(mind_state)
signal enemy_turn_started(enemy)
signal enemy_turn_ended()

enum {
	SELECT,
	ATTACK,
	HEAL,
	LEFT_2,
	LEFT_4,
	RIGHT_2,
	RIGHT_4,
	TAUNT,
	}
enum {
	PLAYER, 
	ENEMY,
	}
enum SkillType {
	LEFT, 
	NEUTRAL, 
	RIGHT,
	}

@export var sprite : Texture2D
@export var _name : String
@export var max_hp : int
@export var weakness : SkillType
@export var skills : Array[Skill]
@export var xp_value : float

@onready var dmg_label = %DmgLabel
@onready var animation_player = %AnimationPlayer
@onready var enemy_name = %EnemyName
@onready var enemy_sprite = %EnemySprite
@onready var enemy_hp_bar = %EnemyHPBar
@onready var attack_name = %AttackName
@onready var attack_damage_display = %AttackDamage


var hp : float :
	get:
		return hp
	set(new_hp):
		hp = new_hp
		enemy_hp_bar.value = new_hp
var mind_state : SkillType :
	get:
		return mind_state
	set(new_mind_state):
		mind_state = new_mind_state
		enemy_mind_state_changed.emit(new_mind_state)
var usable_attacks = []
var atk
var rng = RandomNumberGenerator.new()


###############################################################################


func _enter_tree():
	add_to_group("enemies")


func _ready():
	enemy_name.text = _name
	hp = max_hp
	for i in skills:
		usable_attacks.append(i)
		print(i.skill_name)


func _on_enemy_turn():
	enemy_turn_started.emit(ENEMY)
	Global.turn += 1
	Global.enemy_turns += 1
	await get_tree().create_timer(1.5).timeout
	await message()
	await attack()
	enemy_turn_ended.emit()


func message():
	#choose message to say
	var msg = rng.randi_range(1,4)
	
	match msg:
		1: print(_name + " looks angry.")
		2: print(_name + " roars towards the sky.")
		3: print(_name + " weeps pitifully.")
		_: print(_name + " stares blankly.")
	
	atk = rng.randi_range(0,1)
	atk = skills[atk]
	attack_name.text = atk.skill_name
	attack_damage_display.text = str(atk.damage)
	animation_player.play("attack_panel_show")
	
	await get_tree().create_timer(1.5).timeout

func attack():
	enemy_attacked.emit(atk)
	await get_tree().create_timer(1.5).timeout


func _on_player_skill_activated(player_attack:Skill):
	var dmg = player_attack.damage
	if player_attack.type == weakness:
		dmg = dmg * 2
		Global._print("Critical effect!")
		
	hp -= dmg
	dmg_label.text = ("-"+str(dmg))
	Global._print(_name + " took " + "[color=red]"+str(dmg)+"[/color]" + " damage!")
	if player_attack.damage != 0:
		animation_player.play("damaged")
