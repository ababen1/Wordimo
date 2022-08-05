extends PopupPanel

signal replay

func _enter_tree() -> void:
	if Engine.editor_hint:
		_test()

func _test() -> void:
	pass
	
func show_results(stats: GameResults) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	var results_dict: Dictionary = stats.as_dict()
	var words_written = results_dict["words_written"]
# warning-ignore:return_value_discarded
	results_dict.erase("words_written")
	find_node("Words").setup(words_written)
	find_node("StatsGrid").setup(results_dict)
	if not Engine.editor_hint:
		popup()

func _add_to_grid(stat: String, value: String) -> void:
	find_node("StatsGrid").add_label(stat, value)

func _on_MainMenu_pressed() -> void:
	get_tree().paused = false
	SceneChanger.change_scene("MainMenu")

func _on_PlayAgain_pressed() -> void:
	emit_signal("replay")
