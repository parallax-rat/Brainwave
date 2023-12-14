extends LineEdit

const DEBUG = "debug"

@onready var left_debug_buttons = %LeftDebugButtons
@onready var right_debug_buttons = %RightDebugButtons

var debug_enabled : bool = false
var debug_tools

func _ready():
	debug_tools = get_tree().get_nodes_in_group("debug")

func _on_text_submitted(new_text):
	match new_text:
		DEBUG: 
			if debug_enabled:
				debug_enabled = false
				for n in debug_tools:
					n.visible = false
			else:
				debug_enabled = true
				for n in debug_tools:
					n.visible = true
	Global._print(new_text)
	text = ""
