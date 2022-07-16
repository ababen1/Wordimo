tool
extends WindowDialog

signal replay

func _enter_tree() -> void:
	if Engine.editor_hint:
		_test()

func _ready() -> void:
	get_close_button().hide()
	get_close_button().disabled = true

func _test() -> void:
	show_results(99, {
		"stat": "value", 
		"stat2": "value",
		"stat3": "valuasvgsavaafe"})

func show_results(score: float, stats: Dictionary) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	find_node("ScoreLabel").text = "Score: %d" % score
	find_node("StatsGrid").setup(stats)
	if not Engine.editor_hint:
		popup()

func _add_to_grid(stat: String, value: String) -> void:
	find_node("StatsGrid").add_label(stat, value)

func _on_MainMenu_pressed() -> void:
	get_tree().paused = false
	SceneChanger.change_scene("MainMenu")

func _on_PlayAgain_pressed() -> void:
	emit_signal("replay")
