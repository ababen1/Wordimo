extends Control

onready var _drag_input_checkbox: = $DragInput 

const DEFAULT = {
	"drag_input": false,
	"min_word_length": 4
}

var current_settings = DEFAULT setget set_current_settings

func set_current_settings(val: Dictionary):
	current_settings = val
	$DragInput.checkbox.set_pressed_no_signal(
		val.get("drag_input", DEFAULT.drag_input))
	$MinLength.spinbox.value = val.get("min_word_length", DEFAULT.min_word_length)

func _ready() -> void:
	if GameSaver.is_mobile():
		_drag_input_checkbox.visible = false
 
func _on_UISettingSpinbox_setting_changed(new_val) -> void:
	current_settings.min_word_length = new_val

func _on_DragInput_toggled(is_button_pressed) -> void:
	current_settings.drag_input = is_button_pressed

func _on_ChangeBackground_pressed() -> void:
	var bg_select_popup = $ResourcePreloader.get_resource("BgSelect").instance()
	bg_select_popup.set_as_toplevel(true)
	add_child(bg_select_popup)
	bg_select_popup.connect("hide", bg_select_popup, "queue_free",[], CONNECT_ONESHOT)
	bg_select_popup.popup()
	
