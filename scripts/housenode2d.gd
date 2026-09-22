extends Node2D

@onready var sprite = $AnimatedSprite2D

func _ready():
	sprite.frame_changed.connect(_on_frame_changed)
	_on_frame_changed()

func _on_frame_changed():
	if sprite.animation != "lights":
		return
