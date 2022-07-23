extends Node

const VALID_LETTERS = "abcdefghijklmnopqrstuvwxyz"
const DEFAULT_MIN_CHARS: = 4 # minimum amount of characters a word should have in order
const WORDS_TEXT_FILE = "res://src/Global/Words.txt"
const SECRET_WORDS = [
	"godot",
	"owo",
	"meme"
]

onready var WORDS_DICT: Dictionary = _create_dict()
onready var api: HTTPRequest = $API

# Creates a dictonary with 26 keys (A-Z) and an array
# of the words in that letter as the value
func _create_dict() -> Dictionary:
	var file: = File.new()
	var error_code: = file.open(WORDS_TEXT_FILE, File.READ)
	assert(error_code == OK)
	var words_dict: Dictionary = {}
	for letter in VALID_LETTERS:
		words_dict[letter.to_upper()] = []
	while not file.eof_reached():
		var current_word: String = file.get_line()
		var current_letter: = current_word[0].to_upper()
		words_dict[current_letter].append(current_word)
	return words_dict

# Returns the words that start with letter		
func get_words_of(letter: String) ->	Array:
	assert(letter.length() == 1 and letter.to_lower() in VALID_LETTERS)
	return WORDS_DICT[letter.to_upper()]

# Finds a valid word inside a text	
func find_word(text: String, min_length: int = DEFAULT_MIN_CHARS) -> String:
	if text.length() < min_length:
		return ""
	if is_valid_word(text, min_length):
		return text
	if text.length() == min_length and not is_valid_word(text, min_length):
		return ""
	var best_word: String
	for start_idx in text.length() - 1:
		var end_idx = min_length
		var current_word = text.substr(start_idx, end_idx)
		var potential_words = get_words_starting_with(current_word)
		while(not potential_words.empty()) and end_idx != text.length():
			best_word = current_word
			end_idx += 1
			current_word = text.substr(start_idx, end_idx)
			potential_words = get_words_starting_with(current_word)
		if is_valid_word(best_word, min_length):
			return best_word
	return ""


static func is_valid_word(word: String, min_chars: = DEFAULT_MIN_CHARS) -> bool:
	return (word.length() >= min_chars) and (
		word.to_lower() in WordsManger.get_words_of(word[0]))

# start_found is useful for preveting the program from continuing to search
# after no results can be found (the dictonary is sorted alphabetically)
static func get_words_starting_with(val: String) -> Array:
	var new_array = []
	var start_found: = false
	for word in WordsManger.get_words_of(val[0]):
		if word.begins_with(val.to_lower()):
			if not start_found:
				start_found = true
			new_array.append(word)
		elif start_found:
			return new_array
	return new_array
