extends Button
class_name SettingsBtn

func _pressed() -> void:
	var dialog = $ResourcePreloader.get_resource("SettingsDialog").instantiate()
	add_child(dialog)
	dialog.popup()
