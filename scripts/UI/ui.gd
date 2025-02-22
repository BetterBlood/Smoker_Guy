extends Control

@export var chocolate_collected:= 0

## [i][color=orange][b]Warning:[/b] ignored if set by the world 
@export var chocolate_needed_to_win:= 1

func update_chocolate_collected(value:int) -> void:
	chocolate_collected = value
	_update_chocolate_displayed()

func set_max_chocolate(value:int) -> void:
	chocolate_needed_to_win = value
	_update_chocolate_displayed()

func _update_chocolate_displayed() -> void:
	%collected.text = str(chocolate_collected)
	var remaining_choco = str(chocolate_needed_to_win - chocolate_collected)
	%remaining.text = remaining_choco
