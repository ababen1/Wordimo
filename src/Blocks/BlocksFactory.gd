extends Node
class_name BlocksFactory

const FOLDER = "res://src/Blocks/"
const BLOCKS = ["I", "J", "L", "O", "S", "T", "Z"]

static func instance_block(type: String) -> Block:
	type = type.to_upper()
	if type == "RAND":
		type = BLOCKS[rand_range(0, BLOCKS.size() - 1)]
	if type in BLOCKS:
		var block_scene: PackedScene = load(
			FOLDER.plus_file(type + ".tscn"))
		var block = block_scene.instance()
		return block
	else:
		return null
		
