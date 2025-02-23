extends Node2D
@onready var sfx_click: AudioStreamPlayer2D = $sfx_click

func _ready() -> void:
	var cursor_texture = load("res://Assets/Cursor.png")
	var hotspot = Vector2(16, 16) 
	Input.set_custom_mouse_cursor(cursor_texture, Input.CURSOR_ARROW, hotspot)


func _on_button_pressed() -> void:
	sfx_click.play()
	$Timer.start(0.75)


func _on_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://main.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()
