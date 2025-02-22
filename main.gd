extends Node2D

var minigame_on : bool = false #Is Minigame running?
var countdown_time : float = 10.0  # Countdown time in seconds
var time_remaining : float = countdown_time
var minigame_time : float = 5 #Time until next Minigame
var mini_timer : float = 0 #Time to finish minigame
var minigame_type = null
var lives: int = 5
var game_over : bool = false
@onready var sfx_wrong: AudioStreamPlayer2D = $Audio/sfx_wrong
@onready var sfx_correct: AudioStreamPlayer2D = $Audio/sfx_correct
@onready var sfx_click: AudioStreamPlayer2D = $Audio/sfx_click
@onready var sfx_beep_blue: AudioStreamPlayer2D = $Simon_Game/sfx_beep_blue
@onready var sfx_beep_green: AudioStreamPlayer2D = $Simon_Game/sfx_beep_green
@onready var sfx_beep_red: AudioStreamPlayer2D = $Simon_Game/sfx_beep_red
@onready var sfx_beep_yellow: AudioStreamPlayer2D = $Simon_Game/sfx_beep_yellow


func _ready():
	$Time_Display/Time_Label.text = (format_time(time_remaining))
	
func _process(delta):
	if game_over == false:
		if time_remaining > 0 and lives > 0:
			time_remaining -= delta
			minigame_time -= delta
			global.total_time += delta
			if mini_timer > 0:
				if simon_freeze == false:
					mini_timer = max(0, mini_timer - delta )
				if minigame_type == 1:
					$Mini_Display/Mini_Label.text = format_seconds(mini_timer)
					$Time_Display/Small_Time_Label.text = (format_time(time_remaining))
					_math_game()
				elif minigame_type == 0:
					$Mini_Display/Mini_Label.text = format_seconds(mini_timer)
					$Time_Display/Small_Time_Label.text = (format_time(time_remaining))
					if simon_wait == true:
						_simon_guess()
			elif minigame_time < 0 and minigame_on == false:
				minigame_on = true
				_minigame()
				
			elif minigame_on == false:
				$Time_Display/Time_Label.text = (format_time(time_remaining))
				if minigame_time < 2 and minigame_time > 1:
					$Pin_Display/Pin_Label.text = "READY"
				
			elif minigame_on == true:
				minigame_time = 5
				
		else:
			game_over = true
			_game_over()
	
func _game_over():
	$Time_Display/Time_Label.text = "00:00:00"
	_diodes_light()
	$End_timer.start(1)
# converts time into clock format
func format_time(seconds: float) -> String:
	@warning_ignore("integer_division")
	var minutes = int(seconds) / 60
	var seconds_left = int(seconds) % 60
	var milliseconds = int((seconds - int(seconds)) * 100)
	return "%02d:%02d:%02d" % [minutes, seconds_left, milliseconds]
	
func format_seconds(seconds: float) -> String:
	return str(int(seconds))  # Convert to integer and then to string

# SNOOZE Button: adds 0.5 second to the main timer
func _on_button_pressed() -> void:
	sfx_click.play()
	if time_remaining > 0:
		time_remaining += 0.25
	
##Minigame Engine
######################################
var minigame = [Callable(self, "_simon_game"),Callable(self, "_math_game")]
var mini_win : bool = true

func _minigame():
	if minigame_type == null:
		minigame_type = randi_range(0,1) #increase range for more minigame types
		print(minigame_type)
		mini_timer = 10
		_diodes()
		minigame[minigame_type].call()
		
func _mini_reset():
	if mini_win == true: #WIN GAME
		$Pin_Display/Pin_Label.text = "CORRECT"
		sfx_correct.play()
	else: #LOSE GAME
		time_remaining = time_remaining / 2
		lives -= 1
		$Life_Label.text = str(lives)
		$Pin_Display/Pin_Label.text = "LOSER"
		sfx_wrong.play()
		
	minigame_time = 5
	minigame_on = false
	minigame_type = null
	mini_win = true
	mini_timer = 0
	_diodes()
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
				@warning_ignore("integer_division")
				math_result = math_number1 / math_number2
				$Time_Display/Time_Label.text = (str(math_number1) + " / " + str(math_number2))
		math_number1 = null
		math_number2 = null
		$Pin_Display/Pin_Label.text = "SOLVE"
	if math_guess == str(math_result):
		mini_win = true # WINNING
		print(str(math_result))
		print(math_guess)
		time_remaining += math_guess.length()
		math_guess = ""
		math_result = -100
		_mini_reset()
	elif mini_timer == 0 or math_guess.length() >= 5 or math_guess.length() > (str(math_result)).length():
		mini_win = false # LOSING
		print(math_guess)
		print(str(math_result))
		math_guess = ""
		math_result = -100
		_mini_reset()
		
## PINPAD BUTTONS
func _on_button_0_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "0"
		$Pin_Display/Pin_Label.text = math_guess


func _on_button_1_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "1"
		$Pin_Display/Pin_Label.text = math_guess

func _on_button_2_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "2"
		$Pin_Display/Pin_Label.text = math_guess

func _on_button_3_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "3"
		$Pin_Display/Pin_Label.text = math_guess
		
func _on_button_4_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "4"
		$Pin_Display/Pin_Label.text = math_guess
		
func _on_button_5_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "5"
		$Pin_Display/Pin_Label.text = math_guess
		
func _on_button_6_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "6"
		$Pin_Display/Pin_Label.text = math_guess
		
func _on_button_7_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "7"
		$Pin_Display/Pin_Label.text = math_guess
		
