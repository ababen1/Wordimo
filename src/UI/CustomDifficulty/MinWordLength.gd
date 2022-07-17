extends GridContainer

var min_length: int setget set_min_length, get_min_length

func get_min_length() -> int:
	return $SpinBox.value
	
func set_min_length(val: int) -> void:
	$SpinBox.value = val
