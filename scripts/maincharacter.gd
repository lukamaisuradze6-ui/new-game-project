extends CharacterBody2D

var can_move := true

@export var speed := 200.0


func _ready():
	SaveManager.load_game(self)


func _physics_process(_delta):

	if not can_move:
		velocity = Vector2.ZERO
		$AnimatedSprite2D2.stop()
		return

	var direction := Vector2.ZERO

	if Input.is_key_pressed(KEY_W):
		direction.y -= 1

	if Input.is_key_pressed(KEY_S):
		direction.y += 1

	if Input.is_key_pressed(KEY_A):
		direction.x -= 1

	if Input.is_key_pressed(KEY_D):
		direction.x += 1

	velocity = direction.normalized() * speed
	move_and_slide()

	if direction != Vector2.ZERO:
		if not $AnimatedSprite2D2.is_playing():
			$AnimatedSprite2D2.play("walk")
	else:
		$AnimatedSprite2D2.stop()
