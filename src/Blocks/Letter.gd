tool
extends PanelContainer
class_name Letter

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
	if not is_inside_tree():
		yield(self, "ready")
	$CenterContainer/Letter.visible = not(letter_type == CONSTS.LETTER_TYPE.JOCKER)
	$Star.visible = (letter_type == CONSTS.LETTER_TYPE.JOCKER)
	if Engine.editor_hint:
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
	set_letter(CONSTS.pick_random_letter())
			
func set_color(val: int) -> void:
	color = val
	if not is_inside_tree() and not Engine.editor_hint:
		yield(self, "ready")
	var stylebox: StyleBoxTexture = get_stylebox("panel").duplicate()
	if color == CONSTS.COLORS.NONE:
		stylebox.texture = null
	else:
		stylebox.texture = $ResourcePreloader.get_resource(CONSTS.COLORS.keys()[color].capitalize())
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
