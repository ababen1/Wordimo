tool
extends Control
class_name UISettingCheckbox

enum DEFAULT {
	ON = 1,
	OFF = 0
}

signal toggled(is_button_pressed)

export var title := "" setget set_title
export(DEFAULT) var default_value = DEFAULT.OFF

onready var _label := $Label
onready var checkbox: CheckBox = $CheckBox

func _on_CheckBox_toggled(button_pressed: bool) -> void:
	emit_signal("toggled", button_pressed)

func reset_to_default() -> void:
	checkbox.set_pressed_no_signal(default_value)

func set_title(value: String) -> void:
	title = value
	if not is_inside_tree():
		yield(self, "ready")
	_label.text = title
