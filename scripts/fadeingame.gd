extends ColorRect

@export var fade_speed := 1.0


func _ready():
	var current_color = self.color
	current_color.a = 1.0
	self.color = current_color


func _process(delta):
	var current_color = self.color
	current_color.a -= fade_speed * delta
	current_color.a = max(current_color.a, 0.0)
	self.color = current_color
