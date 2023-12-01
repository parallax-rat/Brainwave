extends Node

enum BrainWaves {
	LEFT_4, LEFT_3, LEFT_2, LEFT_1,
	NEUTRAL,
	RIGHT_1, RIGHT_2, RIGHT_3, RIGHT_4}

@export var health : int
@export var brain_wave : BrainWaves
