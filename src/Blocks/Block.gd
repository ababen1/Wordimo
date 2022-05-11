extends Area2D
class_name Block

signal block_pressed
signal rotate_pressed
signal entered_grid
signal exited_grid

const LETTER = preload("res://src/Letter.tscn")
const COLLISION_LAYER_BOARD = 2
const COLLISION_LAYER_SHAPES = 1

onready var sprite: Sprite = $Sprite
onready var _polygon: = $CollisionPolygon2D

var letters: Array = []
var is_inside_grid: = false setget set_is_inside_grid

func _ready() -> void:
	setup()

func _process(_delta: float) -> void:
	self.is_inside_grid = _check_is_inside_grid()
	update()

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouse:
		if event.is_action_pressed("left_click"):
			emit_signal("block_pressed")
		elif event.is_action_pressed("right_click"):
			emit_signal("rotate_pressed")

# TEST
func _draw() -> void:
	draw_circle(position, 5, Color.black)

func set_is_inside_grid(val: bool):
	if val != is_inside_grid:
		is_inside_grid = val
		if is_inside_grid:
			emit_signal("entered_grid")
		else:
			emit_signal("exited_grid")

func setup():
	# Adding letters
	for child in sprite.get_children():
		if child is Position2D:
			var letter = LETTER.instance()
			child.add_child(letter)
			letter.set_random_letter()
			letters.append(letter)
	_polygon.position = sprite.offset
	sprite.position = Vector2.ZERO
	collision_layer = COLLISION_LAYER_SHAPES
	collision_mask = COLLISION_LAYER_BOARD

func rotate_shape() -> void:
	rotation_degrees += 90
	for child in sprite.get_children():
		child.rotation_degrees -= 90
		
func _on_pressed() -> void:
	emit_signal("block_pressed")

func _on_rotate_pressed() -> void:
	emit_signal("rotate_pressed")

func _check_is_inside_grid() -> bool:
	for letter in letters:
		if letter is Letter:
			if letter.get_overlapping_bodies().empty():
				return false
	return true
	
	
