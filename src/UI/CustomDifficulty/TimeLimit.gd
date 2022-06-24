tool
extends GridContainer

func _enter_tree() -> void:
	_update()

func _on_CheckBox_pressed() -> void:
	_update()

func _update():
	var line_edit = $LineEdit
	var checkbox = $CheckBox
	line_edit.editable = checkbox.pressed
	line_edit.text = "Unlimited" if not checkbox.pressed else ""
