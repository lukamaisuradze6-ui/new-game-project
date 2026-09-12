extends Sprite2D

@export var move_distance := 5.0
@export var speed := 2.0

var start_y: float

func _ready():
	start_y = position.y

func _process(delta):
	position.y = start_y + sin(Time.get_ticks_msec() / 1000.0 * speed) * move_distance
