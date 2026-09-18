extends Area2D

var player = null
var game_saved = false

@onready var label = $Label
@onready var shader_material = label.material


func _ready():
	label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)


func _on_body_entered(body):
	if body is CharacterBody2D:
		player = body
		label.visible = true

		if game_saved:
			label.text = "GAME SAVED"


func _on_body_exited(body):
	if body == player:
		player = null

		if not game_saved:
			label.visible = false


func _process(_delta):
	if player != null and Input.is_action_just_pressed("interact"):
		SaveManager.save_game(player)

		game_saved = true
		play_save_animation()	


func play_save_animation():
	var tween = create_tween()

	# Make sure the old text starts fully visible
	shader_material.set_shader_parameter("dissolve_amount", 0.0)

	# OLD TEXT DISINTEGRATES
	tween.tween_method(
		func(value):
			shader_material.set_shader_parameter("dissolve_amount", value),
		0.0,
		1.0,
		0.5
	)

	# Change text while completely dissolved
	tween.tween_callback(func():
		label.text = "GAME SAVED"
	)

	# NEW TEXT REFORMS
	tween.tween_method(
		func(value):
			shader_material.set_shader_parameter("dissolve_amount", value),
		1.0,
		0.0,
		0.5
	)
