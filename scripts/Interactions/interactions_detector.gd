extends Area3D

class_name InteractionsDetector

@export var actionName: String = "INTERACT"

var interact: Callable = func():
	pass

func _on_body_entered(_body: Node3D) -> void:
	InteractionsManager.registerArea(self)


func _on_body_exited(_body: Node3D) -> void:
	InteractionsManager.unregisterArea(self)
