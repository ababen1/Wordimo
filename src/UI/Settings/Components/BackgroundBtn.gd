@tool
extends Button
class_name UIBackgroundBtn

@export var is_selected: = false: set = set_is_selected
@export var texture: Texture2D: set = set_texture
@export var locked: = false: set = set_locked

func set_is_selected(val: bool) -> void:
	if not is_inside_tree():
		await self.ready
	is_selected = val
	$Texture2D/Selected.visible = is_selected

func _toggled(button_pressed: bool) -> void:
	set_is_selected(button_pressed)

func set_texture(val: Texture2D) -> void:
	if not is_inside_tree():
		await self.ready
	texture = val
	$Texture2D.texture = texture

func set_locked(val: bool):
	locked = val
	$Locked.visible = val
	$Texture2D.visible = not locked
	disabled = val
	
