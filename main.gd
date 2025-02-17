extends Node2D

var minigame_on : bool = false
var countdown_time : float = 10.0  # Countdown time in seconds
var time_remaining : float = countdown_time
var minigame_time : float = 5


func _ready():
	$Time_Display/Time_Label.text = (format_time(time_remaining))
	
func _process(delta):
	if time_remaining > 0:
		time_remaining -= delta
		minigame_time -= delta
		if minigame_time < 0 and minigame_on == false:
			minigame_on = true
			_minigame()
			
		elif minigame_on == false:
			$Time_Display/Time_Label.text = (format_time(time_remaining))
			
		elif minigame_on == true:
			minigame_time = 5
			
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
	
##Minigame Engine
######################################
var minigame_type = null
var minigame = [Callable(self, "_no_game"),Callable(self, "_math_game")]

func _minigame():
	if minigame_type == null:
		minigame_type = randi_range(0,1)
		print(minigame_type)
		minigame[minigame_type].call()
		
func _mini_reset():
	minigame_time = 5
	minigame_on = false
	minigame_type = null
		
func _no_game():
	print("no game!")
	_mini_reset()

##Math game
######
var math_result
var math_guess

func _math_game():
	print("math game!")
	var math_number1 = randi_range(-99, 99)
	var math_number2 = randi_range(-99, 99)
	
	_mini_reset()
