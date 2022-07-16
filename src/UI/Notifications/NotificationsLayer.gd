extends CanvasLayer

const UI_NOTIFICATION = preload("UINotification.tscn")

export var text_color: = Color.white
export var container_path: NodePath

var container

func _ready() -> void:
	if get_node_or_null(container_path):
		container = get_node_or_null(container_path)
	else:
		container = get_child(0)
# warning-ignore:return_value_discarded
	ThemeManger.connect("bg_unlocked", self, "_on_bg_unlocked")
# warning-ignore:return_value_discarded
	ThemeManger.connect("theme_unlocked", self, "_on_theme_unlocked")


func display_message(
	text: String, 
	color: = text_color,
	font: DynamicFont = null) -> UINotification:
		if not is_inside_tree():
			yield(self, "ready")
		var new_notification = UI_NOTIFICATION.instance()
		new_notification.setup(text, color, font)
		container.add_child(new_notification)
		new_notification.connect("dissapear_time_up", new_notification, "queue_free")
		return new_notification

func _on_bg_unlocked(_bg) -> void:
	display_message("New Background Unlocked!")

func _on_theme_unlocked(_theme) -> void:
	display_message("New Theme Unlocked!")

