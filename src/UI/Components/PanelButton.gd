@tool
extends Button
class_name PanelButton

@export var title: String: set = set_title
@export var description: String: set = set_description
@export var panel_icon: Texture2D: set = set_panel_icon
@export var animate: = true
@export var animation_duration: = 0.2
@export var focused_rect_scale: = Vector2(1.1, 1.1)

@onready var tween = $Tween

func _enter_tree() -> void:
	pivot_offset = size / 2

func _ready() -> void:
	if not Engine.is_editor_hint():
# warning-ignore:return_value_discarded
		connect("mouse_entered", Callable(self, "_on_mouse_entered"))
# warning-ignore:return_value_discarded
		connect("mouse_exited", Callable(self, "_on_mouse_exited"))
# warning-ignore:return_value_discarded
		connect("focus_entered", Callable(self, "_on_focus_entered"))
# warning-ignore:return_value_discarded
		connect("focus_exited", Callable(self, "_on_focus_exited"))

func set_title(val: String):
	title = val
	$VBoxContainer/Title.text = val

func set_description(val: String):
	description = val
	$VBoxContainer/Description.text = "[center]{text}[/center]".format({
		"text": val
	})

func set_panel_icon(val: Texture2D):
	panel_icon = val
	$TextureRect.texture = val

func _on_focus_entered() -> void:
	if tween.is_active():
		await tween.tween_completed
	_pop_out()

func _on_focus_exited() -> void:
	if not tween.is_active():
		_pop_in()
	else:
		tween.stop_all()
		scale = Vector2.ONE

func _on_mouse_entered() -> void:
	if not has_focus():
		grab_focus()

func _on_mouse_exited() -> void:
	if has_focus():
		release_focus()

func _pop_out() -> void:
	tween.interpolate_property(
		self,
		"scale",
		scale,
		focused_rect_scale,
		animation_duration,
		0,
		Tween.EASE_IN_OUT)
	tween.start()
	await tween.tween_completed

func _pop_in() -> void:
	tween.interpolate_property(
		self,
		"scale",
		scale,
		Vector2.ONE,
		animation_duration)
	tween.start()
	await tween.tween_completed
