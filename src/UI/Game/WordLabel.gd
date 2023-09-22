extends Label
class_name WordLabel

@onready var _tween: Tween = $Tween

func setup(
	word: String, 
	start_global_position: Vector2, 
	color: Color,
	font: FontFile) -> void:
		set_as_top_level(true)
		global_position = start_global_position
		text = word
		if font:
			add_theme_font_override("font", font)
		add_theme_color_override("font_color", color)
		_animate()

# Animates the node flying up in a random direction.
func _animate() -> void:
	# We define a range of 120 degrees for the direction in which the node can fly.
	var angle := randf_range(-PI / 3.0, PI / 3.0)
	# And we calculate an offset vector from that.
	var offset := Vector2.UP.rotated(angle) * 200.0

	# The Tween node takes care of animating the Label's `rect_position` over 0.4 seconds. It's a
	# bit faster than the miss label and uses an ease-out so the animation feels dynamic.
	_tween.interpolate_property(
		self,
		"position",
		position,
		position + offset,
		0.4,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	_tween.start()
	$AnimationPlayer.play("Animate")
