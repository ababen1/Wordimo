tool
extends HSlider
class_name VolumeSlider

export var audio_bus_name := "Master" 

onready var _bus := AudioServer.get_bus_index(audio_bus_name)

func _ready() -> void:
	min_value = 0
	max_value = 1
	step = 0.05
	connect("value_changed", self, "_on_value_changed")
	value = db2linear(AudioServer.get_bus_volume_db(_bus))

func _on_value_changed(value: float) -> void:
	if not Engine.editor_hint:
		AudioServer.set_bus_volume_db(_bus, linear2db(value))
