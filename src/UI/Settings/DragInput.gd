extends CheckBox

func _ready() -> void:
	if (OS.get_name() == "Android" or OS.get_name() == "iOS"):
		visible = false
	else:
		connect("pressed", self, "_on_pressed")
		update_text()

func _on_pressed():
	update_text()

func update_text():
	if pressed:
		hint_tooltip = "Blocks will move by dragging them with the mouse"
	else:
		hint_tooltip = "Blocks will move by clicking them once to pick them up"
