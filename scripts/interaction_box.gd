extends Area2D

@export_multiline var dialogue_text := """THIS IS MY FIRST DIALOGUE.
THIS IS THE SECOND LINE.
THIS IS THE THIRD LINE."""

@onready var label = $Label
@onready var dialogue = $Dialogue

var player = null
var dialogue_started := false


func _ready():
	label.visible = false
	dialogue.hide()

	# Send this InteractBox's text to its Dialogue
	dialogue.dialogue_text = dialogue_text

	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

	dialogue.dialogue_closed.connect(_on_dialogue_closed)


func _on_body_entered(body):
	if body is CharacterBody2D:
		player = body
		label.visible = true


func _on_body_exited(body):
	if body == player:
		player = null
		label.visible = false


func _process(_delta):
	if player != null and Input.is_action_just_pressed("interact") and not dialogue_started:
		dialogue_started = true
		label.hide()

		dialogue.start_dialogue(player)


func _on_dialogue_closed():
	dialogue_started = false
