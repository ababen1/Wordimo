extends CanvasLayer

signal start_new_game

onready var score = $Score
onready var new_game_btn = $NewGame

func _ready() -> void:
	yield(owner, "ready")
	setup(owner)

func setup(game: WordTetrisGame) -> void:
	game.connect("game_started", score, "_on_game_started")
	game.connect("turn_completed", score, "_on_turn_completed")

func _on_NewGame_pressed() -> void:
	emit_signal("start_new_game")
