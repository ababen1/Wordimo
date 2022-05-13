extends Node2D
class_name Block

signal block_pressed
signal rotate_pressed
signal entered_grid
signal exited_grid

const LETTER = preload("res://src/Letter.tscn")
const COLLISION_LAYER_BOARD = 2
const COLLISION_LAYER_SHAPES = 1

onready var type = name.validate_node_name().rstrip("0123456789")

var is_inside_grid: = false setget set_is_inside_grid
var locked: = false setget set_locked
var letters = []

func _ready() -> void:
	print(type)
	setup()
# warning-ignore:return_value_discarded
	$Area2D.connect("input_event", self, "_on_area2D_input_event")

func _process(_delta: float) -> void:
	self.is_inside_grid = _check_is_inside_grid()
	update()

func get_letters() -> Array:
	return letters

func set_locked(val: bool):
	locked = val
	for letter in letters:
		letter.locked = val

func set_is_inside_grid(val: bool):
	if val != is_inside_grid:
		is_inside_grid = val
		if is_inside_grid:
			emit_signal("entered_grid")
		else:
			emit_signal("exited_grid")

func setup():
	# Adding letters
	for child in $Area2D.get_children():
		if child is CollisionShape2D:
			var letter = LETTER.instance()
			child.add_child(letter)
			letter.rect_position = -letter.rect_size/2
			letter.set_random_letter()
			letters.append(letter)
			letter.color = CONSTS.SHAPES[type]
	$Sprite.hide()

func rotate_shape() -> void:
	rotation_degrees += 90
	for letter in letters:
		letter.rect_rotation -= 90

func _on_area2D_input_event(_viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		emit_signal("block_pressed")
	elif event.is_action_pressed("right_click"):
		emit_signal("rotate_pressed")

func _check_is_inside_grid() -> bool:
	return true
