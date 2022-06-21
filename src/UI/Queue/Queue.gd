extends CanvasLayer

func _ready() -> void:
	ThemeManger.connect(
		"theme_changed", 
		self, 
		"set_theme")

func set_theme(new: Theme) -> void:
	$VBox.propagate_call("set_theme", [new])
	$VBox.propagate_call("update")

