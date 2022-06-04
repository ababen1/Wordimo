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

const VALID_LETTERS: = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
const VOWELS: = ["a", "e", "o", "i", "u"]
const NON_VOWELS: = ["b", "c", "d", "f", "g", "h", "j", "k", "l", "m", "n", "p", "q", "r", "s", "t", "v", "w", "x", "y", "z"]
const JOKER = "★"
const SHAPES: = {
	"I": COLORS.CYAN,
	"J": COLORS.BLUE,
	"L": COLORS.ORANGE,
	"O": COLORS.YELLOW,
	"S": COLORS.GREEN,
	"T": COLORS.PURPLE,
	"Z": COLORS.RED
}

			
