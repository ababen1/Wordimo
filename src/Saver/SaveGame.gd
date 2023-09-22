extends Resource
class_name SaveGame

const SAVE_NAME_TEMPLATE: String = "{name}_{seed}.tres"

@export var name: String
@export var random_seed: int
@export var game_version: String
@export var playtime: float = 0.0
@export var data: Dictionary = {}
@export var configs: = {}

func _init(_name: String = "", _random_seed: int = randi()) -> void:
	self.name = _name
	self.random_seed = _random_seed
	self.game_version = ProjectSettings.get_setting(
		"application/config/version")
	data["unlocked_themes"] = [ThemeManger.DEFAULT_THEME_NAME]
	data["unlocked_bgs"] = [ThemeManger.DEFAULT_BG_NAME]

static func get_savefile_name(_name: String, _random_seed: int):
	return SAVE_NAME_TEMPLATE.format({
		"name": _name,
		"seed": str(_random_seed)
	})

func apply_configs() -> void:
	#OS.window_size = configs.get("resolution", OS.window_size)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (configs.get("vsync", (DisplayServer.window_get_vsync_mode() != DisplayServer.VSYNC_DISABLED))) else DisplayServer.VSYNC_DISABLED)
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (configs.get("fullscreen", ((get_window().mode == Window.MODE_EXCLUSIVE_FULLSCREEN) or (get_window().mode == Window.MODE_FULLSCREEN)))) else Window.MODE_WINDOWED

func get_save_path(folder: String) -> String:
	return folder.plus_file(
		get_savefile_name(self.name, self.random_seed))

func save(folder: String) -> int:
	var path = get_save_path(folder)
	return ResourceSaver.save(path, self)
	
		
