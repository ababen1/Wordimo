tool
extends Popup

func _enter_tree() -> void:
	if Engine.editor_hint or (get_parent() == get_tree().root):
		visible = true

func close() -> void:
	hide()
	queue_free()

func update_settings(settings: Dictionary) -> void:
	OS.window_fullscreen = settings.fullscreen
	get_tree().set_screen_stretch(
		SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_KEEP, settings.resolution
	)
	OS.set_window_size(settings.resolution)
	OS.vsync_enabled = settings.vsync

func _on_Apply_pressed() -> void:
	if not Engine.editor_hint:
		GameSaver.save_progress()
		GameSaver.current_save.apply_configs()
		close()

func _on_Back_pressed() -> void:
	close()
