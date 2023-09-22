@tool
extends Node2D
class_name GridLayer

var style: BoardStyle
var tile_size:= Vector2(64,64)
var board_size: = Vector2(4,4)

func _ready() -> void:
# warning-ignore:return_value_discarded
	ThemeManger.connect("theme_changed", Callable(self, "setup"))

func setup() -> void:
	self.board_size = get_parent().size if get_parent() else board_size
	self.tile_size = get_parent().cell_size if get_parent() else tile_size
	self.style = get_parent().style if get_parent() else ThemeManger.current_theme.get_board_style()
	update()
 
func _draw() -> void:
	if style:
		_draw_board()

func _draw_board() -> void:
	# Draw outline
	draw_rect(get_parent().get_rect(), style.outline_color, false, style.outline_size)			
	
	# Draw tiles
	for y in board_size.y:
		for x in board_size.x:
			var rect: = Rect2(get_parent().get_cell_global_position(Vector2(x,y)), tile_size)
			var stylebox: StyleBox = style.tile if int(x+y) % 2 == 0 else style.tile_alt
			draw_style_box(stylebox, rect)
				
