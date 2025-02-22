extends Node3D
@onready var options: OptionsMenu = $Options
@export var chocolate_number_to_win:= 1

func _ready() -> void:
	options.hide()
	options.is_open = false
	$UI.set_max_chocolate(chocolate_number_to_win)


func _on_player_chocolate_colected_signal(number: int) -> void:
	if number >= chocolate_number_to_win:
		print("TODO : WIIIIIIIIN -> victory scene ?, return to main menu ?")
	else:
		$UI.update_chocolate_collected(number)
		print("TODO : update number of guards or speed ? TODO GUI : choc/tot: ", number, "/", chocolate_number_to_win)
