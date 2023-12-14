extends RichTextLabel

func _ready():
	Global.log_append_requested.connect(_print)

func _print(message):
	push_paragraph(HORIZONTAL_ALIGNMENT_LEFT)
	var time = Time.get_time_string_from_system()
	push_color(Color.BURLYWOOD)
	append_text(time+": ")
	pop()
	append_text(message)
	pop()
