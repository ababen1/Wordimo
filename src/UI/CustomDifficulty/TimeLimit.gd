extends OptionalField

func get_time_limit() -> float:
	if not is_activated:
		return 0.0
	return $Seconds.value + ($Minutes.value * 60)

func is_valid() -> bool:
	return get_time_limit() >= 0

func _on_Seconds_value_changed(value: float) -> void:
	if value == 60:
		$Seconds.value = 0
		$Minutes.value += 1
