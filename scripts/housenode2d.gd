extends Node2D

@onready var sprite = $AnimatedSprite2D
@onready var color_rect = $ColorRect

func _ready():
	sprite.frame_changed.connect(_on_frame_changed)
	_on_frame_changed()

func _on_frame_changed():
	if sprite.animation != "lights":
		return

	if sprite.frame == 0:
		# Light ON → remove dark filter
		color_rect.material.set_shader_parameter("darkness", 0.0)
	elif sprite.frame == 1:
		# Light OFF → dark filter
		color_rect.material.set_shader_parameter("darkness", 0.7)
