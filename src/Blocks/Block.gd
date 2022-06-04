extends Node2D
class_name Block

signal block_pressed
signal rotate_pressed
signal entered_grid
signal exited_grid

const LETTER_SCENE = preload("Letter.tscn")

onready var type = name.validate_node_name().rstrip("0123456789")
onready var sprite: = $Sprite
onready var area: Area2D = $Area2D

var is_inside_grid: = false setget set_is_inside_grid
var locked: = false setget set_locked
var letters: Array = [] setget set_letters

func _enter_tree() -> void:
	add_to_group("blocks")

func _ready() -> void:
	setup()
# warning-ignore:return_value_discarded
	area.connect("input_event", self, "_on_area2D_input_event")
	
func _process(_delta: float) -> void:
	update()

func get_texture() -> Texture:
	if Engine.editor_hint:
		return
	if not is_inside_tree():
		yield(self, "ready")
	yield(get_tree(), "idle_frame")
	var viewport = Viewport.new()
	viewport.transparent_bg = true
	viewport.render_target_update_mode = Viewport.UPDATE_ALWAYS
	viewport.size = sprite.texture.get_size()
	var original_parent = get_parent()
	original_parent.remove_child(self)
	original_parent.get_tree().root.add_child(viewport)
	viewport.add_child(self)
	yield(get_tree(), "idle_frame")
	var image: Image = viewport.get_texture().get_data()
	image.flip_y()
	image.convert(Image.FORMAT_RGBA8)
	var texture = ImageTexture.new()
	texture.create_from_image(image)
	get_parent().remove_child(self)
	original_parent.add_child(self)
	viewport.queue_free()
	return texture
	
func reset_position() -> void:
	if not is_inside_tree():
		yield(self, "ready")
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

func setup():
	# Adding letters
	for child in area.get_children():
		if child is CollisionShape2D:
			var letter = LETTER_SCENE.instance()
			child.add_child(letter)
			letter.rect_position = -letter.rect_size/2
			letters.append(letter)
			letter.color = CONSTS.SHAPES[type]
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
		yield(self, "ready")
	if index >= 0 and index < letters.size():
		letters[index].get_parent().add_child(new_letter)
		new_letter.rect_position = letters[index].rect_position
		letters[index].queue_free()
		letters[index] = new_letter
		
func get_letter(index: int) -> Letter:
	return letters[index] if index >= 0 and index < letters.size() else null

func rotate_shape(with_sound: = true) -> void:
	rotation_degrees += 90
	for letter in letters:
		letter.rect_rotation -= 90
	if with_sound:
		SFX.play_sound_effect(SFX.SOUNDS.rotate)

func _on_area2D_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event.is_action_pressed("left_click"):
		emit_signal("block_pressed")
	elif event.is_action_pressed("right_click"):
		emit_signal("rotate_pressed")
