extends ConfirmationDialog

func _enter_tree() -> void:
	get_ok().text = "Play Again"
	get_cancel().text = "Return to Menu"

func show_results(game_results: Dictionary) -> void:
	dialog_text = ""
	for result in game_results:
		dialog_text += "{result}: {value}".format({
			"result": result.capitalize(),
			"value": game_results[result]
		})
		dialog_text += "\n"
	popup()
