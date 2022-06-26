extends VBoxContainer

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
	difficulty_ui.connect("play", self, "_on_play")
	difficulty_ui.connect("load_difficulty", self, "_on_load")
	difficulty_ui.connect("save_to_disk", self, "_on_save_to_disk")

func clear() -> void:
	for child in get_children():
		if child is UISavedDifficulty:
			child.queue_free()

func _on_delete(ui_node: UISavedDifficulty) -> void:
	var dir = Directory.new()
	dir.open(OS.get_user_data_dir())
	if dir.remove(ui_node.difficulty.name) == OK:
		ui_node.queue_free()
	
