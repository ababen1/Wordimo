tool
extends TextureRect
class_name BlockImg

signal clicked

func _enter_tree() -> void:
	expand = true
	rect_min_size = Vector2(80,80) 
	stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED 
	size_flags_horizontal = SIZE_SHRINK_CENTER
	size_flags_vertical = 0

func _ready() -> void:
	if not Engine.editor_hint:
# warning-ignore:return_value_discarded
		connect("mouse_entered", self, "_on_mouse_entered")

func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("left_click") or (
		event is InputEventScreenTouch and event.is_pressed()):
		accept_event()
		emit_signal("clicked")

func _on_mouse_entered() -> void:
	SFX.play_sound_effect(SFX.SOUNDS.hover)
