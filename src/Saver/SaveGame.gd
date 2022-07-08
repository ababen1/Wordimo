extends Resource
class_name SaveGame

const SAVE_NAME_TEMPLATE: String = "{name}_{seed}.tres"

export var name: String
export var random_seed: int
export var game_version: String
export var playtime: float = 0.0
export var data: Dictionary = {}
export var configs: = {}

static func get_savefile_name(_name: String, _random_seed: int):
	return SAVE_NAME_TEMPLATE.format({
		"name": _name,
		"seed": str(_random_seed)
	})

func apply_configs() -> void:
	OS.window_size = configs.get("resolution", OS.window_size)
	OS.vsync_enabled = configs.get("vsync", OS.vsync_enabled)
	OS.window_fullscreen = configs.get("fullscreen", OS.window_fullscreen)

func get_save_path(folder: String) -> String:
	return folder.plus_file(
		get_savefile_name(self.name, self.random_seed))

func save(folder: String) -> int:
	var path = get_save_path(folder)
	return ResourceSaver.save(path, self)

func _init(_name: String = "", _random_seed: int = randi()):
	self.name = _name
	self.random_seed = _random_seed
	self.game_version = ProjectSettings.get_setting(
		"application/config/version")
		
