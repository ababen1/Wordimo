extends HBoxContainer
class_name UISavedDifficulty

signal play()
signal delete()
signal load_difficulty()
signal favorite_toggled()

var difficulty: DifficultyResource setget set_difficulty
var is_favorite: = false setget set_is_favorite

func _ready() -> void:
	$Play.connect("pressed", self, "emit_signal", ["play"])
	$Load.connect("pressed", self, "emit_signal", ["load_difficulty"])
	$Delete.connect("pressed", self, "emit_signal", ["delete"])
	$Favorite.connect("toggled", self, "set_is_favorite")
	
func set_difficulty(val: DifficultyResource) -> void:
	difficulty = val
	$Name.text = difficulty.name
	set_is_favorite(difficulty.is_favorite)

func set_is_favorite(val: bool) -> void:
	is_favorite = val
	difficulty.is_favorite = val
	$Favorite.set_pressed_no_signal(difficulty.is_favorite)
	$Delete.disabled = is_favorite
	emit_signal("favorite_toggled")
	
