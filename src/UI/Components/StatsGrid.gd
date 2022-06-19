tool
extends GridContainer
class_name StatsGrid

func _enter_tree() -> void:
	columns = 2

func setup(stats: Dictionary) -> void:
	clear()
	for stat in stats:
		add_label(stat.capitalize())
		add_label(str(stats[stat]), SIZE_SHRINK_END + SIZE_EXPAND)
		
func add_label(text: String, size_flags_hor: = 0):
	var new_label = Label.new()
	new_label.size_flags_horizontal = size_flags_hor
	add_child(new_label)
	new_label.text = text

func clear() -> void:
	for child in get_children():
		child.queue_free()
