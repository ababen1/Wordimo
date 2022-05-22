extends Label
class_name WordLabel

onready var _tween: Tween = $Tween

func setup(
	word: String, 
	start_global_position: Vector2, 
	color: Color,
	font: DynamicFont) -> void:
		rect_global_position = start_global_position
		text = word
		if font:
			add_font_override("font", font)
		modulate = color

func _ready() -> void:
	_animate()

# Animates the node flying up in a random direction.
func _animate() -> void:
	# We define a range of 120 degrees for the direction in which the node can fly.
	var angle := rand_range(-PI / 3.0, PI / 3.0)
	# And we calculate an offset vector from that.
	var offset := Vector2.UP.rotated(angle) * 60.0

	# The Tween node takes care of animating the Label's `rect_position` over 0.4 seconds. It's a
	# bit faster than the miss label and uses an ease-out so the animation feels dynamic.
	_tween.interpolate_property(
		self,
		"rect_position",
		rect_position,
		rect_position + offset,
		0.4,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	# The fade-out animation starts after a 0.3 seconds delay and lasts 0.1 seconds. 
	# This makes it so the Label quickly fades out and disappears at the end.
	_tween.interpolate_property(
		self, 
		"modulate", 
		modulate, 
		Color.transparent, 
		0.1, 
		Tween.TRANS_LINEAR, 
		Tween.EASE_IN, 
		0.7
	)
	_tween.start()
	$AnimationPlayer.play("Animate")
	yield(_tween, "tween_all_completed")
	$AnimationPlayer.play("fade_out")
	