func _on_button_8_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "8"
		$Pin_Display/Pin_Label.text = math_guess
		
func _on_button_9_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "9"
		$Pin_Display/Pin_Label.text = math_guess
		
func _on_button_minus_pressed() -> void:
	sfx_click.play()
	if minigame_type == 1:
		math_guess = math_guess + "-"
		$Pin_Display/Pin_Label.text = math_guess

## SIMON SAYS GAME
########################################################
var simon_game_on: bool = false
var simon_color: int 
var simon_order: String # Combined String of generated colors
var simon_pause: bool = false
var simon_wait: bool #Stop picking colors, wait for input
var simon_guess: String #User-Entered String to compare against simon_order
var simon_continue: bool = true#Select a color after this one? Disabled by picking 5th rand option
var simon_freeze: bool = false

func _simon_game():
	simon_wait = false
	simon_freeze = true
	$Pin_Display/Pin_Label.text = "SIMON"
	_simon_generator()
	
func _simon_generator():
	if simon_order == "":
		simon_color = randi_range(0, 3)
	else:
		simon_color = randi_range(0, 4)
	if simon_pause == false:
		match simon_color:
			0: #Blue
				simon_order += "0"
				$Simon_Game/SimonBlue/SimonBlueLight.z_index = 2
				$Time_Display/Time_Label.text = "BLUE"
				sfx_beep_blue.play()
			1: #Greens
				simon_order += "1"
				$Simon_Game/SimonGreen/SimonGreenLight.z_index = 2
				$Time_Display/Time_Label.text = "GREEN"
				sfx_beep_green.play()
				
			2: #Red
				simon_order += "2"
				$Simon_Game/SimonRed/SimonRedLight.z_index = 2
				$Time_Display/Time_Label.text = "RED"
				sfx_beep_red.play()
			3: #Yellow
				simon_order += "3"
				$Simon_Game/SimonYellow/SimonYellowLight.z_index = 2
				$Time_Display/Time_Label.text = "YELLOW"
				sfx_beep_yellow.play()
			4: #TERMINATE
				simon_continue = false
				$Time_Display/Time_Label.text = "ENTER"
		simon_pause = true
		$Simon_Game/Simon_Timer2.start(0.5)

func _on_simon_timer_2_timeout() -> void:
	_simon_color_reset()
	$Simon_Game/Simon_Timer.start(0.5)
	
func _on_simon_timer_timeout() -> void:
	simon_pause = false
	if simon_continue == true:
		_simon_generator()
	else:
		mini_timer = 10
		simon_wait = true
		simon_freeze = false
func _simon_color_reset():
	$Simon_Game/SimonBlue/SimonBlueLight.z_index = -1
	$Simon_Game/SimonGreen/SimonGreenLight.z_index = -1
	$Simon_Game/SimonRed/SimonRedLight.z_index = -1
	$Simon_Game/SimonYellow/SimonYellowLight.z_index = -1	
	$Time_Display/Time_Label.text = ""
	
func _simon_guess(): #Check if entered combination matches
	if simon_guess == simon_order:
		mini_win = true
		time_remaining += simon_order.length()
		_simon_reset()
	elif mini_timer == 0 or simon_guess.length() > simon_order.length():
		mini_win = false
		_simon_reset()
		
func _simon_reset():
	_simon_color_reset()
	simon_game_on = false
	simon_order = ""# Combined String of generated colors
	simon_pause = false
	simon_wait = false#Stop picking colors, wait for input
	simon_guess = "" #User-Entered String to compare against simon_order
	simon_continue = true#Select a color after this one? Disabled by picking 5th rand option
	_mini_reset()

func _on_ss_button_b_pressed() -> void:
	if simon_wait == true:
		simon_guess += "0"
		_simon_color_reset()
		$Simon_Game/SimonBlue/SimonBlueLight.z_index = 2
		sfx_beep_blue.play()
		
func _on_ss_button_g_pressed() -> void:
	if simon_wait == true:
		simon_guess += "1"
		_simon_color_reset()
		$Simon_Game/SimonGreen/SimonGreenLight.z_index = 2
		sfx_beep_green.play()
		
func _on_ss_button_r_pressed() -> void:
	if simon_wait == true:
		simon_guess += "2"
		_simon_color_reset()
		$Simon_Game/SimonRed/SimonRedLight.z_index = 2
		sfx_beep_green.play()
		
func _on_ss_button_y_pressed() -> void:
	if simon_wait == true:
		simon_guess += "3"
		_simon_color_reset()
		$Simon_Game/SimonYellow/SimonYellowLight.z_index = 2
		sfx_beep_yellow.play()
		
func _diodes_light():
	$Diodes/DiodeOff/DiodeOn.z_index = 5
	$Diodes/DiodeOff2/DiodeOn.z_index = 5
	$Diodes/DiodeOff3/DiodeOn.z_index = 5
	$Diodes/DiodeOff4/DiodeOn.z_index = 5
	
func _diodes():
	_diodes_light()
	$Diodes/Diode_Timer.start(0.5)

func _on_diode_timer_timeout() -> void:
	$Diodes/DiodeOff/DiodeOn.z_index = -99
	$Diodes/DiodeOff2/DiodeOn.z_index = -99
	$Diodes/DiodeOff3/DiodeOn.z_index = -99
	$Diodes/DiodeOff4/DiodeOn.z_index = -99


func _on_end_timer_timeout() -> void:
	get_tree().change_scene_to_file("res://game_over.tscn")
