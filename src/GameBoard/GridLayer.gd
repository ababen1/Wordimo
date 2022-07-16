tool
extends Node2D
class_name GridLayer

var style: BoardStyle
var tile_size:= Vector2(64,64)
var board_size: = Vector2(4,4)

func setup() -> void:
	self.board_size = get_parent().size
	self.tile_size = get_parent().cell_size
	self.style = get_parent().style
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
			if style is BoardStyleTexture:
				var stylebox: = StyleBoxTexture.new()
				stylebox.texture = style.texture if int(x+y) % 2 == 0 else style.alt_texture
				draw_style_box(
					stylebox,rect)
			elif style is BoardStyle:
				draw_rect(
					rect,
					style.color if int(x+y) % 2 == 0 else style.alt_color
				)
