extends Node3D

@onready var radar: Area3D = $Emitter

var strength: int

func setStrengh(stren:= 50) -> void:
	strength = stren

func _process(delta: float) -> void:
	if radar.scale.x < strength:
		radar.scale *= 1.2
	else:
		queue_free()
