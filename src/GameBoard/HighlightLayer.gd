extends Node2D

@onready var grid = get_parent()

var cells: = {}

func _draw() -> void:
	for cell in cells:
		draw_rect(
			Rect2(to_global(grid.map_to_local(cell)), grid.cell_size), 
			cells[cell])
