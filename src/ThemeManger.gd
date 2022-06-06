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

