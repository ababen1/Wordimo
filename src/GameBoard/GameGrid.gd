tool
extends TileMap

const MAX_SIZE = Vector2(13,10)

export var size: = Vector2(5,5) setget set_size
export var highlight_color: = Color.greenyellow

signal block_placed(block)
signal tile_placed(tile)
signal board_size_changed(new_size)

onready var words_funcs: WordsFuncs = get_parent().words_funcs

var cells_to_highlight: = PoolVector2Array()
var tiles_data: Dictionary = {}

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	if not Engine.editor_hint:
		cells_to_highlight = []
		if owner.dragged_block and is_inside_grid(
			owner.dragged_block):
			for letter in owner.dragged_block.letters:
				if letter is Letter:
					cells_to_highlight.append(
						world_to_map(letter.rect_global_position + cell_size / 2))
		update()
	
func _draw() -> void:
	if not Engine.editor_hint:
		for cell in cells_to_highlight:
			draw_rect(
				Rect2(to_global(map_to_world(cell)), cell_size), 
				highlight_color)
		draw_rect(get_rect(), Color.whitesmoke, false, 5)			

func reset_board() -> void:
	for cord in tiles_data.keys():
		clear_cell(cord, false)
	
func set_size(val: Vector2):
	if not is_inside_tree():
		yield(self, "ready")
	clear()
	size.x = clamp(val.x, 1, MAX_SIZE.x)
	size.y = clamp(val.y, 1, MAX_SIZE.y)
	for y in size.y:
		for x in size.x:
			var tile_idx = 0 if (x+y) % 2 ==0 else 1
			set_cell(x,y, tile_idx)
	if not Engine.editor_hint:
		emit_signal("board_size_changed", size)

func is_inside_grid(block: Block) -> bool:
	for letter in block.letters:
		var letter_cell = world_to_map(letter.rect_global_position + cell_size / 2)
		if not get_used_rect().has_point(letter_cell):
			return false
	return true

func drop_block(block: Block) -> void:
	if is_inside_grid(block):
		block.locked = true
		for letter in block.letters:
			_add_letter_to_grid(letter)
		emit_signal("block_placed", block)

func get_letter_at(cord: Vector2) -> String:
	var letter = tiles_data.get(cord)
	return letter.letter if letter else ""

func is_full() -> bool:
	for y in size.y:
		for x in size.x:
			if not get_letter_at(Vector2(x,y)):
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

func _add_letter_to_grid(letter: Letter) -> void:
	var shape: CollisionShape2D = letter.get_parent()
	var target_cell = world_to_map(shape.global_position)
	if tiles_data.has(target_cell):
		tiles_data[target_cell].queue_free()
	tiles_data[target_cell] = letter
	shape.global_position = to_global(map_to_world(target_cell)) + cell_size / 2
	emit_signal("tile_placed", letter)
	
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
	if word and word.length() >= words_funcs.MIN_CHARS:
		array.append({
			"word": word,
			"from": cell - direction * word.length(),
			"to": cell - direction})

func get_letters_between(start: Vector2, end: Vector2) -> Array:
	var direction = start.direction_to(end)
	var current_cell = start
	var letters: = []
	while current_cell != end:
		letters.append(get_letter_at(current_cell))
		current_cell += direction
	letters.append(get_letter_at(end))
	return letters
