extends Node3D

@onready var interactionDetector:= $InteractionsDetector

@export var interactionToDisplay: String = "to take heal"
@export var player: Player
@export var healing_value:= 10

var amplitude = 0.5
var frequency = 1.0
var time = randf()*4
@onready var default_pos = $".".position


func _ready() -> void:
	interactionDetector.interact = Callable(self, "_action_on_interact")
	if !interactionToDisplay.is_empty():
		interactionDetector.actionName = interactionToDisplay

func _process(delta: float) -> void:
	time += delta * frequency
	
	$".".set_position(default_pos + Vector3(0, sin(time) * amplitude, 0))

func _action_on_interact() -> void:
	if player != null:
		player.call_heal(healing_value)
		queue_free()
