tool
extends Button

export var title: String setget set_title
export var description: String setget set_description
export var animate: = true
export var animation_duration: = 0.2
export var focused_rect_scale: = Vector2(1.2, 1.2)

onready var tween = $Tween

func _enter_tree() -> void:
	rect_pivot_offset = rect_size / 2

func _ready() -> void:
	if not Engine.editor_hint:
# warning-ignore:return_value_discarded
		connect("mouse_entered", self, "_on_mouse_entered")
# warning-ignore:return_value_discarded
		connect("mouse_exited", self, "_on_mouse_exited")
# warning-ignore:return_value_discarded
		connect("focus_entered", self, "_on_focus_entered")
# warning-ignore:return_value_discarded
		connect("focus_exited", self, "_on_focus_exited")

func set_title(val: String):
	title = val
	$VBoxContainer/Title.text = val

func set_description(val: String):
	description = val
	$VBoxContainer/Description.bbcode_text = "[center]{text}[/center]".format({
		"text": val
	})

func _on_focus_entered() -> void:
	if tween.is_active():
		yield(tween, "tween_completed")
	_pop_out()

func _on_focus_exited() -> void:
	if not tween.is_active():
		_pop_in()
	else:
		tween.stop_all()
		rect_scale = Vector2.ONE

func _on_mouse_entered() -> void:
	if not has_focus():
		grab_focus()

func _on_mouse_exited() -> void:
	if has_focus():
		release_focus()

func _pop_out() -> void:
	tween.interpolate_property(
		self,
		"rect_scale",
		rect_scale,
		focused_rect_scale,
		animation_duration,
		0,
		Tween.EASE_IN_OUT)
	tween.start()
	yield(tween, "tween_completed")

func _pop_in() -> void:
	tween.interpolate_property(
		self,
		"rect_scale",
		rect_scale,
		Vector2.ONE,
		animation_duration)
	tween.start()
	yield(tween, "tween_completed")
