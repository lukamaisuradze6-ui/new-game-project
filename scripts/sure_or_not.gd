extends Node2D

func _ready():
	$Sprite2D/Sure.pressed.connect(_on_sure_pressed)
	$Sprite2D/Back.pressed.connect(_on_back_pressed)


func _on_sure_pressed():
	# Change this to the scene you want to go to
	get_tree().change_scene_to_file("res://scenes/intro.tscn")


func _on_back_pressed():
	# Change this to the scene you want to go back to
	get_tree().change_scene_to_file("res://scenes/LoadOrNew.tscn")
