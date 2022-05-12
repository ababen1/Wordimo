#tool
extends Area2D
class_name Letter

const FONT = preload("res://assets/LetterFont.tres")
const TEX_FOLDER = "res://assets/Tetriminos/Single Blocks/"

signal pressed

export var letter: String setget set_letter
export(CONSTS.COLORS) var color = CONSTS.COLORS.NONE setget set_color

var locked: = false
	
func _ready() -> void:
	if not Engine.editor_hint:
# warning-ignore:return_value_discarded
		connect("body_entered", self, "_on_body_entered")

func _enter_tree() -> void:
	if Engine.editor_hint:
		randomize()
		set_random_letter()

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click") and not locked:
		emit_signal("pressed")
	
func set_letter(val: String) -> void:
	if val.empty():
		set_random_letter()
		return
	assert(val.length() == 1)
	letter = val.to_upper()
	if not is_inside_tree() and not Engine.editor_hint:
		yield(self, "ready")
	$Panel/CenterContainer/Letter.text = letter

func set_random_letter() -> void:
	set_letter(CONSTS.VALID_LETTERS[rand_range(
		0, 
		CONSTS.VALID_LETTERS.length() - 1)])

func set_color(val: int) -> void:
	color = val
	if not is_inside_tree() and not Engine.editor_hint:
		yield(self, "ready")
	var stylebox: StyleBoxTexture = $Panel.get_stylebox("panel")
	if color == CONSTS.COLORS.NONE:
		stylebox.texture = null
	else:
		stylebox.texture = load(
			TEX_FOLDER.plus_file(_enum_to_filename(color)))

func _enum_to_filename(val: int) -> String:
	return CONSTS.COLORS.keys()[val].capitalize() + ".png"

func _on_ToolButton_pressed() -> void:
	print(letter)

func _on_body_entered(body: Node):
	pass
