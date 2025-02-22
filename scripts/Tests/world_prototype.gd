extends Node3D
@onready var options: OptionsMenu = $Options
@export var chocolate_number_to_win:= 1

func _ready() -> void:
	options.hide()
	options.is_open = false
	$UI.set_max_chocolate(chocolate_number_to_win)


func _on_player_chocolate_colected_signal(number: int) -> void:
	if number >= chocolate_number_to_win:
		$Transitions.begin_transition(0)
		print("TODO : WIIIIIIIIN -> victory scene ?, return to main menu ?")
	else:
		$UI.update_chocolate_collected(number)
		print("TODO : update number of guards or speed ? TODO GUI : choc/tot: ", number, "/", chocolate_number_to_win)


func _on_transitions_transitionned(value: int) -> void:
	if value == 0: # WIN !
		print("YOU WIN")
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	elif value == 1: #Loose
		print("GAME OVER")
		get_tree().paused = false
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


func _player_catched() -> void:
	$Transitions.begin_transition(1)
