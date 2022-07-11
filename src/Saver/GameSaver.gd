# Saves and loads savegame files
# Each node is responsible for finding itself in the save_game
# dict so saves don't rely on the nodes' path or their source file
extends Node

signal saved

#const SaveGame = preload('SaveGame.gd')

const SAVE_FOLDER_DEBUG: String = "res://debug/save"
var SAVE_FOLDER_RELEASE: String = OS.get_user_data_dir()

export var load_first_on_ready: = false

var current_save: SaveGame = SaveGame.new()

func _ready() -> void:
	if load_first_on_ready:
		set_as_current_save(get_all_save_games().front())

func set_as_current_save(save: SaveGame):
	if not save:
		return
	current_save = save
	if current_save:
		seed(current_save.random_seed)
		load_all_nodes()
		current_save.apply_configs()

func reset_all_nodes():
	load_all_nodes(SaveGame.new())

func save_progress():
	save_all_nodes(current_save)
	write_to_disk(current_save)
	emit_signal("saved")

func save_all_nodes(savefile: SaveGame = current_save):
	for node in get_tree().get_nodes_in_group('save'):
		node.save(savefile)

func load_all_nodes(savefile: SaveGame = current_save):
	for node in get_tree().get_nodes_in_group('save'):
		node.load(savefile)
#		print("loaded " + str(node))

static func is_html() -> bool:
	return OS.get_name() == "HTML5"
	
static func is_mobile() -> bool:
	return OS.get_name() in ["Android", "iOS"]

static func get_save_folder() -> String:
	if OS.is_debug_build():
		return GameSaver.SAVE_FOLDER_DEBUG
	else:
		return GameSaver.SAVE_FOLDER_RELEASE

static func get_all_save_games() -> Array:
	var saves: = []
	var folder = GameSaver.get_save_folder()
	var dir: Directory = Directory.new()
	if dir.open(folder) == OK:
# warning-ignore:return_value_discarded
		dir.list_dir_begin(true)
		var file: = dir.get_next()
		while file != "":
			if ResourceLoader.exists(folder.plus_file(file)):
				var savefile = load(folder.plus_file(file))
				if savefile is SaveGame:
					saves.append(savefile)
			file = dir.get_next()
	return saves

static func write_to_disk(save_game: SaveGame) -> void:
	var save_folder = get_save_folder()
	var directory: Directory = Directory.new()
	if not directory.dir_exists(save_folder):
# warning-ignore:return_value_discarded
		directory.make_dir_recursive(save_folder)
	var error: int = save_game.save(save_folder)
	if error != OK:
		print(
			'There was an issue writing the save %s to %s' % [
				save_game.savefile_name, save_folder])

static func find_savefile(
	name: String, 
	random_seed: int) -> SaveGame:
		var save_file: SaveGame = null
		var path: String = get_save_folder().plus_file(
		SaveGame.get_savefile_name(name, random_seed))
		if ResourceLoader.exists(path):
			save_file = load(path)
		return save_file

#static func delete_save_file(id: int):
#	var save_file_path: String = get_save_folder().plus_file(
#		SAVE_NAME_TEMPLATE % id)
#	var directory: Directory = Directory.new()
#	if not directory.file_exists(save_file_path):
#		printerr("Cant delete nonexisiting save file {i}".format({"i": id}))
#	else:
#		var error = directory.remove(save_file_path)
#		if not error == OK:
#			printerr(error)
