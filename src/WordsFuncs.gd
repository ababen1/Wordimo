extends Resource
class_name WordsFuncs

# minimum amount of characters a word should have in order
# to be considered a word. can be raised for higher difficulty
var MIN_CHARS: = 3

func is_valid_word(word: String, min_chars: = MIN_CHARS) -> bool:
	return (word.length() >= min_chars) and (
		word.capitalize() in WordsList.WORDS.keys())

func get_words_starting_with(val: String) -> Array:
	var new_array = []
	var start_found: = false
	for word in WordsList.WORDS.keys():
		if word.begins_with(val):
			if not start_found:
				start_found = true
			new_array.append(word)
		elif start_found:
			return new_array
	return new_array
	
func find_word(text: String, min_length: int = MIN_CHARS) -> String:
	var best_word: String
	for start_idx in text.length() - 1:
		var end_idx = min_length
		var current_word = text.substr(start_idx, end_idx)
		var potential_words = get_words_starting_with(current_word)
		while(not potential_words.empty()) and end_idx != text.length() - 1:
			if current_word in potential_words:
				best_word = current_word
			end_idx += 1
			current_word = text.substr(start_idx, end_idx)
			potential_words = get_words_starting_with(current_word)
		if best_word:
			return best_word
	return ""
