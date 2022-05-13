extends Node2D

# adds a new block every x seconds
export var add_block_delay: = 1.0 setget set_add_block_delay

onready var tilemap = find_node("GameGrid")
onready var _blocks_node = $Blocks
onready var blocks_timer: Timer = $BlocksTimer

var blocks: Array = []
var dragged_block: Block = null

func _ready() -> void:
	add_block(BlocksFactory.instance_block("RAND"))
	

func _process(_delta: float) -> void:
	if dragged_block:
		dragged_block.global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if dragged_block:
			dragged_block.rotate_shape()

func add_block(block: Block) -> void:
	_blocks_node.add_child(block)
	blocks.append(block)
# warning-ignore:return_value_discarded
	block.connect("block_pressed", self, "_on_block_pressed", [block])
	
func _on_block_pressed(block: Block):
	if not dragged_block:
		dragged_block = block
#		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif dragged_block == block:
		drop_block(dragged_block)

func set_add_block_delay(val: float):
	if not is_inside_tree():
		yield(self, "ready")
	add_block_delay = val
	blocks_timer.wait_time = val

func drop_block(block: Block) -> void:
	assert(block == dragged_block)
	dragged_block = null
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	tilemap.drop_block(block)
#	get_viewport().warp_mouse(block.global_position)

func _on_BlocksTimer_timeout() -> void:
	if add_block_delay != 0:
		add_block(BlocksFactory.instance_block("RAND"))
		blocks_timer.start()
