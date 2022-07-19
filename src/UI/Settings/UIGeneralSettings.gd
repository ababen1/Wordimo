# User interface that allows the player to select game settings.
# To see how we update the actual window and rendering settings, see
# `Main.gd`.
extends Control

onready var _res_settings: = $Video/UIResolutionSelector
onready var _fullscreen_checkbox: = $Video/UIFullscreenCheckbox
onready var _vsync_checkbox: = $Video/UIVsyncCheckbox

var settings := {
	resolution = Vector2(640, 480), 
	fullscreen = false, 
	vsync = false}

func _ready() -> void:
	if Funcs.is_mobile() or Funcs.is_html():
		$Video.queue_free()
	self.load()

func save(savedata: SaveGame) -> void:
	savedata.configs["resolution"] = _res_settings.get_selected_res()
	savedata.configs["fullscreen"] = _fullscreen_checkbox.checkbox.pressed
	savedata.configs["vsync"] = _vsync_checkbox.checkbox.pressed

func load(_savedata: SaveGame = null) -> void:
	_vsync_checkbox.checkbox.set_pressed(OS.vsync_enabled)
	_fullscreen_checkbox.checkbox.set_pressed(OS.window_fullscreen)
	_res_settings.set_selected_res(OS.window_size)
	
func _on_UIResolutionSelector_resolution_changed(new_resolution: Vector2) -> void:
	GameSaver.current_save.configs["resolution"] = new_resolution

func _on_UIFullscreenCheckbox_toggled(is_button_pressed: bool) -> void:
	GameSaver.current_save.configs["fullscreen"] = is_button_pressed

func _on_UIVsyncCheckbox_toggled(is_button_pressed: bool) -> void:
	GameSaver.current_save.configs["vsync"] = is_button_pressed
