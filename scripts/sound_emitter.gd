extends Node3D

@onready var radar: Area3D = $Emitter

var strength: int
var propagation:= Vector3(0.5, 0.5, 0.5)
var propagation_speed:= 10

func setStrengh(stren:= 50) -> void:
	strength = stren

func _process(delta: float) -> void:
	if radar.scale.x < strength:
		radar.scale += propagation * propagation_speed
	else:
		queue_free()
