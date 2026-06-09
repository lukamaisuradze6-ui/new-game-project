extends Label

# A list of all the texts you want to show, in order
var intro_texts: Array[String] = [
	"BAD OMENS STUDIOS\nPRESENTS",
	"THE HORNED ONE\n" # Change this to your actual game name!
]

var current_index: int = 0

func _ready() -> void:
	# Start the loop by playing the very first text
	_show_next_text()

func _show_next_text() -> void:
	# Check if we have run out of text to display
	if current_index >= intro_texts.size():
		_on_intro_finished()
		return
		
	# Get the current text and advance our counter for next time
	var current_text = intro_texts[current_index]
	current_index += 1
	
	# Reset the label appearance for the new text
	text = current_text
	visible_characters = 0
	modulate.a = 1.0
	
	# Calculate typing duration based on string length
	var type_duration := text.length() * 0.05
	var tween := create_tween()
	
	# 1. Type the characters out
	tween.tween_property(self, "visible_characters", text.length(), type_duration)
	
	# 2. Wait and let the player read it
	tween.tween_interval(1.5)
	
	# 3. Fade the text out smoothly
	tween.tween_property(self, "modulate:a", 0.0, 1.0).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	
	# 4. Instead of changing scenes immediately, loop back to check for the next text!
	tween.finished.connect(_show_next_text)

func _on_intro_finished() -> void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
