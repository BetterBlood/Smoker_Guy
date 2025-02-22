extends RigidBody3D

const sound_emitter = preload("res://scenes/sound_emitter.tscn")
var strength:= 50
var world:Node3D = null

func set_world(world_given:Node3D):
	world = world_given

func _on_area_3d_body_entered(body: Node3D) -> void:
	#print("hit: ", body, ", ", body is StaticBody3D)
	if world == null:
		world = $".."
		if world == null:
			push_error( "No world found in ThrowableSoundMaker: ", get_rid(), \
						", Please set one using set_world(world_given:Node3D)")
			return
	
	if body.is_in_group("Enemy"):
		var enemy = body as Enemy
		enemy.has_been_hit_by_player()
		queue_free()
	
	if body is StaticBody3D or body is CSGBox3D or body.is_in_group("Floor"):
		var sound_prop = sound_emitter.instantiate()
		sound_prop.setStrengh(strength)
		sound_prop.position = position
		world.add_child(sound_prop)
		queue_free()
		
