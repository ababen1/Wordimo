tool
extends OptionalField

func get_queue_size() -> int:
	return $SpinBox.value if is_activated else 0
