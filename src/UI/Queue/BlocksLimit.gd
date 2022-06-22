tool
extends RichTextLabel

const TEMPLATE = "[center]{blocks} / {max}[/center]"

export var max_blocks: int setget set_max_blocks
export var blocks_in_queue: int setget set_blocks_in_queue

func set_max_blocks(val: int):
	max_blocks = val
	visible = (max_blocks != 0)
	_update_text()	
	
func set_blocks_in_queue(val: int):
	blocks_in_queue = val
	_update_text()

func is_full() -> bool:
	return (max_blocks >= 1) and (blocks_in_queue > max_blocks)

func _update_text():
	bbcode_text = TEMPLATE.format({
		"max": max_blocks, 
		"blocks": blocks_in_queue})
