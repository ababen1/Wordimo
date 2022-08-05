extends Control

onready var timer: = $Timer
onready var spawn_block_btn = $MarginContainer/HBox/Button
onready var time_bar: ProgressBar = $MarginContainer/HBox/ProgressBar

var wait_time: float = 1 setget set_wait_time

signal spawn_block(bonus)

func _ready() -> void:
	spawn_block_btn.connect("pressed", self, "_on_spawn_block_pressed")
# warning-ignore:return_value_discarded
	timer.connect("timeout", self, "_on_timeout")
	timer.one_shot = true
	
func _process(_delta: float) -> void:
	time_bar.value = (timer.wait_time - timer.time_left)

func set_wait_time(val: float) -> void:
	wait_time = val
	timer.wait_time = val
	time_bar.max_value = val

func start_timer() -> void:
	timer.start(wait_time)

func _on_timeout() -> void:
	emit_signal("spawn_block", 0)
	start_timer()

func _on_spawn_block_pressed() -> void:
	SFX.play_sound_effect(SFX.SOUNDS.add_block)
	var bonus = ceil(timer.time_left) as int * Score.BONUS_FOR_BLOCK_SPAWN
	print("Bonus: {%f} * {%f} = {%f}" % [timer.time_left, Score.BONUS_FOR_BLOCK_SPAWN, bonus])
	emit_signal("spawn_block", bonus)
	start_timer()
	
func _on_GameBoard_game_started() -> void:
	start_timer()
