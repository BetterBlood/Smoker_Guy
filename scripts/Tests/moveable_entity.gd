extends CharacterBody3D

const SPEED = 5.0
const JUMP_VELOCITY = 4.5

const sound_emitter = preload("res://scenes/sound_emitter.tscn")
var val = 0
const walk_sound_strength = 15
const jump_sound_strength = 80
const crouch_mult = 0.3
var sound_mult = 1

@onready var world: Node3D = $".."
@onready var foot_step: AudioStreamPlayer3D = $FootStep

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		var sound_prop = sound_emitter.instantiate()
		sound_prop.setStrengh(jump_sound_strength)
		sound_prop.position = position
		world.add_child(sound_prop)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	val += delta
	if val > 0.5 && not input_dir.is_zero_approx():
		foot_step.play()
		#if crouching:
			#sound_mult = crouch_mult
		val = 0
		var sound_prop = sound_emitter.instantiate()
		sound_prop.setStrengh(walk_sound_strength * sound_mult)
		sound_prop.position = position
		world.add_child(sound_prop)
		
		sound_mult = 1
