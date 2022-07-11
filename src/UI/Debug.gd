extends Control

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("left_click"):
		$Notifications.display_message("asdfsda")
