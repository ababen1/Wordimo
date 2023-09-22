extends Label
class_name UINotification

const DIRECTIONS = {
	"UP": Vector2.UP,
	"DOWN": Vector2.DOWN,
	"LEFT": Vector2.LEFT,
	"RIGHT": Vector2.RIGHT
}

signal dissapear_time_up

@export var disappear_after: float = 3.5
@export var margin: float = 50
@export var direction = "LEFT" # (String, "UP", "LEFT", "RIGHT", "DOWN")

@onready var timer: Timer = $Timer
@onready var tween: Tween = $Tween
		
func _ready() -> void:
# warning-ignore:return_value_discarded
	timer.connect("timeout", Callable(self, "animate_remove"))
	animate_add()

func setup(message: String, color: = Color.WHITE, font: FontFile = null):
	text = message
	add_theme_color_override("font_color", color)
	if font:
		add_theme_font_override("font", font)
	
func animate_add():
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self, 
		"offset_left", 
		margin * DIRECTIONS[direction].x, 
		0, 
		0.5, 
		Tween.TRANS_BACK)
	
# warning-ignore:return_value_discarded
	tween.start()
	await tween.tween_completed
	timer.start(disappear_after)

func animate_remove():
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self, 
		"modulate", 
		Color.WHITE, 
		Color.TRANSPARENT, 
		0.3)
# warning-ignore:return_value_discarded
	tween.start()
	await tween.tween_completed
	emit_signal("dissapear_time_up")
