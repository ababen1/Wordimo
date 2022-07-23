#tool
extends CanvasLayer

export var texture: Texture setget set_texture

func _ready() -> void:
	if not Engine.editor_hint:
		$TextureRect.texture = ThemeManger.current_bg
		ThemeManger.connect("bg_changed", self, "set_texture")
	
func set_texture(val: Texture) -> void:
	if not is_inside_tree():
		yield(self, "ready")
	texture = val
	$TextureRect.texture = val
