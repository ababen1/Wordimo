extends Node

signal changing_scene
signal scene_changed
signal fade_out_finished
signal fade_in_finished

@onready var anim_player = $AnimationPlayer
@onready var cache = $cache
@onready var res_preloader = $ResourcePreloader

@export var fade_out_anim_name: = "fade_out"
@export var fade_in_anim_name: = "fade_in"

var message: Dictionary = {}

func change_scene_to_file(
	new_scene, 
	free_prev_scene: = true,
	message: = {},
	fade_out: = true,
	fade_in: = true):
		if new_scene is String:
			new_scene = res_preloader.get_resource(new_scene)
		self.message = message
		if fade_out:
			await play_transition_animation(fade_out_anim_name)
			emit_signal("fade_out_finished")
		var new_scene_instance = new_scene.instance()
		if free_prev_scene:
			get_tree().current_scene.free()
		get_tree().root.add_child(new_scene_instance)
		get_tree().current_scene = new_scene_instance
		emit_signal("scene_changed")
		if fade_in:
			await play_transition_animation(fade_in_anim_name)
			emit_signal("fade_in_finished")

func pop_message() -> Dictionary:
	var temp = message.duplicate(true)
	message = {}
	return temp

func goto_scene(path: String, msg: = {}):
	call_deferred("_deferred_goto_scene", path, msg)

func play_transition_animation(anim_name: String) -> void:
	anim_player.play(anim_name)
	await anim_player.animation_finished

func _deferred_goto_scene(path: String, msg: Dictionary):
	emit_signal("changing_scene")
	self.message = msg
	var packed_scene = load(path)
	if packed_scene:
		change_scene_to_file(packed_scene)
		
