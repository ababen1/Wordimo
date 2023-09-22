extends Control

@onready var _drag_input_checkbox: = $DragInput 

func _ready() -> void:
	if Funcs.is_mobile():
		_drag_input_checkbox.visible = false
	else:
		$DragInput.checkbox.set_pressed_no_signal(
			GameSaver.current_save.data.get("drag_input", false))

func _on_DragInput_toggled(is_button_pressed) -> void:
	GameSaver.current_save.data["drag_input"] = is_button_pressed

func _on_ChangeBackground_pressed() -> void:
	var bg_select_popup = $ResourcePreloader.get_resource("BgSelect").instantiate()
	bg_select_popup.set_as_top_level(true)
	add_child(bg_select_popup)
	bg_select_popup.connect("hide", Callable(bg_select_popup, "queue_free").bind(), CONNECT_ONE_SHOT)
	bg_select_popup.popup()
	
