tool
extends Control

signal mode_selected(mode)

func _ready() -> void:
	if Engine.editor_hint:
		return
	if get_parent() == get_tree().root:
		visible = true
	for child in get_children():
		if child is DifficultyBtn:
			child.connect(
				"pressed", self, "_on_mode_pressed", [child.difficulty])

func _on_mode_pressed(diffculty: DifficultyResource) -> void:
	emit_signal("mode_selected", diffculty)
