extends Node2D
class_name WordTetrisGame

# add a new block every x seconds
export var add_block_delay: = 7.0 setget set_add_block_delay
export var word_length_multiplier: = 10.0
export var time_limit: = 0.0
export var drag_input: = false 
export var drag_offset: = Vector2.ZERO
export var current_level: = 1 setget set_current_level

signal turn_completed(words_found)
signal game_started
signal game_over(score, stats)
signal total_score_changed(score)
signal level_changed(new_lvl)
signal combo_changed(combo)

onready var tilemap = $GameGrid
onready var _blocks_node = find_node("Blocks")
onready var queue = find_node("Queue")
onready var blocks_timer = queue.get_node("BlocksTimer")
onready var blocks_queue_panel = queue.get_node("QueuePanel")
onready var HUD = $HUD
onready var time_limit_timer: Timer = $TimeLimit

enum GAME_OVER {
	TIMES_UP,
	GAVE_UP,
	QUEUE_FULL
}

var blocks: Array = []
var dragged_block: Block = null setget set_dragged_block
var blocks_factory: = BlocksFactory.new()
var combo: int = 0 setget set_combo
var total_score: = 0 setget set_total_score
var difficulty: DifficultyResource setget set_difficulty
var tip_was_displayed: = false
var _game_started_timestamp_msec: = 0.0
var words_till_next_level = CONSTS.LEVEL_CLEAR_TARGET setget set_words_till_next_level
var game_results: = GameResults.new()
var game_length_seconds: = 0.0

func _ready() -> void:
	blocks_queue_panel.connect("block_clicked", self, "_on_queue_block_clicked")
	blocks_queue_panel.connect("panel_clicked", self, "_on_queue_panel_clicked")
	blocks_queue_panel.connect("queue_full", self, "_on_queue_full")
	blocks_timer.connect("spawn_block", self, "_on_spawn_block")
	tilemap.connect("block_placed", self, "_on_block_placed")
	tilemap.connect("block_placed", blocks_queue_panel, "_on_block_placed")
	HUD.connect("start_new_game", self, "start_new_game")
	HUD.pause_screen.connect("end_game", self, "end_game")
# warning-ignore:return_value_discarded
	time_limit_timer.connect("timeout", self, "_on_timeout")
# warning-ignore:return_value_discarded
	connect("game_over", HUD, "_on_game_over")
	if Funcs.is_mobile():
		drag_input = true
		drag_offset = Vector2(-130,-100)
	else:
		drag_input = GameSaver.current_save.data.get("drag_input", false)
		drag_offset = Vector2.ZERO
	set_difficulty(SceneChanger.message.get("difficulty", DifficultyResource.new()))
	start_new_game()
	
func _process(_delta: float) -> void:
	game_length_seconds += _delta
	update()
	if not is_instance_valid(dragged_block):
		dragged_block = null
	if dragged_block:
		dragged_block.global_position = get_global_mouse_position() + drag_offset
	HUD.set_time_left(time_limit_timer.time_left)
	
	
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
		if event.index > 0 and dragged_block:
			dragged_block.rotate_shape()
			game_results.blocks_rotated += 1 
		else:
			drop_block()

func _handle_mouse_input(event: InputEventMouseButton) -> void:
	if event.button_index == BUTTON_RIGHT and event.pressed:
		if dragged_block:
			dragged_block.rotate_shape()
			game_results.blocks_rotated += 1 
	elif event.button_index == BUTTON_LEFT and dragged_block:
		if not event.pressed and drag_input or (event.pressed and not drag_input):
			drop_block()

func set_difficulty(val: DifficultyResource):
	difficulty = val
	game_results.difficulty = self.difficulty.name if not difficulty.is_custom else "custom"
	tilemap.size = difficulty.board_size
	self.time_limit = difficulty.time_limit
	blocks_queue_panel.set_queue_size(difficulty.queue_size)
	self.current_level = difficulty.starting_level

func set_total_score(val: int):
	total_score = val
	emit_signal("total_score_changed", val)
	
func start_new_game(_difficulty:= self.difficulty) -> void:
	randomize()
	game_results = GameResults.new()
	for prev_game_block in get_tree().get_nodes_in_group("blocks"):
		prev_game_block.queue_free()
	tilemap.reset_board()
	blocks_queue_panel.clear()
	add_block(blocks_factory.get_random_block())
	blocks_timer.wait_time = add_block_delay
	blocks_timer.start_timer()
	if time_limit != 0:
		time_limit_timer.start(time_limit)
	set_difficulty(_difficulty)
	_game_started_timestamp_msec = OS.get_ticks_msec()
	self.total_score = 0
	self.combo = 0
	self.game_length_seconds = 0.0
	emit_signal("game_started", self)

