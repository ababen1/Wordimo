extends Resource
class_name GameResults

@export var difficulty: = ""
@export var score: = 0
@export var level: int = 1
@export var blocks_placed: = 0
@export var blocks_rotated: = 0
@export var highest_combo: = 0
@export var highest_score_in_one_move: = 0
@export var words_written: = []
@export var length: = 0.0

const CHANCE_TO_UNLOCK_BG = 0.7
const CHANCE_TO_UNLOCK_THEME = 0.4

func _init() -> void:
	words_written.clear()

func give_prizes(total_score: int = self.score) -> void:
	var bonus_chance = (total_score % 1000)
	if randf() <= CHANCE_TO_UNLOCK_BG + bonus_chance:
		ThemeManger.unlock_bg_random()
	if randf() <= CHANCE_TO_UNLOCK_THEME + bonus_chance:
		ThemeManger.unlock_theme_random()

func save_to_global_stats(savegame: SaveGame) -> void:
	if not savegame.data.has("games_played"):
		savegame.data["games_played"] = []
	savegame.data["games_played"].append(self)
	
func as_dict() -> Dictionary:
	
	return {
		"difficulty": difficulty,
		"score": score,
		"level": level,
		"blocks_placed": blocks_placed,
		"blocks_rotated": blocks_rotated,
		"highest_combo": highest_combo,
		"highest_score_in_one_move": highest_score_in_one_move,
		"words_written": words_written,
		"length": time_convert(length)
	}
	
#	var dict = {}
#	for prop in get_property_list():
#		if flag_is_enabled(prop.get("usage"), PROPERTY_USAGE_SCRIPT_VARIABLE):
#			dict[prop.name] = get(prop.name)
#	return dict

static func flag_is_enabled(num, flag) -> bool:
	return num && flag != 0

static func time_convert(time_in_sec: int):
	var seconds = time_in_sec%60
# warning-ignore:integer_division
	var minutes = (time_in_sec/60)%60
# warning-ignore:integer_division
# warning-ignore:integer_division
	var hours = (time_in_sec/60)/60

	#returns a string with the format "HH:MM:SS"
	return "%02d:%02d:%02d" % [hours, minutes, seconds]
