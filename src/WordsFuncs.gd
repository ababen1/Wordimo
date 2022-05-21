extends Resource
class_name WordsFuncs

# minimum amount of characters a word should have in order
# to be considered a word. can be raised for higher difficulty
var MIN_CHARS: = 3

func is_valid_word(word: String, min_chars: = MIN_CHARS) -> bool:
	return (word.length() >= min_chars) and (
		word.to_lower() in WordsDatabase.get_words_of(word[0]))

# start_found is useful for preveting the program from continuing to search
# after no results can be found (the dictonary is sorted alphabetically)
func get_words_starting_with(val: String) -> Array:
	var new_array = []
	var start_found: = false
	for word in WordsDatabase.get_words_of(val[0]):
		if word.begins_with(val.to_lower()):
			if not start_found:
				start_found = true
			new_array.append(word)
		elif start_found:
			return new_array
	return new_array

# Finds a valid word inside a text	
func find_word(text: String, min_length: int = MIN_CHARS) -> String:
	if text.length() < min_length:
		return ""
	if is_valid_word(text):
		return text
	if text.length() == min_length and not is_valid_word(text):
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
		if is_valid_word(best_word):
			return best_word
	return ""
