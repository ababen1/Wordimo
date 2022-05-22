extends Control

onready var words_funcs = WordsFuncs.new()



func _on_LineEdit_text_entered(new_text: String) -> void:
	print(words_funcs.find_word(new_text))
