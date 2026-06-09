extends Label

const SILENT_DB := -80.0

@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D

var intro_texts: Array[Dictionary] = [
	{"text": "MY MOTHER DIED A YEAR AGO", "speed": 0.08, "wait": 2.0, "sound_duration": 2.0},
	{"text": "MY FATHER ABANDONED US BEFORE WE WERE EVER BORN", "speed": 0.06, "wait": 1.8, "sound_duration": 2.9},
	{"text": "ONE LEFT US BEHIND", "speed": 0.04, "wait": 1.2, "sound_duration": 0.8},
	{"text": "THE OTHER NEVER CARED ENOUGH TO STAY", "speed": 0.04, "wait": 1.5, "sound_duration": 1.6},
	{"text": "FOR SEVENTEEN YEARS, WE HAVE BEEN ALONE", "speed": 0.07, "wait": 2.0, "sound_duration": 2.5},
	{"text": "BECAUSE OF THEM", "speed": 0.03, "wait": 1.8, "sound_duration": 0.7},
	{"text": "ALL I HAVE LEFT IS MY SISTER", "speed": 0.08, "wait": 2.2, "sound_duration": 2.1},
	{"text": "SHE'S THE ONLY PERSON WHO'S EVER STOOD BY ME", "speed": 0.06, "wait": 1.8, "sound_duration": 2.8},
	{"text": "THE ONLY REASON I LIVE", "speed": 0.06, "wait": 2.0, "sound_duration": 1.3},
	{"text": "WE STARVE", "speed": 0.09, "wait": 1.4, "sound_duration": 0.5},
	{"text": "WE THIRST", "speed": 0.09, "wait": 1.4, "sound_duration": 0.5},
	{"text": "BUT STILL", "speed": 0.05, "wait": 1.6, "sound_duration": 0.4},
	{"text": "IF THIS WORLD WANTS TO TAKE HER TOO...", "speed": 0.04, "wait": 1.5, "sound_duration": 1.4},
	{"text": "THEN I'LL BECOME A MONSTER", "speed": 0.03, "wait": 1.3, "sound_duration": 0.8},
	{"text": "I'LL GROW HORNS", "speed": 0.02, "wait": 1.0, "sound_duration": 0.6},
	{"text": "EVEN IF IT COSTS ME GATES OF HELL", "speed": 0.04, "wait": 2.0, "sound_duration": 1.4},
	{"text": "AND ONE DAY, CURSE CAME ONTO ME...", "speed": 0.07, "wait": 3.5, "sound_duration": 2.1}
]

func _ready() -> void:
	text = ""
	await _run_intro()

func _run_intro() -> void:
	for slide in intro_texts:
		text = slide["text"]
		visible_characters = 0
		modulate.a = 1.0

		var type_duration: float = text.length() * slide["speed"]
		var sound_duration: float = slide.get("sound_duration", type_duration + slide["wait"])

		audio_player.volume_db = 0.0
		audio_player.play()

		get_tree().create_timer(sound_duration).timeout.connect(audio_player.stop)

		var type_tween := create_tween()
		type_tween.tween_property(
			self,
			"visible_characters",
			text.length(),
			type_duration
		)

		await type_tween.finished
		await get_tree().create_timer(slide["wait"]).timeout
		await _fade_current_slide()

		audio_player.stop()

	_on_intro_finished()

func _fade_current_slide() -> void:
	var fade_tween := create_tween()
	fade_tween.set_parallel(true)

	fade_tween.tween_property(
		self,
		"modulate:a",
		0.0,
		1.0
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	fade_tween.tween_property(
		audio_player,
		"volume_db",
		SILENT_DB,
		1.0
	).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

	await fade_tween.finished

func _on_intro_finished() -> void:
	audio_player.stop()

	var fade_overlay = get_node_or_null("../FadeOverlay")

	if fade_overlay and fade_overlay.has_method("fade_out"):
		fade_overlay.fade_out(1.5)
		await fade_overlay.fade_finished

	get_tree().change_scene_to_file("res://Animation_Scenes/dream.tscn")
