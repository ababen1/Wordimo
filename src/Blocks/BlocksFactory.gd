extends Node
class_name BlocksFactory

const FOLDER = "res://src/Blocks/"
const BLOCKS = ["I", "J", "L", "O", "S", "T", "Z"]

var blocks_beanbag = BLOCKS.duplicate()

func get_random_block() -> Block:
	if blocks_beanbag.empty():
		blocks_beanbag = BLOCKS.duplicate()
		blocks_beanbag.shuffle()
	var block_type = blocks_beanbag.pop_at(
		rand_range(0, blocks_beanbag.size() - 1))
	return instance_block(block_type)

static func instance_block(type: String) -> Block:
	type = type.to_upper()
	if type in BLOCKS:
		var block_scene: PackedScene = load(
			FOLDER.plus_file(type + ".tscn"))
		var block = block_scene.instance()
		return block
	else:
		return null
		
