extends Node3D

@onready var marker_3d: Marker3D = $Marker3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_sound_receiver_sound_detected(other_position: Vector3) -> void:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(marker_3d.global_position, other_position)
	var result = space_state.intersect_ray(query)
	#print(result)
	print("sound detected at: ", marker_3d.global_position, ", from: ", other_position)
	if not result.is_empty() && result["collider"] is StaticBody3D:
		print("obstructed -> ignored")
