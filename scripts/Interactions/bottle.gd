extends RigidBody3D

@onready var interactions_detector: InteractionsDetector = $InteractionsDetector

@export var interactionToDisplay: String = "to push the bottle"
@export var player: Player
@export var impulse_strength:= 10
@export var sound_strength:= 50
var is_thown:= false

var world:Node3D = null
const sound_emitter = preload("res://scenes/sound_emitter.tscn")
const OUTLINE = preload("res://mat/outline.tres")
func _ready() -> void:
	interactions_detector.interact = Callable(self, "_action_on_interact")
	interactions_detector.out_line = Callable(self, "_out_line")
	interactions_detector.rem_out_line = Callable(self, "_rem_out_line")
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
		$PushingBottle.play()


func _out_line() -> void:
	$MeshInstance3D.material_overlay = OUTLINE
	$MeshInstance3D4.material_overlay = OUTLINE
	$MeshInstance3D2.material_overlay = OUTLINE
	$MeshInstance3D3.material_overlay = OUTLINE

func _rem_out_line() -> void:
	$MeshInstance3D.material_overlay = null
	$MeshInstance3D4.material_overlay = null
	$MeshInstance3D2.material_overlay = null
	$MeshInstance3D3.material_overlay = null

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
		
	if body is StaticBody3D or body is CSGBox3D or body.is_in_group("Floor"):
		$BottleBoing.play()
		var sound_prop = sound_emitter.instantiate()
		sound_prop.setStrengh(sound_strength)
		sound_prop.position = position
		world.add_child(sound_prop)
		
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		enemy.has_been_hit_by_player()
		queue_free()
