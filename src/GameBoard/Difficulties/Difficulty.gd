extends Resource
class_name DifficultyResource

const MAX_BOARD_SIZE = Vector2(13,10)

@export var name: = ""
@export var description: = "": get = get_description
@export var time_limit: = 0.0
@export var queue_size: = 10 # max amount of blocks in the queue. 0 means unlimited
@export var board_size: = Vector2(9,7)
@export var starting_level: int = 1
@export var increase_levels: = true
@export var can_override: = false
@export var is_favorite: = false
@export var min_word_length: int = WordsManger.DEFAULT_MIN_CHARS
@export var is_custom: = false

func get_description() -> String:
	if not description:
		return get_info()
	else:
		return description

func get_info() -> String:
	return """
		Time limit: {time} \n
		Stack size: {stack} \n
		Board size: {board} \n
		Override Allowed: {override} \n
		Starting Level: {level} \n
		Increase Levels: {increase}
		Minimum word length: {min_length} \n
		""".format(
			{"time": time_limit, 
			"queue_size": queue_size,
			"board": board_size,
			"override": "Yes" if can_override else "No",
			"level": starting_level,
			"increase": "Yes" if increase_levels else "No",
			"min_length": min_word_length
		})
