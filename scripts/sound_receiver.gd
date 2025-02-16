extends Node3D

signal sound_detected

func _on_detector_area_entered(area: Area3D) -> void:
	print("sound detected at: ", position, ", from: ", area.global_position)
	sound_detected.emit(area.global_position) # TODO : handle signal in parent
