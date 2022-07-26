tool
extends Label

export var level: = 1 setget set_level

func set_level(val: int) -> void:
	level = val
	text = "Level: \n %d" % val
