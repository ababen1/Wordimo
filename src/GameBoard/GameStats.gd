extends Reference
class_name GameStats

var values: Dictionary = {}
var defaults: Dictionary = {}

func add_stat(stat_name: String, value, default_value):
	values[stat_name] = value
	defaults[stat_name] = default_value

func add_numeric_stat(stat_name: String, value):
	add_stat(stat_name, value, 0)

func update_stat(stat_name: String, new_val):
	values[stat_name] = new_val

func get_value(stat_name: String):
	return values.get(stat_name)

func add_to_stat(stat: String, value):
	update_stat(stat, get_value(stat) + value)

func add_to_array_stat(stat: String, value):
	var array = values.get(stat)
	assert(array is Array)
	if value is Array:
		array.append_array(value)
	else:
		array.append(value)

func reset_stat(stat_name: String):
	assert(values.has(stat_name) and defaults.has(stat_name))
	values[stat_name] = defaults[stat_name]

func reset_all() -> void:
	for stat_name in values.keys():
		reset_stat(stat_name)
