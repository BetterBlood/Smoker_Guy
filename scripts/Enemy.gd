class_name Enemy extends CharacterBody3D
@export var point_a: Vector3
@export var point_b: Vector3
@export var speed: float = 5.0

var alerted: bool = false
var target: Vector3

func _ready():
	# Start by moving toward point B
	target = point_b

func _physics_process(delta):
	# Calculate the direction vector from the enemy to the target
	var direction = (target - position).normalized()
	
	if (!alerted):
		alerted = can_see_player()
	# Move the enemy towards the target
	position += direction * speed * delta
	# Check if we've reached (or are close enough to) the target
	if position.distance_to(target) < 1.0:
		# Switch target between point A and point B
		target = point_a if target == point_b else point_b
		look_at(target, Vector3.UP)

func can_see_player() -> bool:
	for child in $Rays.get_children():
		if child is RayCast3D:
			# Ensure the raycast is active.
			if child.is_enabled() and child.is_colliding():
				var collider = child.get_collider()
				 # Check by comparing against the player’s group or name
				if collider and collider.is_in_group("Player"):
					return true
	return false
