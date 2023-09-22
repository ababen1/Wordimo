extends LinkButton
class_name WordLink

@export var word: = "": set = set_word

func _ready() -> void:
	if not Engine.is_editor_hint():
# warning-ignore:return_value_discarded
		connect("pressed", Callable(self, "_on_pressed"))

func set_word(val: String) -> void:
	word = val
	text = val.capitalize()

func _on_pressed() -> void:
	$AcceptDialog.display(self.word)
	
