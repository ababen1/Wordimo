extends Control

onready var words_funcs = WordsFuncs.new()
onready var game = $GameBoard

func _ready() -> void:
	pass

func _on_LineEdit_text_entered(new_text: String) -> void:
	print(words_funcs.find_word(new_text))
