tool
extends Label

export var score: float = 0.0 setget set_score

func set_score(val: float):
	score = val
	text = "Score: " + round(score) as String

func _on_GameBoard_add_score(score) -> void:
	self.score += score

#func _on_Button_pressed() -> void:
#	# Bonus for spawning a block earlier then usual
#	self.score += 10
