extends Panel

signal block_clicked(block)
signal panel_clicked
signal queue_full

@export var can_scroll: = true: set = set_can_scroll

@onready var _images_container = $VBox/Blocks/VBox
@onready var _scroll_container = _images_container.get_parent()
@onready var _blocks_limit = $VBox/BlocksLimit

var blocks: = {}

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		emit_signal("panel_clicked")

func clear() -> void:
	for block_img in _images_container.get_children():
		if block_img is BlockImg:
			block_img.queue_free()
	blocks = {}
	_blocks_limit.blocks_in_queue = 0

func set_can_scroll(val: bool) -> void:
	can_scroll = val
	_scroll_container.scroll_vertical_enabled = val

func set_queue_size(max_blocks: int):
	if not is_inside_tree():
		await self.ready
	_blocks_limit.max_blocks = max_blocks

func add_block(block: Block) -> void:
	block.reset_position()
	var block_img = BlockImg.new()
	_images_container.add_child(block_img)
	block_img.texture = await block.get_texture()
	blocks[block] = block_img
	block_img.clicked.connect(_on_block_clicked.bind(block))
	_blocks_limit.blocks_in_queue = blocks.size()
	if _blocks_limit.is_full():
		emit_signal("queue_full")

func remove_block(block: Block) -> void:
# warning-ignore:return_value_discarded
	blocks.erase(block)
	_blocks_limit.blocks_in_queue = blocks.size()

func cancel_movement(block: Block) -> void:
	blocks[block].show()

func _on_block_placed(block: Block) -> void:
	remove_block(block)
		
func _on_block_clicked(block: Block):
	blocks[block].hide()
	emit_signal("block_clicked", block)
