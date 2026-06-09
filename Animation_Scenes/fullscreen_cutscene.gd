extends AnimatedSprite2D

var cutscene_order: Array[String] = [
	"01_hi",
	"02_i_know_you",
	"03_and_i_know_what_you'll_become",
	"04_horns",
	"05_they_wait_for_you",
	"06_end"
]

var time_per_scene: float = 1.5
var current_anim_index: int = 0

func _ready() -> void:
	_play_next_cutscene()

func _play_next_cutscene() -> void:
	if current_anim_index >= cutscene_order.size():
		_on_entire_intro_finished()
		return
		
	var next_anim_name = cutscene_order[current_anim_index]
	current_anim_index += 1
	
	play(next_anim_name)
	
	await get_tree().create_timer(time_per_scene).timeout
	
	_play_next_cutscene()

func _on_entire_intro_finished() -> void:
	var fade_overlay = get_node_or_null("../FadeOverlay")
	if fade_overlay and fade_overlay.has_method("fade_out"):
		fade_overlay.fade_out(1.5)
		await fade_overlay.fade_finished
	
	get_tree().change_scene_to_file("res://Animation_Scenes/wakeup.tscn")
