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
var skip_current_line := false

var player = null


func _ready():
	hide()
	dialogue_label.text = ""


func start_dialogue(player_ref):

	player = player_ref

	# Get the lines from the Inspector
	dialogue_lines = dialogue_text.split("\n", false)

	# Reset everything
	current_line = 0
	current_character = 0
	typing = false
	dialogue_finished = false
	skip_current_line = false

	dialogue_label.text = ""

	# Show dialogue
	show()

	# Lock player
	if player:
		player.can_move = false
		player.velocity = Vector2.ZERO

	# Start dialogue
	_run_dialogue()


func _process(_delta):

	# Keep player locked while dialogue is open
	if visible:

		if player:
			player.can_move = false
			player.velocity = Vector2.ZERO


	# =================================
	# SPACE = SKIP CURRENT LINE
	# =================================

	if Input.is_key_pressed(KEY_SPACE):

		# Only skip if the line is currently typing
		if typing:
			skip_current_line = true


	# =================================
	# E = CLOSE AFTER DIALOGUE FINISHES
	# =================================

	if Input.is_action_just_pressed("interact"):

		# Only allow E to close AFTER all dialogue
		# has finished.
		if dialogue_finished:

			if player:
				player.can_move = true
				player.velocity = Vector2.ZERO

			hide()

			dialogue_closed.emit()


func _run_dialogue():

	dialogue_label.text = ""

	while current_line < dialogue_lines.size():

		# Reset line state
		typing = true
		skip_current_line = false
		current_character = 0

		var line_text: String = dialogue_lines[current_line]


		# =================================
		# NEW PAGE
		# =================================

		# Every 3 lines, clear the box
		if current_line % 3 == 0:

			dialogue_label.text = ""

		# Lines 2 and 3 go underneath
		elif current_line > 0:

			dialogue_label.text += "\n"


		# =================================
		# TYPE THE LINE
		# =================================

		while current_character < line_text.length():

			# SPACE was pressed
			if skip_current_line:

				# Instantly finish the line
				dialogue_label.text += line_text.substr(
					current_character
				)

				current_character = line_text.length()

				break


			# Add one character
			dialogue_label.text += line_text[current_character]

			current_character += 1


			# Typing delay
			await get_tree().create_timer(
				typing_speed
			).timeout


		# Line finished
		typing = false


		# =================================
		# MOVE TO NEXT LINE
		# =================================

		current_line += 1


		# =================================
		# FINAL LINE
		# =================================

		if current_line >= dialogue_lines.size():

			dialogue_finished = true

			# Keep final dialogue visible
			return


		# =================================
		# WAIT BEFORE NEXT LINE
		# =================================

		if not skip_current_line:

			# Every 3rd line
			if current_line % 3 == 0:

				await get_tree().create_timer(
					wait_after_three_lines
				).timeout

			# Normal line
			else:

				await get_tree().create_timer(
					wait_between_lines
				).timeout


	# Safety
	dialogue_finished = true
