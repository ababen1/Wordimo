extends Resource
class_name DifficultyResource

const MAX_BOARD_SIZE = Vector2(13,10)

export var name: = ""
export var description: = "" setget ,get_description
export var time_limit: = 0.0
export var queue_size: = 10 # max amount of blocks in the queue
export var lose_when_board_full: = true
export var lose_when_queue_full: = true
export var board_size: = Vector2(9,7)
export var speed: float = 7
export var increase_speed: = true
export var can_override: = true
export var is_favorite: = false

func get_description() -> String:
	if not description:
		return """
		Time limit: {time}, 
		Stack size: {stack}, 
		Board size: {board}, 
		Override: {override}
		""".format(
			{"time": time_limit, 
			"queue_size": queue_size,
			"board": board_size,
			"override": "On" if can_override else "Off"})
	else:
		return description
