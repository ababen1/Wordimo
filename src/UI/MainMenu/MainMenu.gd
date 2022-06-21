extends Control

onready var _game_mode_selection = $GameModeSelection
onready var _tutorial_popup = $TutorialPopup

func _on_Start_pressed() -> void:
	_game_mode_selection.popup()

func _on_Tutorial_pressed() -> void:
	_tutorial_popup.popup_centered()
