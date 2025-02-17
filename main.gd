extends Node2D

var minigame_on : bool = false
var countdown_time : float = 10.0  # Countdown time in seconds
var time_remaining : float = countdown_time
var minigame_time : float = 5
var minigame_type : int

func _ready():
	$Time_Display/Time_Label.text = (format_time(time_remaining))
	
func _process(delta):
	if time_remaining > 0:
		time_remaining -= delta
		minigame_time -= delta
		if minigame_time < 0 and minigame_on == false:
			_minigame()
			
		elif minigame_on == false:
			$Time_Display/Time_Label.text = (format_time(time_remaining))
			
		elif minigame_on == true:
			minigame_on = 600
			
	else:
		$Time_Display/Time_Label.text = ("00:00:00")  # Timer finished
		
# converts time into clock format
func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var seconds_left = int(seconds) % 60
	var milliseconds = int((seconds - int(seconds)) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds_left, milliseconds]

# SNOOZE Button: adds 1 second to the main timer
func _on_button_pressed() -> void:
	time_remaining += 1
	
func _minigame():
	minigame_on = true
	minigame_type = randi_range(0,1)
	#insert minigameloader here
	
