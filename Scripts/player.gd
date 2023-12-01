extends Node

enum BrainWaves {
	LEFT_4, LEFT_3, LEFT_2, LEFT_1,
	NEUTRAL,
	RIGHT_1, RIGHT_2, RIGHT_3, RIGHT_4}

@export var health : int
@export var healthBar : Node
@export var brain_wave : BrainWaves
var active_skills = {}

func _ready():
	brain_wave = BrainWaves.NEUTRAL
	healthBar.value = health
