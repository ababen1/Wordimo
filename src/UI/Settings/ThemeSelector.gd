extends HBoxContainer

signal theme_selected(new_theme)

const THEMES_PATH: = "res://assets/Themes/"

onready var option_button = $OptionButton
onready var preloader = $ResourcePreloader

var unlocked_themes: Array = ThemeManger.get_unlocked_themes_list()
var all_themes: Array = ThemeManger.themes_list.keys()

func _ready() -> void:
	setup()

func setup() -> void:
	option_button.clear()
	for theme_name in all_themes:
		if theme_name in unlocked_themes:
			option_button.add_item(theme_name.capitalize())
			if theme_name == ThemeManger.current_theme.resource_path.get_file().trim_suffix(".tres"):
				option_button.selected = all_themes.find(theme_name)
		else:
			option_button.add_icon_item(preloader.get_resource("Lock"), "???")
			option_button.set_item_disabled(option_button.get_item_count() - 1, true)

func _on_OptionButton_item_selected(index: int) -> void:
	emit_signal("theme_selected", all_themes[index])
	ThemeManger.current_theme = ThemeManger.get_theme(all_themes[index])
	
