class_name Player extends RigidBody3D

var mouse_sensitivty := 0.001
var twist_input := 0.0
var pitch_input := 0.0

@onready var char_mesh := $MeshInstance3D
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot = $TwistPivot/PitchPivot

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
	handle_move(delta)
	handle_look()

func handle_move(delta: float):
	var input := Vector3.ZERO
	input.x = Input.get_axis("move_left", "move_right");
	input.z = Input.get_axis("move_forward", "move_back");
	
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
func handle_look():
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

	twist_pivot.rotate_y(twist_input)
	char_mesh.rotate_y(twist_input)
	pitch_pivot.rotate_x(pitch_input)
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		-0.5,
		0.5
	)
	twist_input = 0.0
	pitch_input = 0.0
