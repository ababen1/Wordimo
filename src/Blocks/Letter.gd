#tool
extends PanelContainer
class_name Letter

const FONT = preload("res://assets/LetterFont.tres")
const TEX_FOLDER = "res://assets/Tetriminos/Single Blocks/"

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
	
func set_letter(val: String) -> void:
	if val.empty():
		set_random_letter()
		return
	assert(val.length() == 1)
	letter = val.to_upper()
	if not is_inside_tree() and not Engine.editor_hint:
		yield(self, "ready")
	$CenterContainer/Letter.text = letter

func set_random_letter() -> void:
	set_letter(CONSTS.VALID_LETTERS[rand_range(
		0, 
		CONSTS.VALID_LETTERS.length() - 1)])

func set_random_vowel() -> void:
	set_letter(CONSTS.VOWELS[rand_range(
		0, 
		CONSTS.VOWELS.size() - 1)])

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

func _enum_to_filename(val: int) -> String:
	return CONSTS.COLORS.keys()[val].capitalize() + ".png"
