class_name Enemy extends CharacterBody3D

@export var normal_speed := 2.0
@export var chase_speed := 4
var speed := normal_speed
@export var player: RigidBody3D
var player_id: int
var chase_player:= false
var alerted := false
var target: Vector3
var game_ended:= false
@onready var patrol_points := $PatrolPoints.get_children()
var current_patrol_index := 0

@onready var ear: Marker3D = $Ear
@onready var detect_player_1: AudioStreamPlayer3D = $Audios/DetectPlayer/DetectPlayer1
@onready var catch_player_1: AudioStreamPlayer3D = $Audios/CatchPlayer/CatchPlayer1
@onready var reach_patrol_point: AudioStreamPlayer3D = $Audios/ReachPatrolPoint/ReachPatrolPoint

signal player_catched

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
	var direction_3d = target - position
	var direction = Vector3(direction_3d.x, 0, direction_3d.z).normalized()
	#$Body.look_at(player.global_transform.origin, Vector3.UP)
	if not is_grounded():
		direction += get_gravity()
	
	position += direction * speed * delta
	if (!alerted):
		#look_at(target, Vector3.UP)
		alerted = can_see_player()
		# Check if we've reached (or are close enough to) the target
		if position.distance_to(target) < 1.0:
			update_patrol_target()
	else:
		if chase_player:
			#target = player.position
			target = Vector3(player.position.x, position.y, player.position.z)
		#look_at(target, Vector3.UP)
		
		if position.distance_to(target) < 1.0:
			alerted = can_see_player()
			if alerted and not game_ended:
				game_ended = true
				player_catched.emit()
			
			update_patrol_target()
			speed = normal_speed
		
	look_at(target, Vector3.UP)
	move_and_slide()

func can_see_player() -> bool:
	for child in $Rays.get_children():
		if child.is_colliding():
			var collider = child.get_collider()
			 # Check by comparing against the player’s group or name
			if collider and collider.is_in_group("Player"):
				set_alerted()
				#chase_player = true
				start_chase_player()
				return true
	return false

func set_alerted():
	detect_player_1.play()
	speed = chase_speed

func _on_sound_receiver_sound_detected(other_position: Vector3) -> void:
	var space_state = get_world_3d().direct_space_state
	var query = PhysicsRayQueryParameters3D.create(ear.global_position, other_position)
	var result = space_state.intersect_ray(query)
	#print(result)
	#print("sound detected at: ", ear.global_position, ", from: ", other_position)
	if not result.is_empty() and result["collider"] in [StaticBody3D, CSGBox3D]:
		#print(result)
		print("obstructed -> ignored") # TODO: verify all obstruction mat are working
	else:
		if !alerted:
			alerted = true
			set_alerted()
			if not result.is_empty() and result["collider_id"] == player_id:
				#target = player.position
				target = Vector3(player.position.x, position.y, player.position.z)
				#chase_player = true
				start_chase_player()
			else:
				target = other_position

func is_grounded() -> bool:
	return $GroundDetector.is_colliding()

func has_been_hit_by_player():
	alerted = true
	set_alerted()
	#target = player.position
	target = Vector3(player.position.x, position.y, player.position.z)
	#chase_player = true
	start_chase_player()

func start_chase_player():
	chase_player = true
	$VisionCone.hide()
	await get_tree().create_timer(3.0).timeout
	chase_player = false
	$VisionCone.show()
