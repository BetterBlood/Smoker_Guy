extends Area3D

class_name InteractionsDetector

@export var actionName: String = "INTERACT"

var interact: Callable = func():
	pass

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionsManager.registerArea(self)


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("Player"):
		InteractionsManager.unregisterArea(self)
