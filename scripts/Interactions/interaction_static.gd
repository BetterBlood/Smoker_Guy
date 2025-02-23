extends Node3D

@onready var interactionDetector:= $InteractionsDetector
const OUTLINE = preload("res://mat/outline.tres")

@export var interactionToDisplay: String = "default"
@export var strength: int = 5
@export var soundSource:Marker3D = null

const sound_emitter = preload("res://scenes/sound_emitter.tscn")
@export var world:Node3D = null

func _ready() -> void:
	interactionDetector.interact = Callable(self, "_action_on_interact")
	interactionDetector.out_line = Callable(self, "_out_line")
	interactionDetector.rem_out_line = Callable(self, "_rem_out_line")
	if !interactionToDisplay.is_empty():
		interactionDetector.actionName = interactionToDisplay
	
	if soundSource == null:
		soundSource.position = position

func _action_on_interact() -> void:
	var sound_prop = sound_emitter.instantiate()
	sound_prop.setStrengh(strength)
	sound_prop.position = soundSource.position
	world.add_child(sound_prop)

func _out_line() -> void:
	$MeshInstance3D.material_overlay = OUTLINE

func _rem_out_line() -> void:
	$MeshInstance3D.material_overlay = null
