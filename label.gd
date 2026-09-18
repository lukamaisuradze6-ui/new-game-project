extends Label

var intro_texts: Array[String] = [
	"BAD OMENS STUDIOS\nPRESENTS",
	"THE HORNED ONE\n"
]

var current_index: int = 0

func _ready() -> void:
	_show_next_text()

func _show_next_text() -> void:
	if current_index >= intro_texts.size():
		_on_intro_finished()
		return
		
	var current_text = intro_texts[current_index]
	current_index += 1
	
	text = current_text
	visible_characters = 0
	modulate.a = 1.0
	
	var type_duration := text.length() * 0.05
	var tween := create_tween()
	
	tween.tween_property(self, "visible_characters", text.length(), type_duration)
	
	tween.tween_interval(1.5)
	
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	tween.finished.connect(_show_next_text)

func _on_intro_finished() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
