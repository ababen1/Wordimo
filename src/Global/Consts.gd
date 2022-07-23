extends Node
class_name CONSTS

enum COLORS {
	BLUE, 
	GREEN, 
	CYAN, 
	ORANGE, 
	PURPLE, 
	RED, 
	YELLOW,
	NONE
}

enum LETTER_TYPE {
	ANY, # can be any letter, from A to Z
	VOWEL, # can only be a vowel letter (a, e, o, i, u)
	NON_VOWEL, # can be any letter except vowels
	JOCKER # a letter used to complete words, like a blank tile in scrabble
}
const MAX_LEVEL = 20
const VALID_LETTERS: = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
const VOWELS: = ["a", "e", "o", "i", "u"]
const NON_VOWELS: = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]
const JOKER = "★"
const CELL = 80
const CELL_SIZE = Vector2(CELL, CELL)
const LEVEL_CLEAR_TARGET = 5
const SHAPES_COLORS: = {
	"I": COLORS.CYAN,
	"J": COLORS.BLUE,
	"L": COLORS.ORANGE,
	"O": COLORS.YELLOW,
	"S": COLORS.GREEN,
	"T": COLORS.PURPLE,
	"Z": COLORS.RED
}

const SHAPES_POSITIONS: = {
	"I": {
		0: Vector2(CELL + CELL / 2, -CELL / 2),
		1: Vector2(CELL + CELL / 2, CELL / 2),
		2: Vector2(CELL + CELL / 2, CELL + CELL / 2),
		3: Vector2(CELL + CELL / 2, CELL * 2 + CELL / 2)
	},
	"J":{
		0: Vector2(CELL * 2, CELL * 2 - CELL / 2),
		1: Vector2(CELL * 2, CELL * 2 + CELL / 2),
		2: Vector2(CELL * 3, CELL * 2 + CELL / 2),
		3: Vector2(CELL * 4, CELL * 3 - CELL / 2)
	},
	"L": {
		0: Vector2(CELL * 3 - CELL / 2, CELL / 2),
		1: Vector2(CELL / 2, CELL + CELL / 2),
		2: Vector2(CELL + CELL / 2, CELL + CELL / 2),
		3: Vector2(CELL * 3 - CELL / 2, CELL + CELL / 2)
	},
	"O": {
		0: Vector2(CELL / 2, CELL / 2),
		1: Vector2(CELL * 2 - CELL / 2, CELL / 2),
		2: Vector2(CELL / 2, CELL * 2 - CELL / 2),
		3: Vector2(CELL * 2 - CELL / 2, CELL * 2 - CELL / 2)
	},
	"S": {
		0: Vector2(CELL * 3, CELL * 2 - CELL / 2),
		1: Vector2(CELL * 4, CELL * 2 - CELL / 2),
		2: Vector2(CELL * 2, CELL * 2 + CELL / 2),
		3: Vector2(CELL * 3, CELL * 2 + CELL / 2)
	},
	"T": {
		0: Vector2(CELL * 3, CELL * 2 - CELL / 2),
		1: Vector2(CELL * 2, CELL * 2 + CELL / 2),
		2: Vector2(CELL * 3, CELL * 2 + CELL / 2),
		3: Vector2(CELL * 4, CELL * 2 + CELL / 2)
	},
	"Z": {
		0: Vector2(CELL / 2, CELL / 2),
		1: Vector2(CELL + CELL / 2 ,CELL / 2),
		2: Vector2(CELL + CELL / 2, CELL + CELL / 2),
		3: Vector2(CELL * 2 + CELL / 2, CELL + CELL / 2)
	}
}

const LETTER_CHANCE = {
	"a": 8.167,
	"b": 1.492,
	"c": 2.782,
	"d": 4.253,
	"e": 12.702,
	"f": 2.228,
	"g": 2.015,
	"h": 6.094,
	"i": 6.966,
	"j": 0.153,
	"k": 0.772,
	"l": 4.025,
	"m": 2.406,
	"n": 6.749,
	"o": 7.507,
	"p": 1.929,
	"q": 0.095,
	"r": 5.987,
	"s": 6.327,
	"t": 9.056,
	"u": 2.758,
	"v": 0.978,
	"w": 2.360,
	"x": 0.150,
	"y": 1.974,
	"z": 0.074
}



static func pick_random_letter() -> String:
	return pick_random_item(LETTER_CHANCE)

static func pick_random_vowel_equal_chance() -> String:
	return Funcs.get_random_array_element(VOWELS)

# Items should be a dictonary of 
# Object : Pick Chance
static func pick_random_item(items: Dictionary):
	var chosen_value = null
	if not items.empty():
		# 1. Calculate the overall chance
		var overall_chance: int = 0
		for item in items:
			overall_chance += items[item]
		
		# 2. Generate a random number
		var random_number = randi() % overall_chance
		
		# 3. Pick a random item
		var offset: int = 0
		for item in items:
			if random_number < items[item] + offset:
				chosen_value = item
				break
			else:
				offset += items[item]
	# 4. Return the value
	return chosen_value
			
static func get_level_speed(level: int) -> float:
	return max(MAX_LEVEL - level, 0.1)
