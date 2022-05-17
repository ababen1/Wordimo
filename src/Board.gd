extends Node2D

# add a new block every x seconds
export var add_block_delay: = 1.0 setget set_add_block_delay
export var camera_offset: = Vector2()

onready var tilemap = $GameGrid
onready var _blocks_node = $Blocks
onready var blocks_timer: Timer = $BlocksTimer

var blocks: Array = []
var dragged_block: Block = null
var blocks_factory = BlocksFactory.new()
var words_funcs = WordsFuncs.new()

func _ready() -> void:
	add_block(blocks_factory.get_random_block())

func _process(_delta: float) -> void:
	update()
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
		dragged_block.z_index += 1
#		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	elif dragged_block == block:
		drop_block()

func set_add_block_delay(val: float):
	if not is_inside_tree():
		yield(self, "ready")
	add_block_delay = val
	blocks_timer.wait_time = val

func drop_block(block: Block = dragged_block) -> void:
	dragged_block.z_index -= 1
	dragged_block = null
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
	tilemap.drop_block(block)

# gets a dictonary with rows/columns content and returns only
# the rows/columns that have words in their cotent
func filter_invalid(content: Dictionary) -> Dictionary:
	var new_dict = {}
	for idx in content:
		var word_in_content = words_funcs.find_word(content[idx])
		if word_in_content:
			new_dict[idx] = content[idx]
	return new_dict	

func calculate_score(words: Array):
	words = _validate_words(words)
	print(words)

func _on_BlocksTimer_timeout() -> void:
	if add_block_delay != 0:
		add_block(blocks_factory.get_random_block())
		blocks_timer.start()

func _on_GameGrid_block_placed(block: Block) -> void:
	tilemap._print_board()
	var cells_to_check: = []
	for tile in block.letters:
		var tile_cords: Vector2 = tilemap.tiles_data.keys()[
			tilemap.tiles_data.values().find(tile)]
		cells_to_check.append(tile_cords)
	calculate_score(tilemap.find_words_in_board(cells_to_check))

func _validate_words(words: Array) -> Array:
	var valid_words: Array = []
	for word_data in words:
		var word_found = words_funcs.find_word(word_data.word)
		if word_found:
			valid_words.append(word_found)
	return valid_words
	
func _on_GameGrid_board_size_changed(new_size) -> void:
	if not tilemap:
		yield(self, "ready")
	$Camera2D.global_position = tilemap.get_rect().end / 2 + camera_offset
	update()

func _draw() -> void:
	var rect = tilemap.get_rect()
	draw_rect(tilemap.get_rect(), Color.whitesmoke, false, 5)


