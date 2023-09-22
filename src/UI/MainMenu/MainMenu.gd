extends Control

@onready var _tutorial_popup = $TutorialPopup

func _ready() -> void:
	if Funcs.is_html():
		$VBoxContainer/VBoxContainer/Quit.hide()

func _on_Start_pressed() -> void:
	var menu = $ResourcePreloader.get_resource("GameModeSelection").instantiate()
	add_child(menu)
	menu.show()
	
func _on_Tutorial_pressed() -> void:
	_tutorial_popup.popup_centered()

func _on_Quit_pressed() -> void:
	get_tree().quit()
