@tool
extends GridContainer
class_name OptionalField

"""
This class shows the activated fields when the checkbox is pressed,
and hides the deactivated fields. It does the opposite when the checkbox
is not pressed
"""

@export var is_activated: = false: set = set_is_activated
@export var deactivated_fields: Array
@export var activated_fields: Array

func _enter_tree() -> void:
	$CheckBox.connect("pressed", Callable(self, "_on_checkbox_pressed"))

func set_is_activated(val: bool):
	is_activated = val
	$CheckBox.button_pressed = val
	_toggle_fields(activated_fields, is_activated)
	_toggle_fields(deactivated_fields, not is_activated)

func _on_checkbox_pressed() -> void:
	self.is_activated = $CheckBox.pressed

func _toggle_fields(fields: Array, is_active: bool) -> void:
	for path in fields:
		if path is NodePath:
			if get_node_or_null(path):
				get_node(path).visible = is_active
		
