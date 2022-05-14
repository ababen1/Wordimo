extends TileMap

export var size: = Vector2(5,5) setget set_size
export var highlight_color: = Color.greenyellow
export var camera_offset: = Vector2()

signal board_changed

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
	$Camera2D.global_position = map_to_world(size / 2) + camera_offset

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
		emit_signal("board_changed")

func get_letter_at(cord: Vector2) -> String:
	var letter = tiles_data.get(cord)
	return letter.letter if letter else ""

func _add_letter_to_grid(letter: Letter) -> void:
	var shape: CollisionShape2D = letter.get_parent()
	var target_cell = world_to_map(shape.global_position)
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

func get_row_content(idx: int) -> String:
	var content = ""
	for x in size.x:
		content += get_letter_at(Vector2(x,idx))
	return content

func get_column_content(idx: int) -> String:
	var content = ""
	for y in size.y:
		content += get_letter_at(Vector2(idx,y))
	return content