func add_block(block: Block, auto_set_letters: = true) -> void:
	_blocks_node.add_child(block)
	if auto_set_letters:
		for letter in block.letters:
			letter.set_random_letter()
# warning-ignore:return_value_discarded
	block.connect("block_touchscreen_press", self, "_on_block_touchscreen_press", [block])
	blocks_queue_panel.add_block(block)
	
func set_dragged_block(val: Block) -> void:
	if dragged_block:
		dragged_block.z_index -= 1
	dragged_block = val
	if dragged_block:
		dragged_block.z_index += 1	

func set_combo(val: int) -> void:
	combo = val
# warning-ignore:narrowing_conversion
	game_results.highest_combo = max(game_results.highest_combo, combo)
	emit_signal("combo_changed", combo)

func set_add_block_delay(val: float):
	if not is_inside_tree():
		yield(self, "ready")
	add_block_delay = val
	blocks_timer.wait_time = val
	blocks_timer.start_timer()

func set_current_level(val: int) -> void:
	current_level = val
	self.add_block_delay = CONSTS.get_level_speed(current_level)
	game_results.level = current_level
	emit_signal("level_changed", current_level)

func set_words_till_next_level(val: int) -> void:
	words_till_next_level = val
	if words_till_next_level <= 0:
		self.current_level += 1
		words_till_next_level = CONSTS.LEVEL_CLEAR_TARGET

func drop_block(block: Block = dragged_block) -> void:
	if not block:
		return
	self.dragged_block = null
	if tilemap.can_drop_block(block):
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
		var label = $ResourcePreloader.get_resource("WordLabel").instance()
		get_tree().root.add_child(label)
		label.setup(word, global_pos, color, font)

func calculate_score(words: Array):
	var score_this_move: = Score.calculate_turn_score(words, self.current_level, self.combo)
	if words.empty():
		self.combo = 0
	else:
		self.combo += 1
	self.total_score += score_this_move
	if score_this_move > game_results.highest_score_in_one_move:
		game_results.highest_score_in_one_move = score_this_move

func end_game(reason: int = GAME_OVER.GAVE_UP) -> void:
	game_results.length = game_length_seconds
	game_results.score = total_score
	emit_signal("game_over", game_results)
	if reason != GAME_OVER.GAVE_UP:
		game_results.give_prizes()
	GameSaver.save_progress()

func show_tip() -> void:
	var tip: = "Tip: {action}"
	NotificationsLayer.display_message(tip.format({"action": 
		"Tap the screen while dragging a block to rotate it" if Funcs.is_mobile() else "Press right click to rotate a block"}),
		Color.yellow)
	tip_was_displayed = true

func _on_block_placed(block: Block) -> void:
	game_results.blocks_placed += 1
	tilemap._print_board()
	var cells_to_check: = []
	# Mark all the cells in the placed block as cells to check
	for tile in block.letters:
		var tile_cords: Vector2 = tilemap.tiles_data.keys()[
			tilemap.tiles_data.values().find(tile)]
		cells_to_check.append(tile_cords)
	var words_found: Array = tilemap.find_words_in_board(cells_to_check)
	words_found = _validate_words(words_found)
	self.words_till_next_level -= words_found.size()
	if words_found.empty():
		SFX.play_sound_effect(SFX.SOUNDS.place_block)
	calculate_score(words_found)
	print(words_found)
	for word_data in words_found:
		tilemap.clear_cells(word_data.from, word_data.to)
		popup_word(
			word_data.word, 
			block.letters.front().rect_global_position, 
			Color(randf(),randf(),randf()))
		game_results.words_written.append(word_data.word)
	emit_signal("turn_completed", words_found)

func _validate_words(words: Array) -> Array:
	var valid_words: Array = []
	for word_data in words:
		var word_found = WordsManger.find_word(word_data.word, difficulty.min_word_length)
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

func _on_queue_full() -> void:
	end_game(GAME_OVER.QUEUE_FULL)

func _on_queue_panel_clicked() -> void:
	if dragged_block:
		drop_block()

func _on_HUD_start_new_game() -> void:
	start_new_game()

func _on_timeout() -> void:
	end_game(GAME_OVER.TIMES_UP)

func _on_HintTimer_timeout() -> void:
	if !tip_was_displayed and (game_results.blocks_rotated == 0):
		show_tip()

func _on_spawn_block(bonus):
	if self.difficulty.queue_size > 0:
		self.total_score += bonus
	add_block(blocks_factory.get_random_block())
