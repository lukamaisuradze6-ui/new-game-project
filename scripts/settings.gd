extends Node2D

@onready var Goback_Button: Button = $Sprite2D/settings_to_main





func _ready() -> void:
	Goback_Button.pressed.connect(_back_to_main_func)


func _back_to_main_func()->void:
	get_tree().change_scene_to_file("res://mainmenu.tscn")
