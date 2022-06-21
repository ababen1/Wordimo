extends PanelContainer

signal block_clicked(block)
signal panel_clicked

export var can_scroll: = true setget set_can_scroll

onready var _images_container = $ScrollContainer/VBox
onready var _scroll_container = $ScrollContainer
onready var _blocks_limit = $ScrollContainer/VBox/BlocksLimit

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
		yield(self, "ready")
	_blocks_limit.max_blocks = max_blocks

func add_block(block: Block) -> void:
	block.reset_position()
	var block_img = BlockImg.new()
	_images_container.add_child(block_img)
	block_img.texture = yield(block.get_texture(), "completed")
	blocks[block] = block_img
	block_img.connect(
		"clicked", 
		self, 
		"_on_block_clicked", 
		[block])
	_blocks_limit.blocks_in_queue += 1

func cancel_movement(block: Block) -> void:
	blocks[block].show()
		
func _on_block_clicked(block: Block):
	blocks[block].hide()
	emit_signal("block_clicked", block)
