extends Node2D

# add a new block every x seconds
export var add_block_delay: = 1.0 setget set_add_block_delay
export var camera_offset: = Vector2()

signal turn_completed(words_found)
signal game_started

onready var tilemap = $GameGrid
onready var _blocks_node = find_node("Blocks")
onready var blocks_timer: Timer = $HUD/BlocksTimer/Timer
onready var blocks_queue = $CanvasLayer/Queue

var blocks: Array = []
var dragged_block: Block = null setget set_dragged_block
var blocks_factory = BlocksFactory.new()
var words_funcs = WordsFuncs.new()
var combo: int = 0

func _ready() -> void:
	start_new_game()

func _process(_delta: float) -> void:
	update()
	if dragged_block:
		dragged_block.global_position = get_global_mouse_position()
	
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("right_click"):
		if dragged_block:
			dragged_block.rotate_shape()
	elif event.is_action_pressed("left_click") and dragged_block:
		drop_block()

func start_new_game() -> void:
	randomize()
	for prev_game_block in get_tree().get_nodes_in_group("blocks"):
		prev_game_block.queue_free()
	tilemap.reset_board()
	$CanvasLayer/Queue.clear()
	add_block(blocks_factory.get_random_block())
	emit_signal("game_started")

func add_block(block: Block) -> void:
	_blocks_node.add_child(block)
	blocks_queue.add_block(block)
	
func set_dragged_block(val: Block) -> void:
	if dragged_block:
		dragged_block.z_index -= 1
	dragged_block = val
	if dragged_block:
		dragged_block.z_index += 1	

func set_add_block_delay(val: float):
	if not is_inside_tree():
		yield(self, "ready")
	add_block_delay = val
	blocks_timer.wait_time = val
	blocks_timer.start()

func drop_block(block: Block = dragged_block) -> void:
	self.dragged_block = null
	if tilemap.cells_to_highlight.size() == 4:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)	
		tilemap.drop_block(block)
	else:
		block.get_parent().remove_child(block)
		_blocks_node.add_child(block)
		blocks_queue.cancel_movement(block)	

func popup_word(
	word: String, 
	global_pos: Vector2,
	color: = Color.royalblue,
	font: DynamicFont = null):
		var label = preload("res://src/UI/WordLabel.tscn").instance()
		get_tree().root.add_child(label)
		label.setup(word, global_pos, color, font)

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
	var words_found: Array = tilemap.find_words_in_board(cells_to_check)
	words_found = _validate_words(words_found)
	print(words_found)
	for word_data in words_found:
		tilemap.clear_cells(word_data.from, word_data.to)
		popup_word(word_data.word, block.global_position, Color.white)
	emit_signal("turn_completed", words_found)

func _validate_words(words: Array) -> Array:
	var valid_words: Array = []
	for word_data in words:
		var word_found = words_funcs.find_word(word_data.word)
		if word_found:
			var new_data = {
				"word": word_found
			}
			var direction: Vector2 = word_data["from"].direction_to(word_data["to"])
			new_data["from"] = word_data["from"] + (
				direction * word_data["word"].find(word_found))
			new_data["to"] = new_data["from"] + direction * (word_found.length() - 1)
			valid_words.append(new_data)
	return valid_words
	
func _on_GameGrid_board_size_changed(_new_size) -> void:
	if not tilemap:
		yield(self, "ready")
	update()

func _draw() -> void:
	draw_rect(tilemap.get_rect(), Color.whitesmoke, false, 5)

func _on_Queue_block_clicked(block: Block) -> void:
	block.get_parent().remove_child(block)
	add_child(block)
	block.visible = true
	if dragged_block:
		drop_block()
	self.dragged_block = block

func _on_Queue_panel_clicked() -> void:
	if dragged_block:
		drop_block()


func _on_NewGame_pressed() -> void:
	start_new_game()
