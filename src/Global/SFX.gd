extends Node

const SOUNDS = {
	"clear_word": preload("res://assets/SFX/Pop.wav"),
	"place_block": preload("res://assets/SFX/Click.wav"),
	"rotate": preload("res://assets/SFX/Rotate.wav"),
	"hover": preload("res://assets/SFX/Hover.wav"),
	"add_block": preload("res://assets/SFX/AddBlock.wav")
}

func _enter_tree() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS

func play_sound_effect(sfx: AudioStream):
	var audio_player: = AudioStreamPlayer.new()
	get_tree().root.add_child(audio_player)
	audio_player.stream = sfx
	audio_player.bus = "SFX"
	audio_player.play()
	yield(audio_player, "finished")
	audio_player.queue_free()
		
