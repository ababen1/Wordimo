extends Label

export var score: float = 0.0 setget set_score
export var manual_block_spawn_bonus: = 0.0

func set_score(val: float):
	score = val
	text = "Score: " + round(score) as String

#func _on_Button_pressed() -> void:
#	# Bonus for spawning a block earlier then usual
#	self.score += manual_block_spawn_bonus
	
func _on_game_started() -> void:
	self.score = 0
