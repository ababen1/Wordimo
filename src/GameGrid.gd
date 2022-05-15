extends TileMap

export var size: = Vector2(5,5) setget set_size
export var highlight_color: = Color.greenyellow

signal board_content_changed
signal board_size_changed(new_size)

var cells_to_highlight: = PoolVector2Array()
var tiles_data: Dictionary = {}

func _ready() -> void:
	pass
	
func _process(_delta: float) -> void:
	cells_to_highlight = []
	if owner.dragged_block and is_inside_grid(
		owner.dragged_block):
		for letter in owner.dragged_block.letters:
			if letter is Letter:
				cells_to_highlight.append(
					world_to_map(letter.rect_global_position + cell_size / 2))
	update()
					
func _draw() -> void:
	for cell in cells_to_highlight:
		draw_rect(
			Rect2(to_global(map_to_world(cell)), cell_size), 
			highlight_color)
	
func set_size(val: Vector2):
	if not is_inside_tree():
		yield(self, "ready")
	size = val
	for y in size.y:
		for x in size.x:
			var tile_idx = 0 if (x+y) % 2 ==0 else 1
			set_cell(x,y, tile_idx)
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
		emit_signal("board_content_changed")

func get_letter_at(cord: Vector2) -> String:
	var letter = tiles_data.get(cord)
	return letter.letter if letter else ""

func _add_letter_to_grid(letter: Letter) -> void:
	var shape: CollisionShape2D = letter.get_parent()
	var target_cell = world_to_map(shape.global_position)
	if tiles_data.has(target_cell):
		tiles_data[target_cell].queue_free()
	tiles_data[target_cell] = letter
	shape.global_position = to_global(map_to_world(target_cell)) + cell_size / 2

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

func get_row_content(idx: int) -> Array:
	var content: = {}
	for x in size.x:
		content[Vector2(x,idx)] = get_letter_at(Vector2(x,idx))
	return _arrange_content(content)

func get_column_content(idx: int) -> Array:
	var content: = {}
	for y in size.y:
		content[Vector2(idx,y)] = get_letter_at(Vector2(idx,y))
	return _arrange_content(content)

# Returns an array with all the words in the given row/column content
# including their start and end position
func _arrange_content(content: Dictionary) -> Array:
	# Create an array with all the words in the row,
	# including their starting and ending position
	var current_word = ""
	var current_word_start = null
	var prev_cord: Vector2 = content.keys().front()
	var content_array = []
	for current_cord in content.keys():
		var current_letter = content[current_cord]
		if current_letter:
			if not current_word_start:
				current_word_start = current_cord
			current_word += current_letter
		elif current_word:
			content_array.append({
				"word": current_word,
				"from": current_word_start,
				"to": prev_cord
			})
			current_word = ""
			current_word_start = null
		# in case we reached the last cord and a word was found
		if current_cord == content.keys().back() and current_word:
			content_array.append({
				"word": current_word,
				"from": current_word_start,
				"to": content.keys().back()
			})
		prev_cord = current_cord
	return content_array

func get_rect() -> Rect2:
	return Rect2(Vector2.ZERO, size * cell_size)

# Returns a dict with the keys as the idx of rows that have letters in them
# and values as the content in that row
func get_rows_with_content() -> Dictionary:
	var rows: = {}
	for current_idx in size.y:
		var row_content = get_row_content(current_idx)
		if not row_content.empty():
			rows[current_idx] = row_content
	return rows

# Same as above but for columns
func get_columns_with_content() -> Dictionary:
	var columns: = {}
	for current_idx in size.x:
		var column_content = get_column_content(current_idx)
		if not column_content.empty():
			columns[current_idx] = column_content
	return columns
	
func find_words_in_board() -> Array:
	var all_words: = []
	for cord in tiles_data.keys():
		var row_words: = get_row_content(cord.y)
		var column_words: = get_column_content(cord.x)
		all_words.append_array(row_words)
		all_words.append_array(column_words)
	return all_words
		
	
