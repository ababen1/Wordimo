extends WindowDialog

onready var _board_size_field = $HSplit/PanelContainer/VBox/BoardSize
onready var _time_limit_field = $HSplit/PanelContainer/VBox/TimeLimit
onready var _queue_size = $HSplit/PanelContainer/VBox/QueueSize
onready var _start_btn = $HSplit/PanelContainer/VBox/HBox/Start
onready var _save_btn = $HSplit/PanelContainer/VBox/HBox/Save
onready var _override = $HSplit/PanelContainer/VBox/Override
onready var _speed = $HSplit/PanelContainer/VBox/Speed

func _ready() -> void:
	if get_parent() == get_tree().root:
		visible = true
	_start_btn.connect("pressed", self, "_on_start_pressed")
	_save_btn.connect("pressed", self, "_on_save_pressed")

func get_time_limit() -> float:
	var minutes = $VBox/TimeLimit/Minutes.value
	var seconds = $VBox/TimeLimit/Seconds.value
	return (minutes * 60) + seconds

func popup_error(text: String, title: = "Error") -> void:
	var error: = AcceptDialog.new()
	error.window_title = title
	error.dialog_text = text
	add_child(error)
	error.popup_centered()

func create_difficulty() -> DifficultyResource:
	var difficulty: = DifficultyResource.new()
	difficulty.time_limit = _time_limit_field.get_time_limit()
	difficulty.queue_size = _queue_size.get_queue_size()
	difficulty.can_override = _override.get_node("CheckBox").pressed
	difficulty.speed = _speed.get_speed()
	difficulty.board_size = _board_size_field.get_board_size()
	difficulty.lose_when_board_full = get_node(
		"HSplit/PanelContainer/VBox/GameOver/VBox/BoardFull").pressed
	difficulty.lose_when_queue_full = get_node(
		"HSplit/PanelContainer/VBox/GameOver/VBox/QueueFull").pressed
	return difficulty
	
func _on_start_pressed() -> void:
	if not _time_limit_field.is_valid():
		popup_error("Invalid time limit")
		return
	if not _board_size_field.is_valid():
		popup_error("Invalid board size")
		return
	SceneChanger.change_scene("GameScreen", true, {"difficulty": create_difficulty()})
	
func _on_save_pressed() -> void:
	$SaveDifficultyDialog.popup()

func _on_SaveDifficultyDialog_confirmed(
	difficulty_name: String, 
	difficulty_description: String) -> void:
		var difficulty: = create_difficulty()
		difficulty.name = difficulty_name
		difficulty.description = difficulty_description
		var data_dir = OS.get_user_data_dir()
		ResourceSaver.save(
			data_dir.plus_file(difficulty_name + ".tres"), 
			difficulty)
