extends Node2D
var score: int
func _ready():
	score = global.total_time
	$score_label.bbcode_enabled = true
	$score_label.text = "GAME OVER\n\nYou managed to sleep in for [color=red]" + str(score) + "[/color] seconds"
	$sfx_pipe.play()


func _on_exit_pressed() -> void:
	get_tree().quit()


func _on_retry_pressed() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_menu_pressed() -> void:
	get_tree().change_scene_to_file("res://title_screen.tscn")
