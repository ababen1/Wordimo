extends CanvasLayer

onready var _texture_rect = $TextureRect

var texture: Texture setget set_texture

func _ready() -> void:
	_texture_rect.texture = GameSaver.current_save.data.get("bg", _texture_rect.texture)
	EventBus.connect("bg_changed", self, "set_texture")
	
func set_texture(val: Texture) -> void:
	texture = val
	_texture_rect.texture = val
