@tool
extends Label

@export var score: float = 0.0: set = set_score

func set_score(val: float):
	score = val
	text = "Score: " + round(score) as String
