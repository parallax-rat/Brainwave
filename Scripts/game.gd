extends Node

var turn_number = 1
@export var player : Node

enum STATES {TURN_BEGIN, TURN_END}

func _ready():
