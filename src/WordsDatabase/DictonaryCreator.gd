extends Node

const WORDS_FILE = "res://src/WordsDatabase/words.txt"
const VALID_LETTERS = "abcdefghijklmnopqrstuvwxyz"

var WORDS_DICT: Dictionary = _create_dict()

# Creates a dictonary with 26 keys (A-Z) and an array
# of the words in that letter as the value
func _create_dict() -> Dictionary:
	var file: = File.new()
	var error_code: = file.open(WORDS_FILE, File.READ)
	assert(error_code == OK)
	var words_dict: Dictionary = {}
	for letter in VALID_LETTERS:
		words_dict[letter.to_upper()] = []
	while not file.eof_reached():
		var current_word: = file.get_line()
		var current_letter: = current_word[0].to_upper()
		words_dict[current_letter].append(current_word)
	return words_dict

# Returns the words that start with letter		
func get_words_of(letter: String) ->	Array:
	assert(letter.length() == 1 and letter.to_lower() in VALID_LETTERS)
	return WORDS_DICT[letter.to_upper()]
