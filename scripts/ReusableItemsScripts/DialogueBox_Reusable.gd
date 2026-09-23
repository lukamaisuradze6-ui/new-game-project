extends CanvasLayer

signal dialogue_closed

@onready var dialogue_label: Label = $Panel/Label

@export_multiline var dialogue_text := """THIS IS MY FIRST DIALOGUE.
THIS IS THE SECOND LINE.
AND THIS IS THE THIRD LINE."""

var dialogue_lines: PackedStringArray
var current_line := 0
var current_character := 0

var typing_speed := 0.04
var wait_between_lines := 1.0
var wait_after_three_lines := 2.0

var typing := false
var dialogue_finished := false
var player = null


func _ready():
	hide()
	dialogue_label.text = ""


func start_dialogue(player_ref):
	player = player_ref

	# Convert the text from the Inspector into separate lines
	dialogue_lines = dialogue_text.split("\n", false)

	show()

	current_line = 0
	current_character = 0
	typing = false
	dialogue_finished = false
	dialogue_label.text = ""

	if player:
		player.can_move = false

	start_line()


func _process(_delta):

	# Dialogue is finished.
	# Press E to close it.
	if dialogue_finished:

		if Input.is_action_just_pressed("interact"):

			if player:
				player.can_move = true
				player.velocity = Vector2.ZERO

			hide()
			dialogue_closed.emit()

		return


	# Press E while typing to instantly finish current line.
	if Input.is_action_just_pressed("interact") and typing:

		dialogue_label.text += dialogue_lines[current_line].substr(current_character)

		current_character = dialogue_lines[current_line].length()

		typing = false


func start_line():

	if current_line >= dialogue_lines.size():
		dialogue_finished = true
		return

	typing = true
	current_character = 0

	type_line()


func type_line():

	while current_character < dialogue_lines[current_line].length():

		if not typing:
			return

		dialogue_label.text += dialogue_lines[current_line][current_character]

		current_character += 1

		await get_tree().create_timer(typing_speed).timeout


	typing = false

	current_line += 1


	if current_line < dialogue_lines.size():

		if current_line % 3 == 0:

			await get_tree().create_timer(wait_after_three_lines).timeout

			dialogue_label.text = ""

		else:

			dialogue_label.text += "\n"

			await get_tree().create_timer(wait_between_lines).timeout

		start_line()

	else:

		dialogue_finished = true
