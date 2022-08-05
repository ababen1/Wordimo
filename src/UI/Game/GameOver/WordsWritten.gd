extends Control

const WORD_LINK = preload("WordLink.tscn")

onready var container: = $MarginContainer/ScrollContainer/VBox

func setup(words: Array) -> void:
	for word in words:
		var word_link = WORD_LINK.instance()
		word_link.word = word
		container.add_child(word_link)
