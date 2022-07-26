extends Control

func _process(delta: float) -> void:
	$GameBoard/GameGrid.load_board_state({
		Vector2(5,5): {
			"color": CONSTS.COLORS.RED,
			"letter": "E"
		}
	})
