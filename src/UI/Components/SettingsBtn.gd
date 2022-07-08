extends Button
class_name SettingsBtn

func _pressed() -> void:
	var dialog = $ResourcePreloader.get_resource("SettingsDialog").instance()
	add_child(dialog)
	dialog.popup()
