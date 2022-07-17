extends WindowDialog

signal confirmed(difficulty_name, difficulty_description)

export var allow_override: = true

onready var _save_btn = $VBox/Save
onready var name_field = $VBox/HBox/Name

var existing_difficulties = []

func _ready() -> void:
	_save_btn.connect("pressed", self, "_on_save_pressed")
	name_field.connect("text_changed", self, "_on_name_text_changed")

func is_taken(difficulty_name: String):
	for difficulty in existing_difficulties:
		if difficulty.name == difficulty_name:
			return true
	return false
	
func _on_save_pressed() -> void:
	emit_signal("confirmed", $VBox/HBox/Name.text, $VBox/Description.text)
	queue_free()

func _on_name_text_changed(new_text: String):
	if not allow_override:
		$VBox/HBox/Error.text = "Already taken" if is_taken(new_text) else ""
		_save_btn.disabled = is_taken(new_text)
