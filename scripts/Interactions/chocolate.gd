extends Node3D

@onready var interactionDetector:= $InteractionsDetector
const OUTLINE = preload("res://mat/outline.tres")

@export var interactionToDisplay: String = "collect"
@export var player: Player

var amplitude = 0.5
var frequency = 1.0
var time = randf()*4
@onready var default_pos = $".".position
var rotation_tween = null


func _ready() -> void:
	interactionDetector.interact = Callable(self, "_action_on_interact")
	interactionDetector.out_line = Callable(self, "_out_line")
	interactionDetector.rem_out_line = Callable(self, "_rem_out_line")
	if !interactionToDisplay.is_empty():
		interactionDetector.actionName = interactionToDisplay
	
	rotation_tween = get_tree().create_tween().set_loops()
	rotation_tween.tween_property(self, "rotation", Vector3(0, 2*PI, 0), 5).from(Vector3(0, 0, 0))

func _action_on_interact() -> void:
	if player != null:
		rotation_tween.kill()
		player.collect_chocolate()
		queue_free()


func _out_line() -> void:
	$chocolate.material_overlay = OUTLINE

func _rem_out_line() -> void:
	$chocolate.material_overlay = null
