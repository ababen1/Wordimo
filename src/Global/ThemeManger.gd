extends Node

signal theme_changed(new_theme)
signal bg_changed(new_bg)
signal theme_unlocked(theme)
signal bg_unlocked(bg)

const DEFAULT_THEME_NAME = "Default"
const DEFAULT_BG_NAME = "Default"

onready var _themes_preloader = $Themes
onready var _backgrounds_preloader = $Backgrounds
onready var themes_list = Funcs.preloderer_get_dir_list(_themes_preloader, false)
onready var backgrounds_list = Funcs.preloderer_get_dir_list(_backgrounds_preloader)

var current_theme: Theme setget set_current_theme
var current_bg: Texture setget set_current_bg

func _enter_tree() -> void:
	add_to_group("save")

func _ready() -> void:
	self.current_bg = get_background(DEFAULT_BG_NAME)
	self.current_theme = get_theme(DEFAULT_THEME_NAME)
# warning-ignore:return_value_discarded
	get_tree().connect("node_added", self, "_on_node_added_to_tree")

func save(savedata: SaveGame) -> void:
	savedata.data["current_theme"] = current_theme
	savedata.data["bg"] = current_bg

func load(savedata: SaveGame) -> void:
	self.current_theme = savedata.data.get("current_theme", get_theme(DEFAULT_THEME_NAME))
	self.current_bg = savedata.data.get("bg", get_theme(DEFAULT_BG_NAME))
	
func set_current_theme(val: Theme) -> void:
	current_theme = val 
	_set_theme_to_nodes(get_tree().root)
	emit_signal("theme_changed", current_theme)

func set_current_bg(val: Texture) -> void:
	current_bg = val
	emit_signal("bg_changed", current_bg)

func get_unlocked_themes_list() -> Array:
	var unlocked_themes: = []
	for theme in themes_list.keys():
		if theme in GameSaver.current_save.data.get("unlocked_themes", []):
			unlocked_themes.append(theme)
	return unlocked_themes

func get_unlocked_backgrounds_list() -> Array:
	var unlocked_bgs: = []
	for bg in backgrounds_list:
		if bg in GameSaver.current_save.data.get("unlocked_bgs", {}):
			unlocked_bgs.append(bg)
	return unlocked_bgs

func get_background(bg_name: String) -> Texture:
	if bg_name in backgrounds_list.keys():	
		return load(backgrounds_list.get(bg_name)) as Texture
	else:
		return null
	
func get_theme(theme_name: String) -> Theme:
	if theme_name in themes_list.keys():	
		return load(themes_list.get(theme_name)) as Theme
	else:
		return null

func unlock_theme(theme_name: String) -> void:
	if theme_name in themes_list.keys():
		GameSaver.current_save.data["unlocked_themes"].append(theme_name)
		emit_signal("theme_unlocked", theme_name)
		GameSaver.save_progress()

func unlock_bg(bg_name: String) -> void:
	if bg_name in backgrounds_list.keys():
		GameSaver.current_save.data["unlocked_bgs"].append(bg_name)
		emit_signal("bg_unlocked", bg_name)
		GameSaver.save_progress()
		
func unlock_bg_random():
	unlock_bg(Funcs.get_random_array_element(backgrounds_list.keys()))

func unlock_theme_random():
	unlock_theme(Funcs.get_random_array_element(themes_list.keys()))

func _set_theme_to_nodes(root: Node, theme: Theme = current_theme) -> void:
	root.propagate_call("set_theme", [theme], false)
	root.propagate_call("update", [], false)

func _on_node_added_to_tree(node: Node):
	_set_theme_to_nodes(node)
