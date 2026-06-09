extends Button

func _ready() -> void:
	pressed.connect(_on_button_pressed)

	if Settings.fullscreen:
		text = "ON"
	else:
		text = "OFF"

func _on_button_pressed() -> void:
	Settings.fullscreen = !Settings.fullscreen

	if Settings.fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		text = "ON"
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		text = "OFF"
