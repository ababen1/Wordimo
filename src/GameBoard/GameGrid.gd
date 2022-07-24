extends TileMap

export var size: = Vector2(5,5) setget set_size
export var style: Resource = BoardStyle.new() setget set_style

signal block_placed(block)
signal tile_placed(tile)
signal board_size_changed(new_size)

onready var highlight_layer = $HighlightLayer
onready var grid_layer: = $GridLayer

var tiles_data: Dictionary = {}

func _ready() -> void:
	cell_size = CONSTS.CELL_SIZE
	style = ThemeManger.current_theme.get_board_style()
	grid_layer.setup()
	connect("settings_changed", self, "_on_settings_changed")

func _on_settings_changed() -> void:
	grid_layer.setup()
	
func _process(_delta: float) -> void:
	if not Engine.editor_hint and owner is WordTetrisGame:
		highlight_layer.cells = {}
		if owner.dragged_block and is_inside_grid(owner.dragged_block):
			for letter in owner.dragged_block.letters:
				if letter is Letter:
					if can_place_letter_tile(letter, get_letter_cell(letter)):
						highlight_layer.cells[get_letter_cell(letter)] = style.highlight_color
					else:
						highlight_layer.cells[get_letter_cell(letter)] = style.error_color
		update()
	
func _draw() -> void:
	if not Engine.editor_hint:
		highlight_layer.update()
		grid_layer.update()

func set_style(val: BoardStyle):
	if not is_inside_tree():
		yield(self, "ready")
	style = val
	emit_signal("settings_changed")

func get_used_rect() -> Rect2:
	return Rect2(position, size)

func get_cell_global_position(cell: Vector2):
	return to_global(map_to_world(cell))
	
func reset_board() -> void:
	for cord in tiles_data.keys():
		clear_cell(cord, false)
	
func set_size(val: Vector2):
	if not is_inside_tree():
		yield(self, "ready")
	clear()
	size.x = clamp(val.x, 1, DifficultyResource.MAX_BOARD_SIZE.x)
	size.y = clamp(val.y, 1, DifficultyResource.MAX_BOARD_SIZE.y)
	if not Engine.editor_hint:
		emit_signal("board_size_changed", size)
		$GridLayer.setup()

func is_inside_grid(block: Block) -> bool:
	for letter in block.letters:
		if not get_used_rect().has_point(get_letter_cell(letter)):
			return false
	return true

func get_letter_cell(letter: Letter) -> Vector2:
	return world_to_map(letter.rect_global_position + cell_size / 2)

func can_drop_block(block: Block) -> bool:
	if highlight_layer.cells.empty():
		return false
	else:
		for letter in block.letters:
			if letter is Letter:
				if not can_place_letter_tile(letter, get_letter_cell(letter)):
					return false
		return true

func drop_block(block: Block) -> void:
	if is_inside_grid(block):
		block.locked = true
		for letter in block.letters:
			_add_letter_to_grid(letter)
		emit_signal("block_placed", block)

func get_letter_str_at_cell(cord: Vector2) -> String:
	var letter = tiles_data.get(cord)
	return letter.letter if letter else ""

func get_letter_str_at_position(global_pos: Vector2) -> String:
	var cell = world_to_map(global_pos + cell_size / 2)
	return get_letter_str_at_cell(cell)

func can_place_letter_tile(tile: Letter, cell: Vector2) -> bool:
	if get_parent().difficulty.can_override:
		return true
	else:
		return !get_letter_str_at_cell(cell) or get_letter_str_at_cell(cell) == tile.letter

func is_full() -> bool:
	for y in size.y:
		for x in size.x:
			if not get_letter_str_at_cell(Vector2(x,y)):
				return false
	return true

func clear_cell(cell: Vector2, animate: = true) -> void:
	var tile: Letter = tiles_data.get(cell)
	if tile:
# warning-ignore:return_value_discarded
		tiles_data.erase(cell)
		if animate:
			yield(tile.animate_expand(), "completed")
		tile.queue_free()

func clear_cells(from: Vector2, to: Vector2) -> void:
	var direction = from.direction_to(to)
	var current_cell = from
	while current_cell != to:
		clear_cell(current_cell)
		current_cell += direction
	clear_cell(to)

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, size * cell_size)
	
func find_words_in_board(changed_cells: Array) -> Array:
	var all_words: = []
	var rows_to_check: = []
	var columns_to_check: = []
	for cell in changed_cells:
		if not cell.y in rows_to_check:
			rows_to_check.append(cell.y)
		if not cell.x in columns_to_check:
			columns_to_check.append(cell.x)
	print("checking rows: ", rows_to_check)
	print("checking columns: ", columns_to_check)
	for row in rows_to_check:
		all_words.append_array(
			_check_for_words(Vector2(0, row), Vector2.RIGHT))
	for column in columns_to_check:
		all_words.append_array(
			_check_for_words(Vector2(column, 0), Vector2.DOWN))
	return all_words

func get_letters_between(start: Vector2, end: Vector2) -> Array:
	var direction = start.direction_to(end)
	var current_cell = start
	var letters: = []
	while current_cell != end:
		letters.append(get_letter_str_at_cell(current_cell))
		current_cell += direction
	letters.append(get_letter_str_at_cell(end))
	return letters

func _add_letter_to_grid(letter: Letter) -> void:
	var shape: CollisionShape2D = letter.get_parent()
	var target_cell = world_to_map(shape.global_position)
	# Clear previous letter
	if tiles_data.has(target_cell):
		tiles_data[target_cell].queue_free()
	tiles_data[target_cell] = letter
	shape.global_position = to_global(map_to_world(target_cell) + cell_size / 2)
	emit_signal("tile_placed", letter)

func _check_for_words(cell: Vector2, direction: = Vector2.RIGHT) -> Array:
	var current_cell = cell
	var current_word = ""
	var words: = []
	while Rect2(Vector2.ZERO, size).has_point(current_cell):
		var current_letter: Letter = tiles_data.get(current_cell)
		if current_letter:
			current_word += current_letter.letter
		else:
			_append_word(current_word, words, current_cell, direction)
			current_word = ""
		current_cell += direction
	_append_word(current_word, words, current_cell, direction)
	return words

func _append_word(word: String, array: Array, cell: Vector2, direction: Vector2) -> void:
	if word and word.length() >= get_parent().difficulty.min_word_length:
		array.append({
			"word": word,
			"from": cell - direction * word.length(),
			"to": cell - direction})

func _print_board() -> void:
	var string = ""
	for y in size.y:
		for x in size.x:
			var value = tiles_data.get(Vector2(x,y))
			if value:
				string += (value.letter) + "\t"
			else:
				string += ("□") + "\t"
		string += "\n"
	print(string)
