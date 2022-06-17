extends Control

onready var timer: = $Timer
onready var spawn_block_btn = $HBox/Button
onready var time_bar: ProgressBar = $HBox/ProgressBar

var wait_time: float = 1 setget set_wait_time

signal spawn_block

func _ready() -> void:
	spawn_block_btn.connect("pressed", self, "_on_spawn_block_pressed")
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_timeout")
	
func _process(_delta: float) -> void:
	time_bar.value = (timer.wait_time - timer.time_left)

func set_wait_time(val: float) -> void:
	wait_time = val
	timer.wait_time = val
	time_bar.max_value = val

func start() -> void:
	timer.start(wait_time)

func _on_timeout() -> void:
	time_bar.value = 0
	emit_signal("spawn_block")

func _on_spawn_block_pressed() -> void:
	SFX.play_sound_effect(SFX.SOUNDS.add_block)
	timer.emit_signal("timeout")
	
func _on_GameBoard_game_started() -> void:
	timer.start()
