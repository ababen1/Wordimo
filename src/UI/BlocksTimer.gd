extends HBoxContainer

onready var timer: = $Timer
onready var add_block_btn = $Button
onready var time_bar: ProgressBar = $ProgressBar

func _ready() -> void:
	yield(owner, "ready")
	time_bar.max_value = timer.wait_time

func _process(_delta: float) -> void:
	time_bar.value = (timer.wait_time - timer.time_left)

func _on_timeout() -> void:
	time_bar.value = 0

func _on_Button_pressed() -> void:
	timer.emit_signal("timeout")

func _on_GameBoard_game_started() -> void:
	timer.start()
