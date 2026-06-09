extends Button

var state := 0

func _ready() -> void:
	pressed.connect(_on_button_pressed)
	_sync_with_settings()

func _sync_with_settings() -> void:
	if Settings.mood == "DARK":
		state = 0
		text = "DARK"
	elif Settings.mood == "COLD":
		state = 1
		text = "COLD"
	else:
		state = 2
		text = "DEFAULT"

func _on_button_pressed() -> void:
	state = (state + 1) % 3
	
	if state == 0:
		text = "DARK"
		Settings.mood = "DARK"
	elif state == 1:
		text = "COLD"
		Settings.mood = "COLD"
	else:
		text = "DEFAULT"
		Settings.mood = "DEFAULT"
