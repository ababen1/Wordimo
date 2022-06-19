tool
extends WindowDialog

func _enter_tree() -> void:
	_test()

func _test() -> void:
	if Engine.editor_hint:
		show_results(99, {
			"stat": "value", 
			"stat2": "value",
			"stat3": "valuasvgsavaafe"})

func show_results(score: float, stats: Dictionary) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	find_node("ScoreLabel").text = "Score: {%d}" % score
	find_node("StatsGrid").setup(stats)
	if not Engine.editor_hint:
		popup()

func _add_to_grid(stat: String, value: String) -> void:
	pass
