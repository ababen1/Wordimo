#tool
extends CanvasLayer

@export var texture: Texture2D: set = set_texture

func _ready() -> void:
	if not Engine.is_editor_hint():
		$TextureRect.texture = ThemeManger.current_bg
		ThemeManger.connect("bg_changed", Callable(self, "set_texture"))
	
func set_texture(val: Texture2D) -> void:
	if not is_inside_tree():
		await self.ready
	texture = val
	$TextureRect.texture = val
