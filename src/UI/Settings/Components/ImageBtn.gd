tool
extends Button
class_name UIImageBtn

export var is_selected: = false setget set_is_selected
export var texture: Texture setget set_texture
export var locked: = false setget set_locked

func set_is_selected(val: bool) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	is_selected = val
	$Texture/Selected.visible = is_selected

func _toggled(button_pressed: bool) -> void:
	set_is_selected(button_pressed)

func set_texture(val: Texture) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	texture = val
	$Texture.texture = texture

func set_locked(val: bool):
	locked = val
	$Locked.visible = val
	$Texture.visible = not locked
	disabled = val
	
