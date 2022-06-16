extends Control

const GAME_SCREEN = preload("res://src/GameBoard/Game.tscn")
const GAME_MODE_SELECT = preload("GameModeSelection.tscn")


func _ready() -> void:
	ThemeManger.current_theme = preload("res://assets/Themes/Gray.tres")

func _on_Start_pressed() -> void:
	get_tree().change_scene_to(GAME_SCREEN)


func _on_Tutorial_pressed() -> void:
	$TutorialPopup.popup_centered()
