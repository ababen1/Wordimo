extends PanelContainer

signal block_clicked(block)

var blocks: = {}

func _ready() -> void:
	$VBox/BlockImg.queue_free()

func add_block(block: Block) -> void:
	var new_viewport = $Viewport.duplicate()
	add_child(new_viewport)
	new_viewport.add_child(block)
	block.reset_position()
	var block_img = BlockImg.new()
	$VBox.add_child(block_img)
	block_img.texture = new_viewport.get_texture()
	blocks[block] = block_img
	block_img.connect(
		"clicked", 
		self, 
		"_on_block_clicked", 
		[block])

func cancel_movement(block: Block) -> void:
	block.get_parent().call_deferred("remove_child", block)
	call_deferred("add_block", block)
	
func _on_block_clicked(block: Block):
	yield(get_tree(), "idle_frame")
	var viewport = block.get_parent()
	block.get_parent().remove_child(block)
	viewport.queue_free()
	blocks[block].queue_free()
# warning-ignore:return_value_discarded
	blocks.erase(block)
	emit_signal("block_clicked", block)
