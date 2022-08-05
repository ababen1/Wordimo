extends WindowDialog

onready var _board_size_field = $HSplit/PanelContainer/VBox/BoardSize
onready var _time_limit_field = $HSplit/PanelContainer/VBox/TimeLimit
onready var _queue_size = $HSplit/PanelContainer/VBox/QueueSize
onready var _start_btn = $HSplit/PanelContainer/VBox/HBox/Start
onready var _save_btn = $HSplit/PanelContainer/VBox/HBox/Save
onready var _override = $HSplit/PanelContainer/VBox/Override
onready var _min_length = $HSplit/PanelContainer/VBox/MinWordLength
onready var _starting_level = $HSplit/PanelContainer/VBox/StartingLevel
onready var _inscrease_levels = _starting_level.get_node("IncreaseLevels")

var saved_difficulties: Array = [] setget set_saved_difficulties
var last_saved: String = ""

func _ready() -> void:
	if get_parent() == get_tree().root:
		visible = true
	_start_btn.connect("pressed", self, "_on_start_pressed")
	_save_btn.connect("pressed", self, "_on_save_pressed")
	self.saved_difficulties = GameModeSelection.load_saved_difficulties()
	set_difficulty(DifficultyResource.new())
	
func get_time_limit() -> float:
	var minutes = $VBox/TimeLimit/Minutes.value
	var seconds = $VBox/TimeLimit/Seconds.value
	return (minutes * 60) + seconds

func set_saved_difficulties(val: Array):
	saved_difficulties = val
	$HSplit/Panel/SavedDifficulties.setup(saved_difficulties)

func popup_error(text: String, title: = "Error") -> void:
	var error: = AcceptDialog.new()
	error.window_title = title
	error.dialog_text = text
	add_child(error)
	error.popup_centered()

func create_difficulty() -> DifficultyResource:
	var difficulty: = DifficultyResource.new()
	difficulty.is_custom = true
	difficulty.time_limit = _time_limit_field.get_time_limit()
	difficulty.queue_size = _queue_size.get_queue_size()
	difficulty.can_override = _override.get_node("CheckBox").pressed
	difficulty.increase_levels = _inscrease_levels.pressed
	difficulty.board_size = _board_size_field.get_board_size()
	difficulty.min_word_length = _min_length.get_min_length() 
	difficulty.starting_level = _starting_level.get_starting_level()
	return difficulty

func set_difficulty(difficulty: DifficultyResource) -> void:
	_time_limit_field.set_time_limit(difficulty.time_limit)
	_queue_size.set_queue_size(difficulty.queue_size)
	_override.get_node("CheckBox").set_pressed_no_signal(difficulty.can_override)
	_board_size_field.set_board_size(difficulty.board_size)
	_min_length.set_min_length(difficulty.min_word_length)
	_starting_level.set_starting_level(difficulty.starting_level)
	_inscrease_levels.set_pressed_no_signal(difficulty.increase_levels)
	last_saved = difficulty.name

func save_difficulty(_name, description):
	var difficulty: = create_difficulty()
	difficulty.name = _name
	difficulty.description = description
	last_saved = _name
	var data_dir = OS.get_user_data_dir()
	print(ResourceSaver.save(
		data_dir.plus_file(_name + ".tres"), 
		difficulty))

func _on_start_pressed() -> void:
	if not _time_limit_field.is_valid():
		popup_error("Invalid time limit")
		return
	if not _board_size_field.is_valid():
		popup_error("Invalid board size")
		return
	SceneChanger.change_scene("GameScreen", true, {"difficulty": create_difficulty()})
	
func _on_save_pressed() -> void:
	var dialog = $ResourcePreloader.get_resource("SaveDifficultyDialog").instance()
	add_child(dialog)
	dialog.name_field.text = last_saved
	dialog.connect("confirmed", self, "_on_save_dialog_confirmed")
	dialog.existing_difficulties = saved_difficulties
	dialog.popup()

func _on_save_dialog_confirmed(
	difficulty_name: String, 
	difficulty_description: String) -> void:
		save_difficulty(difficulty_name, difficulty_description)
		self.saved_difficulties = GameModeSelection.load_saved_difficulties()

func _on_SavedDifficulties_load_to_editor(difficulty) -> void:
	set_difficulty(difficulty)

func _on_SavedDifficulties_delete_difficulty(difficulty) -> void:
	var dir = Directory.new()
	dir.remove(OS.get_user_data_dir().plus_file(difficulty.name + ".tres"))
	self.saved_difficulties = GameModeSelection.load_saved_difficulties()

func _on_OpenFolder_pressed() -> void:
	OS.shell_open(OS.get_user_data_dir())
