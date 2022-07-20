extends HTTPRequest

const DICTONARY_API_URL = "https://api.dictionaryapi.dev/api/v2/entries/en/"

signal requst_proccesed(results)

var last_result

func _ready() -> void:
	connect("request_completed", self, "_on_request_completed")

func request_word(word: String):
	request(DICTONARY_API_URL + word)

func get_definitions_async(word: String, count: int = 1) -> Array:
	request_word(word)
	yield(self, "request_completed")
	if not last_result:
		return []
	var all_definitions: Array = _extract_definitions(last_result)
	if count != -1:
		all_definitions.resize(count)
	return all_definitions

func _on_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	if response_code == 200:
		last_result = JSON.parse(body.get_string_from_utf8()).result
	else:
		last_result = null
	emit_signal("requst_proccesed")

func _extract_definitions(results: Array) -> Array:
	var definitions = []
	for result_dict in results:
		var meanings = result_dict.get("meanings")
		if meanings:
			for meaning in meanings:
				for definition in meaning["definitions"]:
					definitions.append(definition["definition"])
	return definitions

