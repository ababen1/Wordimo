@tool
extends Popup

func _enter_tree() -> void:
	if Engine.is_editor_hint() or (get_parent() == get_tree().root):
		visible = true

func close() -> void:
	hide()
	queue_free()

func update_settings(settings: Dictionary) -> void:
	get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN if (settings.fullscreen) else Window.MODE_WINDOWED
	get_window().set_size(settings.resolution)
	DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED if (settings.vsync) else DisplayServer.VSYNC_DISABLED)

func _on_Apply_pressed() -> void:
	if not Engine.is_editor_hint():
		GameSaver.save_progress()
		GameSaver.current_save.apply_configs()
		close()

func _on_Back_pressed() -> void:
	close()
