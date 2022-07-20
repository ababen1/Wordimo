extends Control

func _ready() -> void:
	print(yield(WordsManger.api.get_definitions_async("godot"), "completed"))
