extends CanvasLayer

signal start_new_game

const BACKGROUNDS_FOLDER = "res://assets/Themes/Backgrounds/"

onready var score = $Control/HBox/Score
onready var _new_game_btn = $Control/VBox/NewGame
onready var _time_left_label: Label = $Control/HBox/TimeLeft
onready var _pause_btn = $Control/VBox/Pause
onready var _pause_screen = $Control/PauseScreen

var time_left: float = 0 setget set_time_left

func _ready() -> void:
	yield(get_parent(), "ready")
	setup(get_parent())
	_pause_btn.connect("pressed", _pause_screen, "toggle")

func set_theme(new: Theme) -> void:
	$Control.propagate_call("set_theme", [new])
	$Control.propagate_call("update")

func setup(game: WordTetrisGame) -> void:
# warning-ignore:return_value_discarded
	game.connect("game_started", score, "_on_game_started")
# warning-ignore:return_value_discarded
	game.connect("turn_completed", score, "_on_turn_completed")

func set_time_left(val: float):
	time_left = val
	_time_left_label.text = (
		"%02d" % (time_left / 60)) + ":" +(
		"%02d" % (int(time_left) % 60))
		
func _on_NewGame_pressed() -> void:
	var confirm: = ConfirmationDialog.new()
	confirm.dialog_text = "Restart?"
	confirm.get_cancel().connect("pressed", confirm, "queue_free", [], CONNECT_ONESHOT)
	add_child(confirm)
	confirm.popup_centered(Vector2(300,150))
	yield(confirm, "confirmed")
	emit_signal("start_new_game")

func _on_times_up(game_results: Dictionary) -> void:
	$TimesUpDialog.show_results(game_results)
