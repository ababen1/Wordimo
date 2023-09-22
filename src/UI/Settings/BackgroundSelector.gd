extends AcceptDialog
class_name UIBackgroundSelect

@onready var grid = $ScrollContainer/MarginContainer/BackgroundsGrid

var backgrounds: PackedStringArray = []: set = set_backgrounds
var _button_group = ButtonGroup.new()
var thread = Thread.new()

func _enter_tree() -> void:
	if get_parent() == get_tree().root:
		visible = true

func _exit_tree():
	if not Funcs.is_html():
		thread.wait_to_finish()

func _ready() -> void:
	self.backgrounds = ThemeManger.backgrounds_list.keys() as PackedStringArray
	_button_group.connect("pressed", Callable(self, "_on_bg_btn_pressed"))
# warning-ignore:return_value_discarded
	connect("confirmed", Callable(self, "_on_ok"))

func set_backgrounds(val: PackedStringArray):
	backgrounds = val
	if not Funcs.is_html():
		thread.start(Callable(self, "_display_backgrounds"))
	else:
		_display_backgrounds()

func _display_backgrounds() -> void:
	_clear_backgrounds()
	var unlocked_bgs = ThemeManger.get_unlocked_backgrounds_list()
	for bg in backgrounds:
		var background_btn = $ResourcePreloader.get_resource("BgBtn").instantiate()		
		grid.add_child(background_btn)
		background_btn.texture = ThemeManger.get_background(bg)
		if bg in unlocked_bgs:
			if ThemeManger.current_bg == background_btn.texture:
				background_btn.button_pressed = (true)
			background_btn.group = _button_group
		else:
			background_btn.locked = true
		

func _clear_backgrounds() -> void:
	for child in grid.get_children():
		if child is UIBackgroundBtn:
			child.queue_free()

func _on_bg_btn_pressed(btn: UIBackgroundBtn) -> void:
	if btn.locked:
		return
	ThemeManger.current_bg = btn.texture

func _on_ok():
	GameSaver.save_progress()
