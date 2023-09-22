extends Node

const SOUNDS = {
	"clear_word": preload("res://assets/SFX/Pop.wav"),
	"place_block": preload("res://assets/SFX/Click.wav"),
	"rotate": preload("res://assets/SFX/Rotate.wav"),
	"hover": preload("res://assets/SFX/Hover.wav"),
	"add_block": preload("res://assets/SFX/AddBlock.wav")
}

func _enter_tree() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_sound_effect(sfx: AudioStream):
	var audio_player: = AudioStreamPlayer.new()
	get_tree().root.add_child(audio_player)
	audio_player.stream = sfx
	audio_player.bus = "SFX"
	audio_player.play()
	await audio_player.finished
	audio_player.queue_free()
		
