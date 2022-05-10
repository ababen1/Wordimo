extends Node2D
class_name Block

signal block_pressed

const LETTER = preload("res://src/Letter.tscn")

onready var sprite: Sprite = $Sprite

func _ready() -> void:
	setup()

# TEST
#func _input(event: InputEvent) -> void:
#	if event is InputEventMouseButton and event.is_pressed():
#		rotate_shape()

func setup():
	for child in sprite.get_children():
		var letter = LETTER.instance()
		child.add_child(letter)
		letter.set_random_letter()
		letter.connect("pressed", self, "_on_pressed")
		
func rotate_shape() -> void:
	sprite.rotation_degrees += 90
	for child in sprite.get_children():
		child.rotation_degrees -= 90

func _on_pressed() -> void:
	emit_signal("block_pressed")
