extends AcceptDialog

const TOUCHSCREEN_TUTORIAL = "Drag a block to pick it up\n Tap the screen while dragging to rotate"
const MOUSE_TUTORIAL = "Click a block to pick it up\nRight click a block to rotate it"

func _ready() -> void:
	dialog_text = dialog_text.format({
		"controls_tutorial": _get_controls_tutorial()
	})
	
func _get_controls_tutorial() -> String:
	match OS.get_name():
		"Android", "iOS":
			return TOUCHSCREEN_TUTORIAL
		_:
			return MOUSE_TUTORIAL
