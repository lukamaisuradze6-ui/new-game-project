extends ColorRect

@export var fade_speed := 1.0

func _ready():
	var color = self.color
	color.a = 1.0
	self.color = color

func _process(delta):
	var color = self.color
	color.a -= fade_speed * delta
	color.a = max(color.a, 0.0)
	self.color = color
