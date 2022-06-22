tool
extends Popup

onready var menu = $Menu

func _enter_tree() -> void:
	if Engine.editor_hint or (get_parent() == get_tree().root):
		visible = true

func _get_text_from_id(id: int, lowercase: = true) -> String:
	return menu.get_item_text(menu.get_item_index(id)).to_lower()
