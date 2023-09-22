@tool
extends OptionalField

func get_queue_size() -> int:
	return $SpinBox.value if is_activated else 0

func set_queue_size(size):
	if size != 0:
		set_is_activated(true)
	$SpinBox.set_value(size)
