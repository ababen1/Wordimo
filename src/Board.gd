extends Node2D

signal block_dropped(block)

onready var tilemap = $GameGrid
onready var _blocks_node = $Blocks

var blocks: Array = []
var dragged_block: Block = null

func _ready() -> void:
	add_block(BlocksFactory.instance_block("L"))

func _process(_delta: float) -> void:
	if dragged_block:
		dragged_block.global_position = get_global_mouse_position()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if dragged_block:
			dragged_block.rotate_shape()
	elif event.is_action_pressed("left_click"):
		if dragged_block:
			drop_block(dragged_block)

func add_block(block: Block) -> void:
	_blocks_node.add_child(block)
	blocks.append(block)
# warning-ignore:return_value_discarded
	block.connect("block_pressed", self, "_on_block_pressed", [block])
# warning-ignore:return_value_discarded
	block.connect("entered_grid", tilemap, "_on_block_entered", [block])
# warning-ignore:return_value_discarded
	block.connect("exited_grid", tilemap, "_on_block_exited", [block])
	
func _on_block_pressed(block: Block):
	if not dragged_block:
		dragged_block = block
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

func drop_block(block: Block) -> void:
	assert(block == dragged_block)
	dragged_block.locked = true
	dragged_block = null
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	get_viewport().warp_mouse(block.global_position)
	emit_signal("block_dropped", block)
