extends CanvasLayer

@onready var dialogue_label: Label = $Panel/Label
@export var player: CharacterBody2D

var dialogue_lines = [
	"THAT WAS MY SISTER!",
	"WHERE ARE YOU ANN!",
	"STOP PLAYING HIDE AND SEEK",

	"I'M SCARED! COME OUT!",
	"ANN?",
	"NO NO NO THIS CAN'T BE IT!!!",

]

var current_line := 0
var current_character := 0

var typing_speed := 0.04
var wait_between_lines := 1.0
var wait_after_three_lines := 2.0

var typing := false
var dialogue_finished := false


func _ready():

	# If this dialogue has already happened,
	# don't play it again.
	if SaveManager.dialogue_seen:
		hide()
		return

	dialogue_label.text = ""

	# Mark dialogue as seen immediately.
	SaveManager.dialogue_seen = true

	if player:
		player.can_move = false

	start_line()

func _process(_delta):

	# Dialogue is completely finished
	if dialogue_finished:

		if Input.is_action_just_pressed("ui_accept"):

			if player:
				player.can_move = true
				player.velocity = Vector2.ZERO

			hide()

		return

	# Accept while text is typing = instantly finish current line
	if Input.is_action_just_pressed("ui_accept") and typing:

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

		# Every 3 lines
		if current_line % 3 == 0:

			await get_tree().create_timer(wait_after_three_lines).timeout

			dialogue_label.text = ""

		else:

			dialogue_label.text += "\n"

			await get_tree().create_timer(wait_between_lines).timeout

		start_line()

	else:

		# Keep final dialogue visible
		dialogue_finished = true
