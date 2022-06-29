tool
extends PanelButton
class_name DifficultyBtn

export var difficulty: Resource setget set_difficulty

func _enter_tree() -> void:
	self.rect_min_size = Vector2(350,130)

func set_difficulty(val: Resource) -> void:
	difficulty = val
	self.title = val.name if val is DifficultyResource else ""
	self.description = val.description if val is DifficultyResource else ""
	$TextureRect.visible = true if (val is DifficultyResource and val.is_favorite) else false
