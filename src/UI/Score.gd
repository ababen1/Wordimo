tool
extends Label

export var score: float = 0.0 setget set_score

var combo = 0

func set_score(val: float):
	score = val
	text = "Score: " + round(score) as String

func calculate_score(words: Array) -> float:
	var _score: = 0.0
	for word_data in words:
		_score += word_data.word.length() * 10
	# bonus for having multiple words in one move
	_score *= words.size()
	return score

#func _on_Button_pressed() -> void:
#	# Bonus for spawning a block earlier then usual
#	self.score += 10

func _on_GameBoard_turn_completed(words_found: Array) -> void:
	var points_earned: float = calculate_score(words_found)
	if points_earned == 0:
		self.combo = 0
	else:
		self.combo += 1
	self.score += points_earned
	if combo > 1:
		self.score += pow(10, combo)
	
