extends Node
class_name Score

"""

"""
const LETTERS_VALUES = {
	 ["E", "A", "I", "O", "N", "R", "T", "L", "S", "U"]: 	1,	
	 ["D", "G"]: 											2,	
	 ["B", "C", "M", "P"]: 									3,	
	 ["F", "H", "V", "W", "Y"]:		                       	4,	
	 ["K"]:                                            		5,	
	 ["J", "X"]:                                       		8,	
	 ["Q", "Z"]:											10,	
}
const BONUS_FOR_BLOCK_SPAWN = 1 # 1 point per seconds skipped

static func get_letter_value(letter: String) -> int:
	for letter_group in LETTERS_VALUES.keys():
		if letter.to_upper() in letter_group:
			return LETTERS_VALUES[letter_group]
	return 0

static func calculate_word_value(word: String) -> int:
	var word_value: int = 0
	for letter in word:
		word_value += get_letter_value(letter)
	return word_value

static func calculate_turn_score(words_written: Array, level: int) -> int:
	var score: int = 0
	for word in words_written:
		score += calculate_word_value(word) * word.length() * level
	return score
