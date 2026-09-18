extends Node

const SAVE_PATH = "user://savegame.json"


func save_game(player):
	var save_data = {
		"scene": get_tree().current_scene.scene_file_path,
		"player_position": {
			"x": player.position.x,
			"y": player.position.y
		}
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(save_data))
	file.close()

	print("GAME SAVED!")


func load_game(player):
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		return

	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	var text = file.get_as_text()
	file.close()

	var save_data = JSON.parse_string(text)

	if save_data == null:
		print("Save file is corrupted.")
		return

	var pos = save_data["player_position"]

	player.position = Vector2(
		pos["x"],
		pos["y"]
	)

	print("GAME LOADED!")
