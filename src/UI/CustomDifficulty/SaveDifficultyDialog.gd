extends WindowDialog

signal confirmed(difficulty_name, difficulty_description)

onready var _save_btn = $VBox/Save

func _ready() -> void:
	_save_btn.connect("pressed", self, "_on_save_pressed")
	
func _on_save_pressed() -> void:
	emit_signal("confirmed", $VBox/HBox/Name.text, $VBox/Description.text)
	queue_free()
	
	
