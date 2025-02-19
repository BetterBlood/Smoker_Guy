extends Node

var config = ConfigFile.new()
const VOLUMS_FILE_PATH = "user://volumes.ini"

func _ready() -> void:
	if !FileAccess.file_exists(VOLUMS_FILE_PATH):
		config.set_value("audio", "Master", 50)
		config.set_value("audio", "Music", 30)
		config.set_value("audio", "SFX", 30)
		config.set_value("audio", "Voice", 30)
		
		config.save(VOLUMS_FILE_PATH)
	else:
		config.load(VOLUMS_FILE_PATH)
		

func save_audio_volum(name: String, value: float):
	config.set_value("audio", name, value)
	config.save(VOLUMS_FILE_PATH)
	
func load_audio_volums():
	var audio_volums = {}
	for key in config.get_section_keys("audio"):
		audio_volums[key] = config.get_value("audio", key)
	return audio_volums
