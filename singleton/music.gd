extends AudioStreamPlayer

const MENU_SCENES := [
	"mainmenu.tscn",
	"settings.tscn"
]

func _process(_delta: float) -> void:
	var scene := get_tree().current_scene

	if scene == null:
		return

	var scene_file := scene.scene_file_path.get_file()

	if scene_file in MENU_SCENES:
		if !playing:
			stream.loop = true
			play()
	else:
		if playing:
			stop()
