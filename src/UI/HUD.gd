extends CanvasLayer

signal start_new_game

onready var score_label = $Control/HBox/Score
onready var pause_screen: = $PauseScreen
onready var _new_game_btn = $Control/VBox/NewGame
onready var _time_left_label: Label = $Control/HBox/TimeLeft
onready var _pause_btn = $Control/VBox/Pause
onready var resource_preloader: = $ResourcePreloader

var time_left: float = 0 setget set_time_left

func _ready() -> void:
	_pause_btn.connect("pressed", pause_screen, "toggle")

func set_theme(new: Theme) -> void:
	$Control.propagate_call("set_theme", [new])
	$Control.propagate_call("update")

func set_time_left(val: float):
	time_left = val
	_time_left_label.text = (
		"%02d" % (time_left / 60)) + ":" +(
		"%02d" % (int(time_left) % 60))

func _on_game_started(game: WordTetrisGame) -> void:
	score_label.set_score(0)
	_time_left_label.visible = (game.time_limit != 0.0)
		
func _on_NewGame_pressed() -> void:
	var confirm: = ConfirmationDialog.new()
	confirm.dialog_text = "Restart?"
# warning-ignore:return_value_discarded
	confirm.get_cancel().connect("pressed", confirm, "queue_free", [], CONNECT_ONESHOT)
	add_child(confirm)
	confirm.popup_centered(Vector2(300,150))
	yield(confirm, "confirmed")
	emit_signal("start_new_game")

func _on_game_over(score: float, stats: Dictionary) -> void:
	get_tree().paused = true
	var game_over_dialog = resource_preloader.get_resource("GameOverDialog").instance()
	add_child(game_over_dialog)
	game_over_dialog.show_results(score, stats)
	game_over_dialog.connect("replay", self, "_on_game_over_dialog_replay", [game_over_dialog])

func _on_game_over_dialog_replay(dialog: Control):
	dialog.queue_free()
	get_tree().paused = false
	emit_signal("start_new_game")
