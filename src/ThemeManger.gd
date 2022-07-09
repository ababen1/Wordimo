extends Node

const DEFAULT_THEME = preload("res://assets/Themes/Default.tres")

signal theme_changed(new_theme)

var current_theme: Theme setget set_current_theme

func _enter_tree() -> void:
	add_to_group("save")

func _ready() -> void:
	get_tree().connect("node_added", self, "_on_node_added_to_tree")

func save(savedata: SaveGame) -> void:
	savedata.data["theme"] = current_theme

func load(savedata: SaveGame) -> void:
	self.current_theme = savedata.data.get("theme", DEFAULT_THEME)
	
func set_current_theme(val: Theme) -> void:
	current_theme = val 
	_set_theme_to_nodes(get_tree().root)
	emit_signal("theme_changed", current_theme)

func set_theme_color(color: Color) -> void:
	for stylebox_type in current_theme.get_stylebox_types():
		for stylebox_name in current_theme.get_stylebox_list(stylebox_type):
			var current_stylebox: StyleBox = current_theme.get_stylebox(stylebox_name, stylebox_type)
			if current_stylebox.get("modulate_color"):
				current_stylebox.set("modulate_color", color)

func _set_theme_to_nodes(root: Node, theme: Theme = current_theme) -> void:
	root.propagate_call("set_theme", [theme], false)
	root.propagate_call("update", [], false)

func _on_node_added_to_tree(node: Node):
	_set_theme_to_nodes(node)
		
