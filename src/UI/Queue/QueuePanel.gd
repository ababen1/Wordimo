extends PanelContainer

signal block_clicked(block)
signal panel_clicked

export var can_scroll: = true setget set_can_scroll

onready var _images_container = $ScrollContainer/VBox
onready var _scroll_container = $ScrollContainer

var blocks: = {}

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		emit_signal("panel_clicked")

func clear() -> void:
	for block_img in _images_container.get_children():
		block_img.queue_free()
	blocks = {}

func set_can_scroll(val: bool) -> void:
	can_scroll = val
	_scroll_container.scroll_vertical_enabled = val

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

func cancel_movement(block: Block) -> void:
	blocks[block].show()
		
func _on_block_clicked(block: Block):
	blocks[block].hide()
	emit_signal("block_clicked", block)
