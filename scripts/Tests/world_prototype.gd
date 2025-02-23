extends Node3D
@onready var options: OptionsMenu = $Options
var chocolate_number_to_win:= 1

func _ready() -> void:
	options.hide()
	options.is_open = false
	chocolate_number_to_win = $WiningCondition.get_children().size()
	$UI.set_max_chocolate(chocolate_number_to_win)


func _on_player_chocolate_colected_signal(number: int) -> void:
	if number >= chocolate_number_to_win:
		$Transitions.begin_transition(0)
	else:
		$UI.update_chocolate_collected(number)
		print("TODO : update number of guards or speed ? chocolate: ", number, "/", chocolate_number_to_win)


func _on_transitions_transitionned(value: int) -> void:
	if value == 0: # WIN !
		$YouWin.show()
		print("YOU WIN")
	elif value == 1: #Loose
		$GameOver.show()
		print("GAME OVER")
	elif value == 2: # return to main menu
		$YouWin.hide()
		$GameOver.hide()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		


func _player_catched() -> void:
	$Transitions.begin_transition(1)


func _on_transitions_transition_finished(value: int) -> void:
	if value == 0 or value == 1:
		for child in $WiningCondition.get_children():
			child.rotation_tween.kill()
		$Transitions.begin_transition(2)
	elif value == 2:
		pass
