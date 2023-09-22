@tool
extends Control
class_name GameModeSelection

@export var add_favs_to_grid: = false

@onready var _grid = $VBoxContainer/ScrollContainer/VBox/GridContainer

func _ready() -> void:
	if Engine.is_editor_hint():
		return
	if get_parent() == get_tree().root:
		show()
	else:
		hide()
	if add_favs_to_grid:
		add_fav_difficulties_to_grid()
	for child in _grid.get_children():
		if child is DifficultyBtn:
			child.connect(
				"pressed", self, "_on_mode_pressed", [child.difficulty])

func _on_mode_pressed(diffculty: DifficultyResource) -> void:
	SceneChanger.change_scene_to_file("GameScreen", true, {"difficulty": diffculty})

func _on_Custom_pressed() -> void:
	var custom_difficulty = $ResourcePreloader.get_resource(
		"CustomDifficulty").instantiate()
	add_child(custom_difficulty)
	custom_difficulty.popup()

func add_fav_difficulties_to_grid() -> void:
	for difficulty in load_saved_difficulties():
		if difficulty.is_favorite:
			var btn = $ResourcePreloader.get_resource("GameModeButton").instantiate()
			btn.difficulty = difficulty
			_grid.add_child(btn)

func show():
	$AnimationPlayer.play("show")
	super.show()

func hide():
	$AnimationPlayer.play("hide")
	super.hide()

func _on_Close_pressed() -> void:
	hide()

static func load_saved_difficulties(save_path: String = OS.get_user_data_dir()) -> Array:
	var saved_difficulties: = []
	var dir = DirAccess.new()
	if dir.open(save_path) == OK:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var file_name: String = dir.get_next()
		while file_name != "":
			if ResourceLoader.exists(save_path.plus_file(file_name)):
				var difficulty = ResourceLoader.load(
					save_path.plus_file(file_name),
					"",
					true)
				if difficulty is DifficultyResource:
					difficulty.is_custom = true
					saved_difficulties.append(difficulty)
			file_name = dir.get_next()
	return saved_difficulties
