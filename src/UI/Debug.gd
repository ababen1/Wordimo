extends Control

func _ready() -> void:
	WordsManger.api.request_word("om")

#func _process(delta: float) -> void:
#	$GameBoard/GameGrid.load_board_state({
#		Vector2(5,5): {
#			"color": CONSTS.COLORS.RED,
#			"letter": "E"
#		}
#	})
