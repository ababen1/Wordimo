extends Theme
class_name WordTetrisTheme

const NODE_TYPE_GRID = "GameGrid"

export var primary_color: Color setget set_primary_color
export var secondary_color: Color setget set_secondary_color

func set_primary_color(val: Color):
	primary_color = val
	if not has_stylebox("tile", NODE_TYPE_GRID):
		create_tile_from_color("tile", primary_color)
	emit_changed()

func set_secondary_color(val: Color):
	secondary_color = val
	if not has_stylebox("tile_alt", NODE_TYPE_GRID):
		create_tile_from_color("tile_alt", secondary_color)
	emit_changed()

		

func get_board_style() -> BoardStyle:
	var tile = get_stylebox("tile", NODE_TYPE_GRID) if has_stylebox("tile", NODE_TYPE_GRID) else null
	var tile_alt = get_stylebox("tile_alt", NODE_TYPE_GRID) if has_stylebox("tile_alt", NODE_TYPE_GRID) else null
	var board_style: BoardStyle = BoardStyle.new()
	board_style.primary_color = primary_color
	board_style.secondary_color = secondary_color
	board_style.outline_color = get_color("outline_color", NODE_TYPE_GRID)
	board_style.highlight_color = get_color("highlight_color", NODE_TYPE_GRID)
	board_style.error_color = get_color("error_color", NODE_TYPE_GRID)
	board_style.outline_size = get_constant("outline_size", NODE_TYPE_GRID)
	if not tile or not tile_alt:
		board_style.create_tiles_from_colors()
	else:
		board_style.tile = tile
		board_style.tile_alt = tile_alt
	return board_style

func create_tile_from_color(tile_prop_name: String, color: Color) -> void:
	var tile = StyleBoxFlat.new()
	tile.bg_color = color
	set_stylebox(tile_prop_name, NODE_TYPE_GRID, tile)
	

