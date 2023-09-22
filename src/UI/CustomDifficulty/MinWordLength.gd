extends GridContainer

var min_length: int: get = get_min_length, set = set_min_length

func get_min_length() -> int:
	return $SpinBox.value
	
func set_min_length(val: int) -> void:
	$SpinBox.value = val
