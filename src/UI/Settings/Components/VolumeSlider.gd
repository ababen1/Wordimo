@tool
extends HSlider
class_name VolumeSlider

@export var audio_bus_name := "Master" 

@onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	min_value = 0
	max_value = 1
	step = 0.05
	connect("value_changed", Callable(self, "_on_value_changed"))
	value = db_to_linear(AudioServer.get_bus_volume_db(_bus))

func _on_value_changed(value: float) -> void:
	if not Engine.is_editor_hint():
		AudioServer.set_bus_volume_db(_bus, linear_to_db(value))
