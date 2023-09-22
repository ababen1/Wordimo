extends HBoxContainer

signal setting_changed(new_val)

@export var text = "": set = set_text
@export var default_value: float = 0 

@onready var label: = $Label
@onready var spinbox: = $SpinBox

func set_text(val: String) -> void:
	if not is_inside_tree():
		await self.ready
	text = val
	label.text = val

func reset_to_default() -> void:
	spinbox.value = default_value

func get_value() -> float:
	return spinbox.value

func _on_SpinBox_value_changed(value: float) -> void:
	emit_signal("setting_changed", value)
