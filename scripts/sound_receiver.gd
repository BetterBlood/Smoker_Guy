extends Node3D

signal sound_detected(other_position: Vector3)

func _on_detector_area_entered(area: Area3D) -> void:
	#print("sound detected at: ", global_position, ", from: ", area.global_position)
	sound_detected.emit(area.global_position) # TODO : handle signal in parent
