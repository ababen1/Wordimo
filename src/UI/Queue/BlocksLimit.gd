@tool
extends RichTextLabel

const TEMPLATE = """
[shake rate={shake_rate} level={shake_level}]{blocks} / {max}[/shake]
"""

@export var max_blocks: int: set = set_max_blocks
@export var blocks_in_queue: int: set = set_blocks_in_queue
@export var enable_shake_effect: = true

var DEFAULT_STATE = {
	"shake_rate": 0.0,
	"shake_level": 0.0,
	"color": get_color("default_color"),
	"align": RichTextLabel.ALIGNMENT_CENTER,
}
var state = DEFAULT_STATE: set = set_state

func set_max_blocks(val: int):
	max_blocks = val
	visible = (max_blocks > 0)
	_update_text()	
	
func set_blocks_in_queue(val: int):
	blocks_in_queue = val
	_update_text()

func set_state(val: Dictionary) -> void:
	state = val
	clear()
	push_color(state.get("color", DEFAULT_STATE.color))
	push_align(state.get("align", DEFAULT_STATE.align))
	append_bbcode(TEMPLATE.format({
		"max": max_blocks, 
		"blocks": blocks_in_queue,
		"shake_rate": state.get("shake_rate", DEFAULT_STATE.shake_rate),
		"shake_level": state.get("shake_level", DEFAULT_STATE.shake_level),
		}))

func is_full() -> bool:
	return (max_blocks > 0) and (blocks_in_queue > max_blocks)

func _update_text():
	var rate: int = (max_blocks - blocks_in_queue)
	match rate:
		2:
			self.state = {
				"shake_rate": 15.0 if enable_shake_effect else 0.0,
				"shake_level": 25.0 if enable_shake_effect else 0.0,
				"color": Color.RED.lightened(0.8)
			}
			
		1: 
			self.state = {
				"shake_rate": 25.0 if enable_shake_effect else 0.0,
				"shake_level": 25.0 if enable_shake_effect else 0.0,
				"color": Color.RED.lightened(0.4)
			}
		0:
			self.state = {
				"shake_rate": 30.0 if enable_shake_effect else 0.0,
				"shake_level": 30.0 if enable_shake_effect else 0.0,
				"color": Color.RED
			}
		_:
			self.state = DEFAULT_STATE
			
	
