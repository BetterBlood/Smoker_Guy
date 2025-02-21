extends Node3D

@onready var radar: Area3D = $Emitter

var strength: float
var propagation:= Vector3(0.5, 0.5, 0.5)
var propagation_speed:= 250.

func setStrengh(stren:= 50) -> void:
	strength = stren
	
func _ready() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(radar, "scale", Vector3(strength, strength, strength), strength/propagation_speed)
	tween.tween_callback(queue_free)
