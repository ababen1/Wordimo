# User interface that allows the player to select game settings.
# To see how we update the actual window and rendering settings, see
# `Main.gd`.
extends Control

var settings := {resolution = Vector2(640, 480), fullscreen = false, vsync = false}

func _on_UIResolutionSelector_resolution_changed(new_resolution: Vector2) -> void:
	settings.resolution = new_resolution

func _on_UIFullscreenCheckbox_toggled(is_button_pressed: bool) -> void:
	settings.fullscreen = is_button_pressed

func _on_UIVsyncCheckbox_toggled(is_button_pressed: bool) -> void:
	settings.vsync = is_button_pressed
