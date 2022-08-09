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
		var new_letter: Letter = create_letter(type, letters[i])
		new_block.set_letter(i, new_letter)
	return new_block

static func create_letter(type, letter = null, with_collision_shape: = false):
	var new_letter = LETTER.instance()
	if type is String:
		new_letter.color = CONSTS.BLOCK_TYPES[type]
	elif type is int:
		new_letter.color = type
	if letter is String:
		new_letter.letter_type = CONSTS.LETTER_TYPE.ANY
		new_letter.letter = letter
	elif letter is int and letter in CONSTS.LETTER_TYPE.values():
		new_letter.letter_type = letter
		new_letter.set_random_letter()
	if with_collision_shape:
		var collision_shape = CollisionShape2D.new()
		collision_shape.shape = RectangleShape2D.new()
		collision_shape.shape.extents = CONSTS.CELL_SIZE / 2
		collision_shape.position = CONSTS.CELL_SIZE / 2
		collision_shape.add_child(new_letter)
		new_letter.rect_position = -CONSTS.CELL_SIZE / 2
		return collision_shape
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
		
