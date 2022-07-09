extends HBoxContainer

signal theme_selected(new_theme)

const THEMES_PATH: = "res://assets/Themes/"

onready var option_button = $OptionButton

var themes = {} 

func _ready() -> void:
	setup()

func setup() -> void:
	self.themes = load_themes()
	option_button.clear()
	for theme_name in themes:
		option_button.add_item(theme_name.capitalize())
		if themes[theme_name] == ThemeManger.current_theme:
			option_button.selected = themes.keys().find(theme_name)
		
static func load_themes(path: String = THEMES_PATH) -> Dictionary:
	var themes_found: = {}
	var dir: Directory = Directory.new()
	if dir.open(path) == OK:
# warning-ignore:return_value_discarded
		dir.list_dir_begin(true)
		var file: = dir.get_next()
		while file != "":
			if ResourceLoader.exists(path.plus_file(file)):
				var resource = load(path.plus_file(file))
				if resource is Theme:
					themes_found[file.trim_suffix(".tres")] = resource
			file = dir.get_next()
	return themes_found

func _on_OptionButton_item_selected(index: int) -> void:
	emit_signal("theme_selected", themes.values()[index])
	ThemeManger.current_theme = themes.values()[index]
	
