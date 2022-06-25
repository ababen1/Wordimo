tool
extends Control

signal mode_selected(mode)

func _ready() -> void:
	if Engine.editor_hint:
		return
	if get_parent() == get_tree().root:
		show()
	else:
		hide()
	for child in find_node("GridContainer").get_children():
		if child is DifficultyBtn:
			child.connect(
				"pressed", self, "_on_mode_pressed", [child.difficulty])

func _on_mode_pressed(diffculty: DifficultyResource) -> void:
	SceneChanger.change_scene("GameScreen", true, {"difficulty": diffculty})

func _on_Custom_pressed() -> void:
	var custom_difficulty = $ResourcePreloader.get_resource(
		"CustomDifficulty").instance()
	add_child(custom_difficulty)
	custom_difficulty.popup()

func show():
	$AnimationPlayer.play("show")
	.show()

func hide():
	$AnimationPlayer.play("hide")
	.hide()

func _on_Close_pressed() -> void:
	hide()
