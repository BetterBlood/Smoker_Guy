class_name Player extends RigidBody3D

var mouse_sensitivty := 0.001
var twist_input := 0.0
var pitch_input := 0.0

#@onready var char_mesh := $MeshInstance3D
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot
@onready var foot_step: AudioStreamPlayer3D = $Audios/FootStep
@onready var jump: AudioStreamPlayer3D = $Audios/Jump

const sound_emitter = preload("res://scenes/sound_emitter.tscn")
const throwable_sound_maker = preload("res://scenes/throwable_sound_maker.tscn")
var val = 0
const walk_sound_strength = 10
const jump_sound_strength = 30
const crouch_mult = 0.3
var sound_mult = 1
@onready var world: Node3D = $".."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			twist_input = -event.relative.x * mouse_sensitivty
			pitch_input = -event.relative.y * mouse_sensitivty

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$ShadowMesh.rotation = Vector3.ZERO
	handle_move(delta)
	handle_look()
	handle_throw()
	
func is_grounded() -> bool:
	var groundDetected = $GroundDetectors/GroundDetector.is_colliding()
	groundDetected = groundDetected or $GroundDetectors/GroundDetector2.is_colliding()
	groundDetected = groundDetected or $GroundDetectors/GroundDetector3.is_colliding()
	groundDetected = groundDetected or $GroundDetectors/GroundDetector4.is_colliding()
	return groundDetected
	
func handle_move(delta: float):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right")
	input.z = Input.get_axis("move_forward", "move_back")
	
	val += delta
	if val > 0.5 && not input.is_zero_approx():
		#if crouching:
			#sound_mult = crouch_mult
		if is_grounded():
			foot_step.play()
			val = 0
			var sound_prop = sound_emitter.instantiate()
			sound_prop.setStrengh(walk_sound_strength * sound_mult)
			sound_prop.position = position + Vector3(0, 0.5, 0)
			world.add_child(sound_prop)
			
			sound_mult = 1
	
	var raw_force = twist_pivot.basis * input * 1200.0 * delta
	if is_grounded():
		var ground_normal = _get_ground_normal()
		var slide_force = raw_force.slide(ground_normal)
		var ramp_bias = clamp(1.0 - ground_normal.dot(Vector3.UP), 0, 1)
		var upward_bias = Vector3.UP * ramp_bias * 2000.0 * delta
		var move_force = slide_force + upward_bias
		apply_central_force(move_force * gravity_scale)
	else:
		apply_central_force(raw_force)
	
	if Input.is_action_pressed("jump"):
		if is_grounded():
			apply_central_force(Vector3.UP * 10000 * delta)
			if not jump.playing:
				jump.play()
				var sound_prop = sound_emitter.instantiate()
				sound_prop.setStrengh(jump_sound_strength)
				sound_prop.position = position + Vector3(0, 0.5, 0)
				world.add_child(sound_prop)
	
func handle_look():
	if Input.is_action_just_pressed("ui_cancel"):
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	twist_pivot.rotate_y(twist_input)
	#char_mesh.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		-0.5,
		0.5
	)
	twist_input = 0.0
	pitch_input = 0.0


func _get_ground_normal() -> Vector3:
	if $GroundDetectors/GroundDetector.is_colliding():
		return $GroundDetectors/GroundDetector.get_collision_normal()
	elif $GroundDetectors/GroundDetector2.is_colliding():
		return $GroundDetectors/GroundDetector2.get_collision_normal()
	elif $GroundDetectors/GroundDetector3.is_colliding():
		return $GroundDetectors/GroundDetector3.get_collision_normal()
	elif $GroundDetectors/GroundDetector4.is_colliding():
		return $GroundDetectors/GroundDetector4.get_collision_normal()
	else:
		return Vector3.UP

#func _on_area_3d_area_entered(area: Area3D) -> void:
	#if area.is_in_group("floor"):
		#print("Touching Floor")

func handle_throw():
	if Input.is_action_just_pressed("throw"):
		var tsm = throwable_sound_maker.instantiate()
		tsm.set_world(world)
		tsm.position = $TwistPivot/ThrowPosition.global_position
		var throwing_direction = $TwistPivot/ThrowPosition.global_position - position
		tsm.apply_central_impulse(throwing_direction * 75)
		world.add_child(tsm)


func call_heal(amount: int) -> void:
	print("TODO: handle heal on player")
