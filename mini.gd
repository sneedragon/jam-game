extends Control

@onready var main = get_node("/root/Main")
var time_since_mini : float = 0
var minigame_on : bool = false
var game_type

func _physics_process(delta: float) -> void:
	if time_since_mini < 300.0 and minigame_on == false:
		time_since_mini += 1 - delta
	elif minigame_on == false:
		minigame_on = true
		print ("minigame time")
		game_type = randi_range(0, 1)
