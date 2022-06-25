tool
extends GridContainer
class_name GridExample

export var grid_size: Vector2 setget set_grid_size
export var cell_size: = Vector2(8,8) setget set_cell_size
export var color: = Color.white setget set_color

func set_grid_size(val: Vector2):
	grid_size = Vector2(max(0, val.x) as int, max(0, val.y) as int)
	_update_grid()

func set_cell_size(val: Vector2):
	cell_size = Vector2(max(0, val.x), max(0, val.y))
	_update_grid()

func set_color(val: Color):
	color = val
	_update_grid()
	
func _update_grid() -> void:
	_clear()
# warning-ignore:narrowing_conversion
	columns = max(grid_size.x as int, 1)
	for _i in grid_size.x * grid_size.y:
		var rect: = ColorRect.new()
		rect.color = color
		rect.rect_min_size = cell_size
		add_child(rect)

func _clear() -> void:
	for child in get_children():
		child.queue_free()
