extends Control

onready var _drag_input_checkbox: = $DragInput 

func _ready() -> void:
	if (OS.get_name() == "Android" or OS.get_name() == "iOS"):
		_drag_input_checkbox.visible = false
