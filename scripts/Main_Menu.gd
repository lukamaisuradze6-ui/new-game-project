extends Node2D
const LoadOrNew = "res://scenes/LoadOrNew.tscn"
const INTRO_SCENE := "res://scenes/intro.tscn"
const SETTINGS_SCENE := "res://scenes/settings.tscn"

@onready var Play_Button: Button = $Sprite2D/play
@onready var Settings_Button: Button = $Sprite2D/settings
@onready var fade_overlay: ColorRect = $FadeOverlay

var changing_scene := false

func _ready() -> void:
	Play_Button.pressed.connect(_on_play_button_pressed)
	Settings_Button.pressed.connect(_on_settings_button_pressed)

	Play_Button.mouse_entered.connect(_on_play_mouse_entered)
	Play_Button.mouse_exited.connect(_on_play_mouse_exited)

	Settings_Button.mouse_entered.connect(_on_settings_mouse_entered)
	Settings_Button.mouse_exited.connect(_on_settings_mouse_exited)

	if Settings.should_fade_in:
		_fade_in_menu()
		Settings.should_fade_in = false
	else:
		fade_overlay.hide()


func _fade_in_menu() -> void:
	fade_overlay.modulate.a = 1.0
	fade_overlay.show()

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 0.0, 1.5)

	await tween.finished
	fade_overlay.hide()


func _fade_out_and_change(scene_path: String) -> void:
	if changing_scene:
		return

	changing_scene = true

	Play_Button.disabled = true
	Settings_Button.disabled = true

	fade_overlay.modulate.a = 0.0
	fade_overlay.show()

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(fade_overlay, "modulate:a", 1.0, 0.5)

	await tween.finished
	get_tree().change_scene_to_file(scene_path)


func _on_settings_button_pressed() -> void:
	Settings.should_fade_in = true
	_fade_out_and_change(SETTINGS_SCENE)


func _on_play_button_pressed() -> void:
	Settings.should_fade_in = true
	_fade_out_and_change(LoadOrNew)


func _on_play_mouse_entered() -> void:
	create_tween().tween_property(Play_Button, "scale", Vector2(1.05, 1.05), 0.1)


func _on_play_mouse_exited() -> void:
	create_tween().tween_property(Play_Button, "scale", Vector2.ONE, 0.1)


func _on_settings_mouse_entered() -> void:
	create_tween().tween_property(Settings_Button, "scale", Vector2(1.05, 1.05), 0.1)


func _on_settings_mouse_exited() -> void:
	create_tween().tween_property(Settings_Button, "scale", Vector2.ONE, 0.1)


func _unhandled_input(event: InputEvent) -> void:
	if changing_scene:
		return

	if event.is_action_pressed("ui_accept"):
		_on_play_button_pressed()

	elif event.is_action_pressed("ui_cancel"):
		_on_settings_button_pressed()
