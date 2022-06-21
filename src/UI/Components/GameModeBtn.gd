tool
extends PanelButton
class_name DifficultyBtn

export var difficulty: Resource setget set_difficulty

func set_difficulty(val: Resource) -> void:
	difficulty = val
	self.title = val.name if val is DifficultyResource else ""
	self.description = val.description if val is DifficultyResource else ""
