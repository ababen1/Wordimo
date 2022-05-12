extends TileMap

export var size: = Vector2(5,5) setget set_size
export var highlight_color: = Color.greenyellow

var cells_to_highlight: = PoolVector2Array()
var tiles_date: Dictionary = {}

func _ready() -> void:
# warning-ignore:return_value_discarded
	get_parent().connect("block_dropped", self, "_on_block_dropped")

func _process(_delta: float) -> void:
	cells_to_highlight = []
	if get_parent().dragged_block and is_inside_grid(
		get_parent().dragged_block):
		for letter in get_parent().dragged_block.letters:
			if letter is Letter:
				cells_to_highlight.append(
					world_to_map(letter.global_position))
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

func is_inside_grid(block: Block) -> bool:
	for letter in block.letters:
		var letter_cell = world_to_map(letter.global_position)
		if not get_used_rect().has_point(letter_cell):
			return false
	return true

func _on_block_dropped(block: Block) -> void:
	if is_inside_grid(block):
		for letter in block.letters:
			_add_letter_to_grid(letter)

func _add_letter_to_grid(letter: Letter) -> void:
	var letter_cell = world_to_map(letter.global_position)
	tiles_date[letter_cell] = letter
	letter.global_position = to_global(map_to_world(letter_cell)) + cell_size / 2
