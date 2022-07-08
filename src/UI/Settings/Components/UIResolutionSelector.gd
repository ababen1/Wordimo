extends Control

const RESOLUTIONS = [
	Vector2(640, 360),
	OS.window_size,
	Vector2(1280, 720),
	Vector2(1920, 1080)
]

signal resolution_changed(new_resolution)

onready var option_button: OptionButton = $OptionButton

func _ready() -> void:
	yield(get_parent(), "ready")
	if not RESOLUTIONS.empty():
		setup(RESOLUTIONS)
	option_button.selected = _find_resulotion_index(OS.window_size)
	
func setup(resolutions: Array) -> void:
	option_button.clear()
	for res in resolutions:
		option_button.add_item("{w}x{h}".format({"w": res.x, "h": res.y}))

func get_selected_res() -> Vector2:
	return _text_to_resoultion(option_button.text)

func set_selected_res(res: Vector2) -> void:
	option_button.selected = _find_resulotion_index(res)

func _on_OptionButton_item_selected(_index: int) -> void:
	emit_signal("resolution_changed", _text_to_resoultion(option_button.text))

func _find_resulotion_index(res: Vector2) -> int:
	for i in option_button.get_item_count():
		var current_item_text = option_button.get_item_text(i)
		var values = current_item_text.split_floats("x")
		if Vector2(values[0], values[1]) == res:
			return i
	return -1

func _text_to_resoultion(text: String = option_button.text) -> Vector2:
	var values := option_button.get_item_text(
		option_button.selected).split_floats("x")
	return Vector2(values[0], values[1])
