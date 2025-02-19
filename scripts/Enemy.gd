class_name Enemy extends CharacterBody3D
#@export var point_a: Vector3
#@export var point_b: Vector3
@export var normal_speed := 2.0
@export var chase_speed := 4
var speed := normal_speed
@export var player: RigidBody3D
var player_id: int
var chase_player:= false
var alerted := false
var target: Vector3
@onready var patrol_points := $PatrolPoints.get_children()
#@onready var point_a := Vector3($PatrolPoints/A.position.x, position.y, $PatrolPoints/A.position.z)
#@onready var point_b := Vector3($PatrolPoints/B.position.x, position.y, $PatrolPoints/B.position.z)
var current_patrol_index := 0

@onready var ear: Marker3D = $Ear
@onready var detect_player_1: AudioStreamPlayer3D = $Audios/DetectPlayer/DetectPlayer1
@onready var catch_player_1: AudioStreamPlayer3D = $Audios/CatchPlayer/CatchPlayer1
@onready var reach_patrol_point: AudioStreamPlayer3D = $Audios/ReachPatrolPoint/ReachPatrolPoint


func _ready():
	if patrol_points.size() > 0:
		# Initialize target to the first patrol point, maintaining the enemy's current y position
		target = get_patrol_point_position(current_patrol_index)
	else:
		push_error("No patrol points found in $PatrolPoints")
	
	player_id = player.get_instance_id()

func get_patrol_point_position(index: int) -> Vector3:
	var patrol_point = patrol_points[index]
	return Vector3(patrol_point.position.x, position.y, patrol_point.position.z)

func update_patrol_target():
	reach_patrol_point.play()
	current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
	target = get_patrol_point_position(current_patrol_index)

func _physics_process(delta):
	# Calculate the direction vector from the enemy to the target
	var direction = (target - position).normalized()
	#$Body.look_at(player.global_transform.origin, Vector3.UP)
	if not is_on_floor():
		direction += get_gravity()
	
	position += direction * speed * delta
	if (!alerted):
		look_at(target, Vector3.UP)
		alerted = can_see_player()
		# Check if we've reached (or are close enough to) the target
		if position.distance_to(target) < 1.0:
			update_patrol_target()
	else:
		#target = Vector3(player.position.x, position.y, player.position.z)
		if chase_player:
			target = player.position
		look_at(target, Vector3.UP)
		
		if position.distance_to(target) < 1.0:
			alerted = can_see_player()
			if alerted:
				print("TODO catch the player if close to him (GAME OVER)")
				update_patrol_target()
				speed = normal_speed
			else:
				update_patrol_target()
				speed = normal_speed
		
	
	move_and_slide()

func can_see_player() -> bool:
	for child in $Rays.get_children():
		if child.is_colliding():
			var collider = child.get_collider()
			 # Check by comparing against the player’s group or name
			if collider and collider.is_in_group("Player"):
				set_alerted()
				return true
	return false

func set_alerted():
	detect_player_1.play()
	speed = chase_speed
	#$VisionCone.queue_free()
	#var mat = StandardMaterial3D.new()
	#mat.albedo_color = Color.RED
	#$Body.set_surface_override_material(0, mat)


func _on_sound_receiver_sound_detected(other_position: Vector3) -> void:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ear.global_position, other_position)
	var result = space_state.intersect_ray(query)
	#print(result)
	#print("sound detected at: ", ear.global_position, ", from: ", other_position)
	if not result.is_empty() and result["collider"] is StaticBody3D:
		#print(result)
		print("obstructed -> ignored") # TODO: verify all obstruction mat are working
	else:
		if !alerted:
			alerted = true
			set_alerted()
			if not result.is_empty() and result["collider_id"] == player_id:
				target = player.position
				chase_player = true
			else:
				target = other_position
