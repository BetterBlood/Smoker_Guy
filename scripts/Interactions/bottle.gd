extends RigidBody3D

@onready var interactions_detector: InteractionsDetector = $InteractionsDetector

@export var interactionToDisplay: String = "to push the bottle"
@export var player: Player
@export var impulse_strength:= 10
@export var sound_strength:= 50
var is_thown:= false

var world:Node3D = null
const sound_emitter = preload("res://scenes/sound_emitter.tscn")

func _ready() -> void:
	interactions_detector.interact = Callable(self, "_action_on_interact")
	if !interactionToDisplay.is_empty():
		interactions_detector.actionName = interactionToDisplay


func _action_on_interact() -> void:
	if player != null:
		var dir_x = global_position.x - player.global_position.x
		var dir_z = global_position.z - player.global_position.z
		var direction = Vector3(dir_x, 0, dir_z)
		direction.normalized()
		apply_impulse(direction * impulse_strength)
		is_thown = true
		$DeleteTime.start()
		world = player.world


func _on_delete_time_timeout() -> void:
	queue_free()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not is_thown:
		return
	
	if world == null:
		world = $".."
		if world == null:
			push_error( "No world found in bottle: ", get_rid())
			return
		
	if body in [StaticBody3D, CSGBox3D] or body.is_in_group("Floor"):
		var sound_prop = sound_emitter.instantiate()
		sound_prop.setStrengh(sound_strength)
		sound_prop.position = position
		world.add_child(sound_prop)
		queue_free()
		
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		enemy.has_been_hit_by_player()
		queue_free()
