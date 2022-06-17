extends Control

signal quit_game

var is_active: bool setget set_is_active

onready var _continue_btn = $Panel/VBox/HBoxContainer/Continue
onready var _quit_btn = $Panel/VBox/HBoxContainer/Quit

func _ready() -> void:
	self.is_active = false
	_continue_btn.connect("pressed", self, "set_is_active", [false])
	_quit_btn.connect("pressed", self, "_on_quit_pressed")

func toggle() -> void:
	self.is_active = !is_active

func set_is_active(val: bool) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	is_active = val
	get_tree().paused = is_active
	visible = is_active

func _on_quit_pressed() -> void:
	emit_signal("quit_game")
