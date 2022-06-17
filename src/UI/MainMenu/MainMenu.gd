extends Control

const GAME_SCREEN = preload("res://src/GameBoard/Game.tscn")
const GAME_MODE_SELECT = preload("GameModeSelection.tscn")

func _on_Start_pressed() -> void:
	SceneChanger.change_scene(GAME_SCREEN)

func _on_Tutorial_pressed() -> void:
	$TutorialPopup.popup_centered()
