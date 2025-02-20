extends Node2D

var minigame_on : bool = false #Is Minigame running?
var countdown_time : float = 10.0  # Countdown time in seconds
var time_remaining : float = countdown_time
var minigame_time : float = 5 #Time until next Minigame
var mini_timer : float = 0 #Time to finish minigame
var minigame_type = null
var lives: int = 5

func _ready():
	$Time_Display/Time_Label.text = (format_time(time_remaining))
	
func _process(delta):
	if time_remaining > 0:
		time_remaining -= delta
		minigame_time -= delta
		if mini_timer > 0 and minigame_type == 1:
			mini_timer = max(0, mini_timer - delta )
			$Mini_Display/Mini_Label.text = format_seconds(mini_timer)
			$Time_Display/Small_Time_Label.text = (format_time(time_remaining))
			_math_game()
		elif minigame_time < 0 and minigame_on == false:
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
	
func format_seconds(seconds: float) -> String:
	return str(int(seconds))  # Convert to integer and then to string

# SNOOZE Button: adds 1 second to the main timer
func _on_button_pressed() -> void:
	time_remaining += 1
	
##Minigame Engine
######################################
var minigame = [Callable(self, "_no_game"),Callable(self, "_math_game")]
var mini_win : bool = true

func _minigame():
	if minigame_type == null:
		minigame_type = randi_range(1,1) #increase range for more minigame types
		print(minigame_type)
		mini_timer = 10
		minigame[minigame_type].call()
		
func _mini_reset():
	if mini_win == true:
		pass
		#TODO win action
	else:
		time_remaining = time_remaining / 2
		lives =- 1
		#TODO lose action
	minigame_time = 10
	minigame_on = false
	minigame_type = null
	mini_win = true
	mini_timer = 0
	$Time_Display/Time_Label.text = ""
	$Time_Display/Small_Time_Label.text = ""
	$Mini_Display/Mini_Label.text = ""
		
func _no_game():
	print("no game!")
	_mini_reset()

##Math game
######
var math_result : int = -100
var math_string : String
var math_guess: String
var operation : int

func _math_game():
	if math_result == -100:
		var math_number1 = randi_range(1, 99)
		var math_number2 = randi_range(1, 99)
		operation = randi_range(0, 3) #0 +, 1-, 2*, 3/
		match operation:
			0:
				math_result = math_number1 + math_number2
				$Time_Display/Time_Label.text = (str(math_number1) + " + " + str(math_number2))
			1:
				math_result = math_number1 - math_number2
				$Time_Display/Time_Label.text = (str(math_number1) + " - " + str(math_number2))
			2:
				math_result = math_number1 * math_number2
				$Time_Display/Time_Label.text = (str(math_number1) + " x " + str(math_number2))
			3:
				while math_number1 % math_number2 != 0:
					math_number1 = randi_range(1, 99)
					math_number2 = randi_range(1, 99)
				math_result = math_number1 / math_number2
				$Time_Display/Time_Label.text = (str(math_number1) + " / " + str(math_number2))
		math_number1 = null
		math_number2 = null
	if math_guess == str(math_result):
		mini_win = true
		print(str(math_result))
		print(math_guess)
		math_guess = ""
		math_result = -100
		_mini_reset()
	elif mini_timer == 0:
		mini_win = false
		print(math_guess)
		print(str(math_result))
		math_guess = ""
		math_result = -100
		_mini_reset()
		
## PINPAD BUTTONS
func _on_button_0_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "0"


func _on_button_1_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "1"


func _on_button_2_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "2"


func _on_button_3_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "3"


func _on_button_4_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "4"


func _on_button_5_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "5"


func _on_button_6_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "6"


func _on_button_7_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "7"


func _on_button_8_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "8"


func _on_button_9_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "9"

func _on_button_minus_pressed() -> void:
	if minigame_type == 1:
		math_guess = math_guess + "-"
