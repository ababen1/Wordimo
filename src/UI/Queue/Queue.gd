extends VBoxContainer

export var is_canvas_layer: = true setget set_is_canvas_layer

func _ready() -> void:
	self.is_canvas_layer = is_canvas_layer

func set_is_canvas_layer(val: bool, deferred: = true):
	if not is_inside_tree():
		yield(self, "ready")
	if deferred:
		yield(get_tree(), "idle_frame")
	
	is_canvas_layer = val
	if get_parent() is CanvasLayer and not is_canvas_layer:
		_remove_canvas_layer()
	elif not get_parent() is CanvasLayer and is_canvas_layer:
		_add_canvas_layer()
		
func _remove_canvas_layer():
	assert(get_parent() is CanvasLayer)
	var canvas_layer = get_parent()
	var target_parent = canvas_layer.get_parent()
	canvas_layer.remove_child(self)
	target_parent.add_child(self)
	canvas_layer.queue_free()

func _add_canvas_layer():
	var orignal_parent = get_parent()
	get_parent().remove_child(self)
	var canvas_layer = CanvasLayer.new()
	canvas_layer.layer = -1
	canvas_layer.add_child(self)
	orignal_parent.add_child(canvas_layer)
	
	
