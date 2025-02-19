class_name OptionsMenu extends Control

var is_open:= true
@onready var options: OptionsMenu = $"."

func _ready() -> void:
	process_mode = ProcessMode.PROCESS_MODE_ALWAYS
	var audio_volums = ConfigFileHandler.load_audio_volums()
	
	$Panel/VBoxContainer/Master.value = audio_volums["Master"]
	$Panel/VBoxContainer/MusicSlider.value = audio_volums["Music"]
	$Panel/VBoxContainer/SFX.value = audio_volums["SFX"]
	$Panel/VBoxContainer/Voice.value = audio_volums["Voice"]

func _on_back_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("pause"):
		if not is_open:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			is_open = true
			options.show()
			get_tree().paused = true
		else:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			is_open = false
			options.hide()
			get_tree().paused = false


func _on_master_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(0, not value)
	AudioServer.set_bus_volume_db(0, value)

func _on_music_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(1, not value)
	AudioServer.set_bus_volume_db(1, value)


func _on_sfx_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(2, not value)
	AudioServer.set_bus_volume_db(2, value)


func _on_voice_value_changed(value: float) -> void:
	AudioServer.set_bus_mute(3, not value)
	AudioServer.set_bus_volume_db(3, value)


func _on_master_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_volum("Master", $Panel/VBoxContainer/Master.value)


func _on_music_slider_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_volum("Music", $Panel/VBoxContainer/MusicSlider.value)


func _on_sfx_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_volum("SFX", $Panel/VBoxContainer/SFX.value)


func _on_voice_drag_ended(value_changed: bool) -> void:
	if value_changed:
		ConfigFileHandler.save_audio_volum("Voice", $Panel/VBoxContainer/Voice.value)
