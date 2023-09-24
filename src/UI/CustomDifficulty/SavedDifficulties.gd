extends VBoxContainer

signal load_to_editor(difficulty)
signal delete_difficulty(difficulty)

func _ready() -> void:
	$HBox/OpenFolder.visible = not Funcs.is_mobile() and not Funcs.is_html()

func setup(difficulties: Array) -> void:
	clear()
	for difficulty in difficulties:
		if difficulty is DifficultyResource:
			add_difficulty(difficulty)
	sort()
	
func add_difficulty(difficulty: DifficultyResource) -> void:
	var difficulty_ui: UISavedDifficulty = $ResourcePreloader.get_resource("SavedDifficulty").instantiate()
	add_child(difficulty_ui)
	difficulty_ui.difficulty = difficulty
	difficulty_ui.connect("delete", Callable(self, "_on_delete").bind(difficulty_ui))
	difficulty_ui.connect("play", Callable(self, "_on_play").bind(difficulty_ui.difficulty))
	difficulty_ui.connect("load_difficulty", Callable(self, "_on_load_difficulty").bind(difficulty_ui.difficulty))
	difficulty_ui.connect("favorite_toggled", Callable(self, "_on_favorite").bind(difficulty_ui.difficulty))

func sort() -> void:
	var index = 1
	for child in get_children():
		if child is UISavedDifficulty:
			if child.difficulty.is_favorite:
				move_child(child, index)
				index += 1
	
func clear() -> void:
	for child in get_children():
		if child is UISavedDifficulty:
			child.queue_free()

func _on_favorite(difficulty: DifficultyResource):
	ResourceSaver.save(
		difficulty,
		OS.get_user_data_dir().path_join(difficulty.name + ".tres"))
	sort()

func _on_delete(ui_node: UISavedDifficulty) -> void:
	emit_signal("delete_difficulty", ui_node.difficulty)
	ui_node.queue_free()
	
func _on_play(difficulty: DifficultyResource) -> void:
	SceneChanger.change_scene_to_file(
		"GameScreen", 
		true, 
		{"difficulty": difficulty})

func _on_load_difficulty(difficulty: DifficultyResource) -> void:
	emit_signal("load_to_editor", difficulty)
