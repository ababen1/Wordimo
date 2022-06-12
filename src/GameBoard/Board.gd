extends Node2D
class_name WordTetrisGame

# add a new block every x seconds
export var add_block_delay: = 1.0 setget set_add_block_delay
export var word_length_multiplier: = 10.0
export var time_limit: = 0.0
export var drag_input: = false 

signal turn_completed(words_found)
signal game_started
signal times_up(game_results)
signal total_score_changed()

onready var tilemap = $GameGrid
onready var _blocks_node = find_node("Blocks")
onready var blocks_timer: Timer = $Queue/VBox/BlocksTimer/Timer
onready var blocks_queue_panel = $Queue/VBox/QueuePanel
onready var audio_stream: = $AudioStreamPlayer
onready var HUD = $HUD
onready var timer = $Timer

var blocks: Array = []
var dragged_block: Block = null setget set_dragged_block
var blocks_factory: = BlocksFactory.new()
var words_funcs = WordsFuncs.new()
var combo: = 0
var total_score: = 0.0
var block_last_pressed: Block

func _ready() -> void:
	blocks_queue_panel.connect("block_clicked", self, "_on_queue_block_clicked")
	blocks_queue_panel.connect("panel_clicked", self, "_on_queue_panel_clicked")
	blocks_timer.connect("timeout", self, "_on_BlocksTimer_timeout")
	tilemap.connect("block_placed", self, "_on_block_placed")
	HUD.connect("start_new_game", self, "start_new_game")
	timer.connect("timeout", self, "_on_timeout")
	connect("times_up", HUD, "_on_times_up")
	connect("total_score_changed", HUD.score, "set_score")
	if OS.get_name() == "Android" or OS.get_name() == "iOS":
		drag_input = true
	start_new_game()

func _process(_delta: float) -> void:
	update()
	if not is_instance_valid(dragged_block):
		dragged_block = null
	if dragged_block:
		dragged_block.global_position = get_global_mouse_position()
	HUD.set_time_left(timer.time_left)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		_handle_mouse_input(event)
	elif event is InputEventScreenDrag or event is InputEventScreenTouch:
		_handle_touch_input(event)

func _handle_touch_input(event: InputEvent) -> void:
	if event is InputEventScreenDrag and dragged_block:
		if event.is_pressed():
			dragged_block.position = event.position
	elif event is InputEventScreenTouch and not event.pressed:
		if event.index > 0:
			dragged_block.rotate_shape()
		else:
			drop_block()

func _handle_mouse_input(event: InputEventMouseButton) -> void:
	if event.button_index == BUTTON_RIGHT and event.pressed:
		if dragged_block:
			dragged_block.rotate_shape()
	elif event.button_index == BUTTON_LEFT and dragged_block:
		if not event.pressed and drag_input or (event.pressed and not drag_input):
			drop_block()
	
func start_new_game() -> void:
	randomize()
	for prev_game_block in get_tree().get_nodes_in_group("blocks"):
		prev_game_block.queue_free()
	tilemap.reset_board()
	blocks_queue_panel.clear()
	add_block(blocks_factory.get_random_block())
	blocks_timer.start(add_block_delay)
	if time_limit != 0:
		timer.start(time_limit)
	emit_signal("game_started")

func add_block(block: Block, auto_set_letters: = true) -> void:
	_blocks_node.add_child(block)
	if auto_set_letters:
		for letter in block.letters:
			letter.set_random_letter()
	block.connect("block_touchscreen_press", self, "_on_block_touchscreen_press", [block])
	blocks_queue_panel.add_block(block)
	
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
		blocks_queue_panel.cancel_movement(block)	

func popup_word(
	word: String, 
	global_pos: Vector2,
	color: = Color.royalblue,
	font: DynamicFont = null):
		var label = preload("res://src/UI/WordLabel.tscn").instance()
		get_tree().root.add_child(label)
		label.setup(word, global_pos, color, font)

func play_sound(sound: AudioStream) -> void:
	audio_stream.stream = sound
	audio_stream.play()

func calculate_score(words):
	var _score: = 0.0
	for word_data in words:
		_score += word_data.word.length() * word_length_multiplier
	# bonus for having multiple words in one move
	_score *= words.size()
	if _score == 0:
		self.combo = 0
	else:
		self.combo += 1
	self.total_score += _score
	if combo > 1:
		self.total_score += pow(10, combo)
	emit_signal("total_score_changed", total_score)

func _on_BlocksTimer_timeout() -> void:
	if add_block_delay != 0:
		add_block(blocks_factory.get_random_block())
		blocks_timer.start()

func _on_block_placed(block: Block) -> void:
	tilemap._print_board()
	var cells_to_check: = []
	# Mark all the cells in the placed block as cells to check
	for tile in block.letters:
		var tile_cords: Vector2 = tilemap.tiles_data.keys()[
			tilemap.tiles_data.values().find(tile)]
		cells_to_check.append(tile_cords)
	var words_found: Array = tilemap.find_words_in_board(cells_to_check)
	words_found = _validate_words(words_found)
	if not words_found.empty():
		SFX.play_sound_effect(SFX.SOUNDS.clear_word)
	else:
		SFX.play_sound_effect(SFX.SOUNDS.place_block)
	calculate_score(words_found)
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

func _on_queue_block_clicked(block: Block) -> void:
	block.get_parent().remove_child(block)
	add_child(block)
	block.visible = true
	if dragged_block:
		drop_block()
	self.dragged_block = block

func _on_queue_panel_clicked() -> void:
	if dragged_block:
		drop_block()

func _on_HUD_start_new_game() -> void:
	start_new_game()

func _on_timeout() -> void:
	var game_results = {
		"score": self.total_score
	}
	emit_signal("times_up", game_results)
