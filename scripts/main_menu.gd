class_name MainMenu extends Control


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")


func _on_options_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/options.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
