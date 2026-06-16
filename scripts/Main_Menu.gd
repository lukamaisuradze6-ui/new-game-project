extends Node2D

@onready var Play_Button: Button = $Sprite2D/play	
@onready var Settings_Button: Button = $Sprite2D/settings
@onready var fade_overlay: ColorRect = $FadeOverlay


#@onready var song = $AudioStreamPlayer2D



func _ready() -> void:
	#song.stream.loop = true
	#song.play()
	Play_Button.pressed.connect(_on_play_button_pressed)
	Settings_Button.pressed.connect(_on_settings_button_pressed)
	
	if Settings.should_fade_in:
		_fade_in_menu()
		Settings.should_fade_in = false 
	else:
		fade_overlay.hide() 

func _fade_in_menu() -> void:
	fade_overlay.modulate.a = 1.0
	fade_overlay.show()
	
	var tween := create_tween()
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 1.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.finished.connect(func(): fade_overlay.hide())

func _on_settings_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/settings.tscn")

func _on_play_button_pressed() -> void:
	Settings.should_fade_in = true 
	get_tree().change_scene_to_file("res://scenes/intro.tscn")
