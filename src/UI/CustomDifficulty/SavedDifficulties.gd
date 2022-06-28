extends VBoxContainer

signal load_to_editor(difficulty)
signal delete_difficulty(difficulty)

func setup(difficulties: Array) -> void:
	clear()
	for difficulty in difficulties:
		if difficulty is DifficultyResource:
			add_difficulty(difficulty)
	
func add_difficulty(difficulty: DifficultyResource) -> void:
	var difficulty_ui: UISavedDifficulty = $ResourcePreloader.get_resource("SavedDifficulty").instance()
	add_child(difficulty_ui)
	difficulty_ui.difficulty = difficulty
	difficulty_ui.connect("delete", self, "_on_delete", [difficulty_ui])
	difficulty_ui.connect("play", self, "_on_play", [difficulty_ui.difficulty])
	difficulty_ui.connect("load_difficulty", self, "_on_load_difficulty", [difficulty_ui.difficulty])

func clear() -> void:
	for child in get_children():
		if child is UISavedDifficulty:
			child.queue_free()

func _on_delete(ui_node: UISavedDifficulty) -> void:
	emit_signal("delete_difficulty", ui_node.difficulty)
	ui_node.queue_free()
	
func _on_play(difficulty: DifficultyResource) -> void:
	SceneChanger.change_scene(
		"GameScreen", 
		true, 
		{"difficulty": difficulty})

func _on_load_difficulty(difficulty: DifficultyResource) -> void:
	emit_signal("load_to_editor", difficulty)
