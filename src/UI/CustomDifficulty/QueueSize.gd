tool
extends GridContainer

func _enter_tree() -> void:
	_update()

func _ready() -> void:
	$CheckBox.connect("pressed", self, "_on_checkbox_pressed")

func _on_checkbox_pressed() -> void:
	_update()

func _update():
	$SpinBox.editable = $CheckBox.pressed
