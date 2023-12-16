class_name Enemy
extends Node2D

signal enemy_attacked(attack:Skill)
signal enemy_healed(healing:int)
signal enemy_debuffed(debuff)
signal enemy_mind_state_changed(mind_state)
signal enemy_turn_started(enemy)
signal enemy_turn_ended()
signal screen_flash(color)

enum {
	LEFT, 
	NEUTRAL, 
	RIGHT,
	}
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
@export var overlay_rage : TextureRect

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
	Global.enemy = self
	enemy_name.text = _name
	hp = max_hp
	for i in skills:
		usable_attacks.append(i)
	animation_player.play("idle")


func _on_enemy_turn():
	enemy_turn_started.emit(ENEMY)
	Global.turn += 1
	Global.enemy_turns += 1
	await get_tree().create_timer(1.5).timeout
	await message()
	


func message():
	atk = rng.randi_range(0,1)
	atk = skills[atk]
	attack_name.text = atk.skill_name
	attack_damage_display.text = str(atk.damage)
	animation_player.play("attack_panel_show")
	
	await get_tree().create_timer(1.5).timeout
	if atk.skill_name == "Clobber":
		animation_player.play("attack")
		
	elif atk.skill_name == "Taunt":
		if !Global.player.debuff_immune:
			animation_player.play("taunt")
			await animation_player.animation_finished
			taunt()
		else:
			Global._print("You are immune to {Enemy}'s taunt this turn.".format({"Enemy": _name}))
			await sprite_emote(1, 2.0)
			await get_tree().create_timer(0.3).timeout
			enemy_turn_ended.emit()


func attack():
	Global.player.take_damage(atk.damage)
	await animation_player.animation_finished
	animation_player.play("idle")
	enemy_turn_ended.emit()


func taunt():
	Global.player.mind_shift(RIGHT, 1)


func take_damage(dmg, type):
	if type == weakness:
		dmg = dmg * 2
		Global._print("Critical effect!")
		
	if dmg != 0:
		Global._print(_name + " took " + "[color=red]"+str(dmg)+"[/color]" + " damage!")
		hp -= dmg
		dmg_label.text = ("-"+str(dmg))
		animation_player.play("damage_numbers")
	sprite_flash()
	sprite_emote(1, 0.5)


func sprite_flash() -> void:
	var tween: Tween = create_tween()
	tween.tween_property(enemy_sprite, "self_modulate:v", 1, 0.25).from(5)


func sprite_emote(emotion:int, duration:float) -> void:
	enemy_sprite.frame = emotion
	await get_tree().create_timer(duration).timeout
	enemy_sprite.frame = 0


func call_screen_flash(color) -> void:
	screen_flash.emit(color)
