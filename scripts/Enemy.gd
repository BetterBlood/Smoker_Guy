class_name Enemy extends CharacterBody3D
#@export var point_a: Vector3
#@export var point_b: Vector3
@export var speed := 2.0
@export var player: RigidBody3D
var alerted := false
var target: Vector3
@onready var patrol_points := $PatrolPoints.get_children()
#@onready var point_a := Vector3($PatrolPoints/A.position.x, position.y, $PatrolPoints/A.position.z)
#@onready var point_b := Vector3($PatrolPoints/B.position.x, position.y, $PatrolPoints/B.position.z)
var current_patrol_index := 0

	
func _ready():
	if patrol_points.size() > 0:
		# Initialize target to the first patrol point, maintaining the enemy's current y position
		target = get_patrol_point_position(current_patrol_index)
	else:
		push_error("No patrol points found in $PatrolPoints")

func get_patrol_point_position(index: int) -> Vector3:
	var patrol_point = patrol_points[index]
	return Vector3(patrol_point.position.x, position.y, patrol_point.position.z)

func update_patrol_target():
	current_patrol_index = (current_patrol_index + 1) % patrol_points.size()
	target = get_patrol_point_position(current_patrol_index)

func _physics_process(delta):
	# Calculate the direction vector from the enemy to the target
	var direction = (target - position).normalized()
	position += direction * speed * delta
	if (!alerted):
		look_at(target, Vector3.UP)
		alerted = can_see_player()
		# Check if we've reached (or are close enough to) the target
		if position.distance_to(target) < 1.0:
			update_patrol_target()
	else:
		target = Vector3(player.position.x, position.y, player.position.z)
		look_at(target, Vector3.UP)
	
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
	speed += 2
	$VisionCone.queue_free()
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color.RED
	$Body.set_surface_override_material(0, mat)
	
