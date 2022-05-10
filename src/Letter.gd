#tool
extends Node2D

const FONT = preload("res://assets/LetterFont.tres")
const VALID_LETTERS = "abcdefghijklmnopqrstuvwxyz"
const TEX_FOLDER = "res://assets/Tetriminos/Single Blocks/"
enum COLORS {
	BLUE, 
	GREEN, 
	CYAN, 
	ORANGE, 
	PURPLE, 
	RED, 
	YELLOW,
	NONE}

export var letter: String setget set_letter
export(COLORS) var color = COLORS.NONE setget set_color

signal pressed
	
func _ready() -> void:
	if not Engine.editor_hint:
# warning-ignore:return_value_discarded
		$Panel/ToolButton.connect("pressed", self, "_on_press")

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
	$Panel/ToolButton.text = letter

func set_random_letter() -> void:
	set_letter(VALID_LETTERS[rand_range(0, VALID_LETTERS.length() - 1)])

func set_color(val: int) -> void:
	color = val
	if not is_inside_tree() and not Engine.editor_hint:
		yield(self, "ready")
	var stylebox: StyleBoxTexture = $Panel.get_stylebox("panel")
	if color == COLORS.NONE:
		stylebox.texture = null
	else:
		stylebox.texture = load(
			TEX_FOLDER.plus_file(_enum_to_filename(color)))

func _enum_to_filename(val: int) -> String:
	return COLORS.keys()[val].capitalize() + ".png"

func _on_ToolButton_pressed() -> void:
	print(letter)

func _on_press() -> void:
	emit_signal("pressed")
