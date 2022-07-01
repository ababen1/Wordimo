extends PopupPanel

signal end_game

var is_active: bool setget set_is_active

onready var _continue_btn = $VBox/Vbox/Continue
onready var _quit_btn = $VBox/Vbox/Quit

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
	if is_active:
		popup()
	else:
		hide()


func _on_Quit_pressed() -> void:
	get_tree().paused = false
	SceneChanger.change_scene("MainMenu")


func _on_GiveUp_pressed() -> void:
	self.is_active = false
	emit_signal("end_game")
