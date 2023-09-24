@tool
extends Node2D
class_name Block

signal block_pressed
signal rotate_pressed
signal entered_grid
signal exited_grid
signal block_touchscreen_press

const LETTER_SCENE = preload("Letter.tscn")

@export var is_special: = false: set = set_is_special

@onready var type: String = name.validate_node_name().rstrip("0123456789")
@onready var sprite: = $Sprite2D
@onready var area: Area2D = $Area2D

var is_inside_grid: = false: set = set_is_inside_grid
var locked: = false: set = set_locked
var letters: Array = []: set = set_letters

func _enter_tree() -> void:
	add_to_group("blocks")

func _ready() -> void:
	setup()
# warning-ignore:return_value_discarded
	area.connect("input_event", Callable(self, "_on_area2D_input_event"))
	
func _process(_delta: float) -> void:
	queue_redraw()

func get_texture() -> Texture2D:
	if Engine.is_editor_hint():
		return
	if not is_inside_tree():
		await self.ready
	await get_tree().idle_frame
	var viewport = SubViewport.new()
	viewport.transparent_bg = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	viewport.size = CONSTS.CELL_SIZE * 4
	var original_parent = get_parent()
	original_parent.remove_child(self)
	original_parent.get_tree().root.add_child(viewport)
	var camera = Camera2D.new()
	viewport.add_child(camera)
	camera.current = true
	viewport.add_child(self)
	var org_pos = position
	position = Vector2.ZERO
	await get_tree().idle_frame
	var image: Image = viewport.get_texture().get_data()
	image.flip_y()
	image.convert(Image.FORMAT_RGBA8)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	get_parent().remove_child(self)
	original_parent.add_child(self)
	position = org_pos
	viewport.queue_free()
	return texture
	
func reset_position() -> void:
	if not is_inside_tree():
		await self.ready
	position = sprite.offset * -1

func set_locked(val: bool):
	locked = val
	area.input_pickable = not locked

func set_is_inside_grid(val: bool):
	if val != is_inside_grid:
		is_inside_grid = val
		if is_inside_grid:
			emit_signal("entered_grid")
		else:
			emit_signal("exited_grid")

func set_is_special(val: bool):
	is_special = val
	for letter in letters:
		if letter is Letter:
			letter.shiny = val

func setup():	
	for i in area.get_child_count():
		area.get_child(i).position = CONSTS.SHAPES_POSITIONS.get(type).get(i)
	
	# Adding letters
	for child in area.get_children():
		if child is CollisionShape2D:
			var letter = LETTER_SCENE.instantiate()
			letter.custom_minimum_size = CONSTS.CELL_SIZE
			letter.size = CONSTS.CELL_SIZE
			letter.pivot_offset = CONSTS.CELL_SIZE / 2
			child.add_child(letter)
			letter.position = -letter.size/2
			letters.append(letter)
			letter.color = CONSTS.BLOCK_TYPES[type]
	sprite.hide()

func set_letters(val: Array):
	for variant in val:
		assert(variant is Letter)
	for i in letters.size():
		letters[i].get_parent().add_child(val[i])
		letters[i].queue_free()
	letters = val

func set_letter(index: int, new_letter: Letter) -> void:
	if not is_inside_tree():
		await self.ready
	if index >= 0 and index < letters.size():
		letters[index].get_parent().add_child(new_letter)
		new_letter.position = letters[index].position
		letters[index].queue_free()
		letters[index] = new_letter
		
func get_letter(index: int) -> Letter:
	return letters[index] if index >= 0 and index < letters.size() else null

func rotate_shape(with_sound: = true) -> void:
	rotation_degrees += 90
	for letter in letters:
		letter.rotation -= 90
	if with_sound:
		SFX.play_sound_effect(SFX.SOUNDS.rotate)

func _on_area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouse:
		if event.is_action_pressed("left_click"):
			emit_signal("block_pressed")
		elif event.is_action_pressed("right_click"):
			emit_signal("rotate_pressed")
	elif event is InputEventScreenTouch and event.is_pressed():
		emit_signal("block_touchscreen_press")
