
extends Node2D

func _ready():
	$Sprite2D/Load.pressed.connect(_on_load_pressed)
	$Sprite2D/NewGame.pressed.connect(_on_new_game_pressed)


func _on_load_pressed():
	if not FileAccess.file_exists("user://savegame.json"):
		return

	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data == null:
		return

	var scene_path = data.get("scene", "")

	if scene_path == "":
		return

	get_tree().change_scene_to_file(scene_path)


func _on_new_game_pressed():
	get_tree().change_scene_to_file("res://scenes/sure_or_not.tscn")
