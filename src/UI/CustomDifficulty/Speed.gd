extends GridContainer

const DEFAULT = 7

func _ready() -> void:
	_update_text()
	$SpinBox.connect("value_changed", self, "_on_value_changed")
	$Reset.connect("pressed", self, "_on_reset")

func get_speed() -> float:
	return $SpinBox.value

func set_speed(speed) -> void:
	$SpinBox.value = speed
	
func _update_text(new_val: float = $SpinBox.value):
	$SpinBox.hint_tooltip = "A new block will spawn every {x} seconds".format({
		"x": new_val})

func _on_value_changed(val: float) -> void:
	_update_text(val)
	$Reset.visible = (val != DEFAULT)
	
func _on_reset() -> void:
	$SpinBox.value = DEFAULT
