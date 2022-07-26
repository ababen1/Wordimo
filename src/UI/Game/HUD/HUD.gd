extends CanvasLayer

signal start_new_game

onready var score_label = $Control/HBox/Score
onready var pause_screen: = $PauseScreen
onready var time_left_label: Label = $Control/HBox/TimeLeft
onready var resource_preloader: = $ResourcePreloader
onready var level_label = $Control/HBox/Level
onready var _pause_btn = $Control/VBox/Pause
onready var _new_game_btn = $Control/VBox/NewGame

var time_left: float = 0 setget set_time_left

func _ready() -> void:
	_pause_btn.connect("pressed", pause_screen, "toggle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		pause_screen.toggle()

func set_theme(new: Theme) -> void:
	$Control.propagate_call("set_theme", [new])
	$Control.propagate_call("update")

func set_time_left(val: float):
	time_left = val
	time_left_label.text = (
		"%02d" % (time_left / 60)) + ":" +(
		"%02d" % (int(time_left) % 60))

func _on_game_started(game: WordTetrisGame) -> void:
	time_left_label.visible = (game.time_limit != 0.0)
	level_label.visible = game.difficulty.increase_levels
		
func _on_NewGame_pressed() -> void:
	var confirm: = ConfirmationDialog.new()
	confirm.dialog_text = "Restart?"
# warning-ignore:return_value_discarded
	confirm.get_cancel().connect("pressed", confirm, "queue_free", [], CONNECT_ONESHOT)
	add_child(confirm)
	confirm.popup_centered(Vector2(300,150))
	yield(confirm, "confirmed")
	emit_signal("start_new_game")

func _on_game_over(stats: GameResults) -> void:
	get_tree().paused = true
	var game_over_dialog = resource_preloader.get_resource("GameOverDialog").instance()
	add_child(game_over_dialog)
	game_over_dialog.show_results(stats)
	game_over_dialog.connect("replay", self, "_on_game_over_dialog_replay", [game_over_dialog])

func _on_game_over_dialog_replay(dialog: Control):
	dialog.queue_free()
	get_tree().paused = false
	emit_signal("start_new_game")

func _on_GameBoard_total_score_changed(score) -> void:
	score_label.set_score(score)

func _on_GameBoard_level_changed(new_lvl) -> void:
	level_label.set_level(new_lvl)
