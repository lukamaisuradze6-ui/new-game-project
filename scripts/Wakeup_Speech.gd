extends Label

var lines: Array[String] = [
	"OH GOD",
	"THAT WAS SCARY",
	"*HUUUSH...*",
	"EVERYTHING'S FINE...",
	"..."
]

var current_line_index: int = 0

func _ready() -> void:
	text = ""
	start_typing_next_line()

func start_typing_next_line() -> void:
	if current_line_index >= lines.size():
		# Replace the entire stack with the final message
		text = "HEELPW...*#$*#$*#$*#$..."
		visible_characters = text.length()

		# Keep final message on screen for 4 seconds
		await get_tree().create_timer(2.0).timeout

		# Change to the next scene
		get_tree().change_scene_to_file("res://scenes/INGAME_PAGE_1.tscn")

		return

	var new_text = lines[current_line_index]

	if text == "":
		text = new_text
	else:
		text += "\n" + new_text

	var start_char_count = text.length() - new_text.length()
	var total_char_count = text.length()

	visible_characters = start_char_count

	var duration: float = new_text.length() * 0.05

	var tween = create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_IN)

	tween.tween_property(
		self,
		"visible_characters",
		total_char_count,
		duration
	)

	tween.finished.connect(func():
		var delay: float = 1.6

		if current_line_index == 1:
			delay = 0.4
		elif current_line_index == 2:
			delay = 0.4
		elif current_line_index == 3:
			delay = 1.0

		current_line_index += 1

		await get_tree().create_timer(delay).timeout
		start_typing_next_line()
	)
	
