extends Node3D
@onready var options: OptionsMenu = $Options

func _ready() -> void:
	options.hide()
	options.is_open = false
