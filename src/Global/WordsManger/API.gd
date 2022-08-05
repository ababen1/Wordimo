extends HTTPRequest
class_name DictonaryAPI

const DICTONARY_API_URL = "https://api.dictionaryapi.dev/api/v2/entries/en/"

signal requst_proccesed(results)

func _ready() -> void:
# warning-ignore:return_value_discarded
	connect("request_completed", self, "_on_request_completed")

func request_word(word: String):
	print(request(DICTONARY_API_URL + word))

func _on_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var request_result 
	if response_code == 200:
		var api_res = JSON.parse(body.get_string_from_utf8()).result
		request_result = {
			"success": true,
			"api_res": api_res,
			"definition": extract_definitions(api_res, 1)
		}
	else:
		request_result = {
			"success": false,
			"result": result,
			"response_code": response_code,
			"headers": headers,
			"body": body
		}
	emit_signal("requst_proccesed", request_result)

func extract_definitions(results: Array, count: int = 1) -> Array:
	var definitions = []
	for result_dict in results:
		var meanings = result_dict.get("meanings")
		if meanings:
			for meaning in meanings:
				for definition in meaning["definitions"]:
					definitions.append(definition["definition"])
	if count != -1:
		definitions.resize(count)
	return definitions

