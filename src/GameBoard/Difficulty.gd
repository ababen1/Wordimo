extends Resource
class_name DifficultyResource

const MAX_BOARD_SIZE = Vector2(13,10)

export var name: = ""
export var description: = "" setget ,get_description
export var time_limit: = 0.0
export var stack_size: = 10 # max amount of blocks in the queue
export var lose_when_board_full: = true
export var board_size: Vector2
export var speed: float = 7
export var increase_speed: = true

func get_description() -> String:
	if not description:
		return """
		Time limit: {time}, Stack size: {stack}, Board size: {board}
		""".format(
			{"time": time_limit, 
			"stack": stack_size,
			"board": board_size})
	else:
		return description
