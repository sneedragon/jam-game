extends Node2D

var minigame_on : bool = false
var countdown_time : float = 10.0  # Countdown time in seconds
var time_remaining : float = countdown_time

func _ready():
	$Time_Display/Time_Label.text = (format_time(time_remaining))
func _process(delta):
	if time_remaining > 0:
		time_remaining -= delta
		if minigame_on == false:
			$Time_Display/Time_Label.text = (format_time(time_remaining))
	else:
		$Time_Display/Time_Label.text = ("00:00:00")  # Timer finished
	
func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var seconds_left = int(seconds) % 60
	var milliseconds = int((seconds - int(seconds)) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds_left, milliseconds]


func _on_button_pressed() -> void:
	time_remaining += 1
