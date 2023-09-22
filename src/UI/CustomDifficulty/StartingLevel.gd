extends GridContainer

const DEFAULT = 1

func _ready() -> void:
	$SpinBox.connect("value_changed", Callable(self, "_on_value_changed"))
	$Reset.connect("pressed", Callable(self, "_on_reset"))
	$SpinBox.min_value = 1
	$SpinBox.max_value = CONSTS.MAX_LEVEL

func get_starting_level() -> float:
	return $SpinBox.value

func set_starting_level(lvl) -> void:
	$SpinBox.value = lvl

func _on_value_changed(val: float) -> void:
	$Reset.visible = (val != DEFAULT)
	
func _on_reset() -> void:
	$SpinBox.value = DEFAULT
