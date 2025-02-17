extends Node3D

@onready var interactionDetector:= $InteractionsDetector

@export var spawnableObjects: Array[PackedScene] = []
@export var positionObjects: Array[Vector2] = []
@export var interactionToDisplay: String = "default"

const sound_emitter = preload("res://scenes/sound_emitter.tscn")
@onready var world: Node3D = $".."

func _ready() -> void:
	interactionDetector.interact = Callable(self, "_action_on_interact")
	if !interactionToDisplay.is_empty():
		interactionDetector.actionName = interactionToDisplay

func _action_on_interact() -> void:
	var sound_prop = sound_emitter.instantiate()
	sound_prop.setStrengh(5)
	sound_prop.position = position
	world.add_child(sound_prop)
