extends Control

func _ready() -> void:
	
	$GameBoard/GameGrid.load_board_state({
		Vector2(0,5): {
			"color": CONSTS.COLORS.RED,
			"letter": "e"
		},
		Vector2(1,5): {
			"color": 5,
			"letter": "b"
		},
		Vector2(2,5): {
			"color": 5,
			"letter": "l"
		},
		Vector2(3,5): {
			"color": 5,
			"letter": "u"
		},
		Vector2(4,5): {
			"color": 5,
			"letter": "e"
		},
		Vector2(5,5): {
			"color": 5,
			"letter": "n"
		},
		
	})
