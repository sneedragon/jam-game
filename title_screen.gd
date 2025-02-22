extends Node2D
@onready var sfx_click: AudioStreamPlayer2D = $sfx_click



func _on_button_pressed() -> void:
	sfx_click.play()
	$Timer.start(1)



func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://main.tscn")
