extends PanelContainer

signal block_clicked(block)
signal panel_clicked

var blocks: = {}

func _ready() -> void:
	$VBox/BlockImg.queue_free()

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click"):
		emit_signal("panel_clicked")

func add_block(block: Block) -> void:
	block.reset_position()
	var block_img = BlockImg.new()
	$VBox.add_child(block_img)
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
