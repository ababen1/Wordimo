extends WindowDialog

enum GAMEMODE {
	CHILL,
	TIMED
}

signal mode_selected(mode)

func _ready() -> void:
	for child in $VBox.get_children():
		if child is Button:
			child.connect("pressed", self, "_on_mode_pressed", [child])

func _on_mode_pressed(btn: Button) -> void:
	emit_signal("mode_selected", GAMEMODE.keys()[btn.get_position_in_parent()])

