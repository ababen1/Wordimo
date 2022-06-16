extends Node

const DEFAULT_THEME = preload("res://assets/Themes/DefaultTheme.tres")

signal theme_changed(new_theme)

var current_theme: Theme = DEFAULT_THEME setget set_current_theme

func _ready() -> void:
	self.current_theme = DEFAULT_THEME
	

func set_current_theme(val: Theme) -> void:
	current_theme = val
	get_tree().current_scene.propagate_call("set_theme", [current_theme], false)
	get_tree().current_scene.propagate_call("update", [], false)
	emit_signal("theme_changed", current_theme)

func set_theme_color(color: Color) -> void:
	for stylebox_type in current_theme.get_stylebox_types():
		for stylebox_name in current_theme.get_stylebox_list(stylebox_type):
			var current_stylebox: StyleBox = current_theme.get_stylebox(stylebox_name, stylebox_type)
			if current_stylebox.get("modulate_color"):
				current_stylebox.set("modulate_color", color)
