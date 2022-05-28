tool
extends PanelContainer
class_name Letter

const FONT = preload("res://assets/LetterFont.tres")
const TEX_FOLDER = "res://assets/Tetriminos/Single Blocks/"

export(CONSTS.LETTER_TYPE) var letter_type setget set_letter_type
export var letter: String setget set_letter
export(CONSTS.COLORS) var color = CONSTS.COLORS.NONE setget set_color
export var click_delay: = 0.1

onready var letter_label: Label = $CenterContainer/Letter
onready var tween: Tween = $Tween

var locked: = false
	
func _ready() -> void:
	pass

func _enter_tree() -> void:
	if Engine.editor_hint:
		randomize()
		set_random_letter()

func set_letter_type(val: int) -> void:
	letter_type = val
	set_random_letter()
	
func set_letter(val: String) -> void:
	if val.empty() and Engine.editor_hint:
		set_random_letter()
		return
	letter = val.to_upper()
	if not is_inside_tree() and not Engine.editor_hint:
		yield(self, "ready")
	$CenterContainer/Letter.text = letter

func set_random_letter() -> void:
	match letter_type:
		CONSTS.LETTER_TYPE.ANY:
			set_letter(get_random_array_element(CONSTS.VALID_LETTERS))
		CONSTS.LETTER_TYPE.VOWEL:
			set_letter(get_random_array_element(CONSTS.VOWELS))
		CONSTS.LETTER_TYPE.NON_VOWEL:
			set_letter(get_random_array_element(CONSTS.NON_VOWELS))
		CONSTS.LETTER_TYPE.JOCKER:
			set_letter(CONSTS.JOKER)
			
func set_color(val: int) -> void:
	color = val
	if not is_inside_tree() and not Engine.editor_hint:
		yield(self, "ready")
	var stylebox: StyleBoxTexture = get_stylebox("panel").duplicate()
	if color == CONSTS.COLORS.NONE:
		stylebox.texture = null
	else:
		stylebox.texture = load(
			TEX_FOLDER.plus_file(_enum_to_filename(color)))
	add_stylebox_override("panel", stylebox)

func animate_expand(expand_by: float = 0.5):
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self,
		"rect_scale",
		rect_scale,
		rect_scale + Vector2(expand_by, expand_by),
		0.5,
		Tween.TRANS_BOUNCE)
# warning-ignore:return_value_discarded
	tween.start()
	yield(tween, "tween_completed")
	return

static func get_random_array_element(array: Array):
	return array[rand_range(0, array.size() - 1)]	

func _enum_to_filename(val: int) -> String:
	return CONSTS.COLORS.keys()[val].capitalize() + ".png"

