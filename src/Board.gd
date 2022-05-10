extends Node2D

export var size: = Vector2(5,5) setget set_size

onready var tilemap = $TileMap
onready var blocks = $Blocks

var dragged_block: Block = null

func _ready() -> void:
	add_block(BlocksFactory.instance_block("RAND"))
	add_block(BlocksFactory.instance_block("RAND"))

func _process(_delta: float) -> void:
	if dragged_block:
		dragged_block.sprite.global_position = get_global_mouse_position() 

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("rotate_block"):
		if dragged_block:
			dragged_block.rotate_shape()

func set_size(val: Vector2):
	if not is_inside_tree():
		yield(self, "ready")
	size = val
	for y in size.y:
		for x in size.x:
			var tile_idx = 0 if (x+y) % 2 ==0 else 1
			tilemap.set_cell(x,y, tile_idx)

func add_block(block: Block) -> void:
	blocks.add_child(block)
# warning-ignore:return_value_discarded
	block.connect("block_pressed", self, "_on_block_pressed", [block])

func _on_block_pressed(block: Block):
	dragged_block = block
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)

