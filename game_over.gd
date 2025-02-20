extends Node2D
var score: int
func _ready():
	score = global.total_time
	$score_label.bbcode_enabled = true
	$score_label.text = "GAME OVER\n\nYou managed to sleep in for [color=red]" + str(score) + "[/color] seconds"
	$sfx_pipe.play()
