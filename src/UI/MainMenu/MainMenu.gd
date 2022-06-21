extends Control

func _on_Start_pressed() -> void:
	SceneChanger.change_scene("GameScreen")

func _on_Tutorial_pressed() -> void:
	$TutorialPopup.popup_centered()
