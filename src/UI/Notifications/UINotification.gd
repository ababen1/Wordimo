extends Label
class_name UINotification

const DIRECTIONS = {
	"UP": Vector2.UP,
	"DOWN": Vector2.DOWN,
	"LEFT": Vector2.LEFT,
	"RIGHT": Vector2.RIGHT
}

signal dissapear_time_up

export var disappear_after: float = 3.5
export var margin: float = 50
export(String, "UP", "LEFT", "RIGHT", "DOWN") var direction = "LEFT"

onready var timer: Timer = $Timer
onready var tween: Tween = $Tween
		
func _ready() -> void:
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "animate_remove")
	animate_add()

func setup(message: String, color: = Color.white, font: DynamicFont = null):
	text = message
	add_color_override("font_color", color)
	if font:
		add_font_override("font", font)
	
func animate_add():
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self, 
		"margin_left", 
		margin * DIRECTIONS[direction].x, 
		0, 
		0.5, 
		Tween.TRANS_BACK)
	
# warning-ignore:return_value_discarded
	tween.start()
	yield(tween, "tween_completed")
	timer.start(disappear_after)

func animate_remove():
# warning-ignore:return_value_discarded
	tween.interpolate_property(
		self, 
		"modulate", 
		Color.white, 
		Color.transparent, 
		0.3)
# warning-ignore:return_value_discarded
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("dissapear_time_up")
