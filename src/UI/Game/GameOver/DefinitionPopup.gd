extends AcceptDialog

func display(word: String):
	WordsManger.api.connect(
		"requst_proccesed", 
		self, 
		"_on_api_completed", [], CONNECT_ONESHOT)
	WordsManger.api.request_word(word)
	self.dialog_text = "Getting definition..."
	self.window_title = word
	popup()

func _on_api_completed(result: Dictionary) -> void:
	if result.success:
		self.dialog_text = result.definition.front()
	else:
		if result.response_code == 404:
			self.dialog_text = "No definitions found for this word. Tell ben to remove it."
		else:
			self.dialog_text = "Error while fetching definition :(\n" + str(result)
