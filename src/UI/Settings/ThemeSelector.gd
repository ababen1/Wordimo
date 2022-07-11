extends HBoxContainer

signal theme_selected(new_theme)

const THEMES_PATH: = "res://assets/Themes/"

onready var option_button = $OptionButton

var unlocked_themes: Array = ThemeManger.get_unlocked_themes_list()

func _ready() -> void:
	setup()

func setup() -> void:
	option_button.clear()
	for theme_name in ThemeManger.get_unlocked_themes_list():
		option_button.add_item(theme_name.capitalize())
		if ThemeManger.get_theme(theme_name) == ThemeManger.current_theme:
			option_button.selected = unlocked_themes.find(theme_name)

func _on_OptionButton_item_selected(index: int) -> void:
	emit_signal("theme_selected", unlocked_themes[index])
	ThemeManger.current_theme = ThemeManger.get_theme(unlocked_themes[index])
	
