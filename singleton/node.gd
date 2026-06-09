extends Node

@onready var overlay = $CanvasLayer/ColorRect



func _process(_delta):
	match Settings.mood:
		"DARK":
			overlay.color = Color(0, 0, 0, 0.35)

		"COLD":
			overlay.color = Color(0.4, 0.6, 1.0, 0.15)

		_:
			overlay.color = Color(0, 0, 0, 0)
