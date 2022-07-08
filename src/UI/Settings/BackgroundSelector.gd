extends Popup
class_name UIBackgroundSelect

const BACKGROUNDS_PATH = "res://assets/Themes/Backgrounds/"

signal bg_texture_selected(texture)

onready var grid = $ScrollContainer/MarginContainer/BackgroundsGrid

var backgrounds: = [] setget set_backgrounds
var _button_group = ButtonGroup.new()

func _enter_tree() -> void:
	if get_parent() == get_tree().root:
		visible = true

func _ready() -> void:
	self.backgrounds = load_backgrounds()
	_button_group.connect("pressed", self, "_on_bg_btn_pressed")

func set_backgrounds(val: Array):
	backgrounds = val
	_display_backgrounds()

func _display_backgrounds() -> void:
	_clear_backgrounds()
	for texture in backgrounds:
		assert(texture is Texture)
		var background_btn = $ResourcePreloader.get_resource("BgBtn").instance()		
		grid.add_child(background_btn)
		background_btn.texture = texture
		background_btn.group = _button_group
		if GameSaver.current_save.data.get("bg") == texture:
			background_btn.pressed = (true)

func _clear_backgrounds() -> void:
	for child in grid.get_children():
		if child is UIBackgroundBtn:
			child.queue_free()

func _on_bg_btn_pressed(btn: UIBackgroundBtn) -> void:
	GameSaver.current_save.data["bg"] = btn.texture
	EventBus.emit_signal("bg_changed", btn.texture)
	
static func load_backgrounds(path: String = BACKGROUNDS_PATH) -> Array:
	var textures_found: = []
	var dir: Directory = Directory.new()
	if dir.open(path) == OK:
# warning-ignore:return_value_discarded
		dir.list_dir_begin(true)
		var file: = dir.get_next()
		while file != "":
			if ResourceLoader.exists(path.plus_file(file)):
				var resource = load(path.plus_file(file))
				if resource is Texture:
					textures_found.append(resource)
			file = dir.get_next()
	return textures_found
