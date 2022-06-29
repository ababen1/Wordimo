extends Control

onready var _tutorial_popup = $TutorialPopup

func _on_Start_pressed() -> void:
	var menu = $ResourcePreloader.get_resource("GameModeSelection").instance()
	add_child(menu)
	menu.show()
	
func _on_Tutorial_pressed() -> void:
	_tutorial_popup.popup_centered()
