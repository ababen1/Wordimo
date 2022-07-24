extends Node
class_name BlocksFactory

const FOLDER = "res://src/Blocks/"
const BLOCKS = ["I", "J", "L", "O", "S", "T", "Z"]
const LETTER = preload("Letter.tscn")

var blocks_beanbag = BLOCKS.duplicate()

func get_random_block() -> Block:
	if blocks_beanbag.empty():
		blocks_beanbag = BLOCKS.duplicate()
		blocks_beanbag.shuffle()
	var block_type = blocks_beanbag.pop_at(
		rand_range(0, blocks_beanbag.size() - 1))
	return instance_block(block_type)

static func create_custom_block(type: String, letters: Array) -> Block:
	var new_block: Block = instance_block(type)
	for i in letters.size():
		var new_letter: = create_letter(type, letters[i])
		new_block.set_letter(i, new_letter)
	return new_block

static func create_letter(type: String, letter = null) -> Letter:
	var new_letter = LETTER.instance()
	new_letter.color = CONSTS.BLOCK_TYPES[type]
	if letter is String:
		new_letter.letter_type = CONSTS.LETTER_TYPE.ANY
		new_letter.letter = letter
	elif letter is int and letter in CONSTS.LETTER_TYPE.values():
		new_letter.letter_type = letter
		new_letter.set_random_letter()
	return new_letter

static func instance_block(type: String) -> Block:
	type = type.to_upper()
	if type in BLOCKS:
		var block_scene: PackedScene = load(
			FOLDER.plus_file(type + ".tscn"))
		var block = block_scene.instance()
		return block
	else:
		return null
		
