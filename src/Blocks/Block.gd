extends Area2D
class_name Block

signal block_pressed
signal rotate_pressed
signal entered_grid
signal exited_grid

const LETTER = preload("res://src/Letter.tscn")
const COLLISION_LAYER_BOARD = 2
const COLLISION_LAYER_SHAPES = 1

export(CONSTS.COLORS) var color = CONSTS.COLORS.NONE setget set_color

onready var sprite: Sprite = $Sprite

var letters: Array = []
var is_inside_grid: = false setget set_is_inside_grid
var locked: = false setget set_locked

func _ready() -> void:
	setup()
	$CollisionPolygon2D.queue_free()

func _process(_delta: float) -> void:
	self.is_inside_grid = _check_is_inside_grid()
	update()

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if locked:
		return
	if event is InputEventMouse:
		if event.is_action_pressed("right_click"):
			emit_signal("rotate_pressed")

# TEST
func _draw() -> void:
	draw_circle(position, 5, Color.black)

func set_color(val: int):
	color = val
	if not is_inside_tree():
		yield(self, "ready")
	for letter in letters:
		letter.color = val

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
	for child in sprite.get_children():
		if child is Position2D:
			var letter = LETTER.instance()
			child.add_child(letter)
			letter.set_random_letter()
			letter.connect("pressed", self, "_on_pressed")
			letters.append(letter)
	sprite.position = Vector2.ZERO
	collision_layer = COLLISION_LAYER_SHAPES
	collision_mask = COLLISION_LAYER_BOARD
	sprite.self_modulate = Color.transparent if (
		self.color != CONSTS.COLORS.NONE) else Color.white

func rotate_shape() -> void:
	rotation_degrees += 90
	for child in sprite.get_children():
		child.rotation_degrees -= 90
		
func _on_pressed() -> void:
	emit_signal("block_pressed")

func _check_is_inside_grid() -> bool:
	for letter in letters:
		if letter is Letter:
			if letter.get_overlapping_bodies().empty():
				return false
	return true
	
	
