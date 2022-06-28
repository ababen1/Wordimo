extends GridContainer

func get_board_size() -> Vector2:
	return Vector2($GridContainer/X.value, $GridContainer/Y.value)
func set_board_size(size: Vector2) -> void:
	$GridContainer/X.value = size.x
	$GridContainer/Y.value = size.y

func is_valid() -> bool:
	var _board_size = get_board_size()
	return _board_size.x * _board_size.y > 4 

func _enter_tree() -> void:
	$GridContainer/X.max_value = DifficultyResource.MAX_BOARD_SIZE.x
	$GridContainer/Y.max_value = DifficultyResource.MAX_BOARD_SIZE.y
	
func _update_grid_example():
	$BoardExample.grid_size = Vector2($GridContainer/X.value, $GridContainer/Y.value)

func _on_X_value_changed(value: float) -> void:
	_update_grid_example()

func _on_Y_value_changed(value: float) -> void:
	_update_grid_example()
