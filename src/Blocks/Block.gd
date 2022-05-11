extends Area2D
class_name Block

signal block_pressed
signal rotate_pressed

const LETTER = preload("res://src/Letter.tscn")

onready var sprite: Sprite = $Sprite
onready var _polygon: = $CollisionPolygon2D

func _ready() -> void:
	setup()

func _input_event(_viewport: Object, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouse:
		if event.is_action_pressed("left_click"):
			emit_signal("block_pressed")
		elif event.is_action_pressed("right_click"):
			emit_signal("rotate_pressed")

func setup():
	# Adding letters
	for child in sprite.get_children():
		if child is Position2D:
			var letter = LETTER.instance()
			child.add_child(letter)
			letter.set_random_letter()
		
func _on_pressed() -> void:
	emit_signal("block_pressed")

func _on_rotate_pressed() -> void:
	emit_signal("rotate_pressed")

func rotate_shape() -> void:
	sprite.rotation_degrees += 90
	_polygon.rotation_degrees += 90
	_polygon.position = sprite.position - sprite.offset
	for child in sprite.get_children():
		child.rotation_degrees -= 90
