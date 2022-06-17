extends Node

signal changing_scene
signal scene_changed
signal fade_out_finished
signal fade_in_finished

onready var anim_player = $AnimationPlayer
onready var cache = $cache

export var fade_out_anim_name: = "fade_out"
export var fade_in_anim_name: = "fade_in"

var message: Dictionary = {}

func change_scene(
	new_scene: PackedScene, 
	free_prev_scene: = true,
	fade_out: = true,
	fade_in: = true):
		if fade_out:
			yield(play_transition_animation(fade_out_anim_name), "completed")
			emit_signal("fade_out_finished")
		var new_scene_instance = new_scene.instance()
		if free_prev_scene:
			get_tree().current_scene.free()
		get_tree().root.add_child(new_scene_instance)
		get_tree().current_scene = new_scene_instance
		emit_signal("scene_changed")
		if fade_in:
			yield(play_transition_animation(fade_in_anim_name), "completed")
			emit_signal("fade_in_finished")

func goto_scene(path: String, msg: = {}):
	call_deferred("_deferred_goto_scene", path, msg)

func play_transition_animation(anim_name: String) -> bool:
	anim_player.play(anim_name)
	yield(anim_player, "animation_finished")
	return

func _deferred_goto_scene(path: String, msg: Dictionary):
	emit_signal("changing_scene")
	self.message = msg
	var packed_scene = load(path)
	if packed_scene:
		change_scene(packed_scene)
		
