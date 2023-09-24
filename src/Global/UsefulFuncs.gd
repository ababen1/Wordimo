extends RefCounted
class_name Funcs

static func is_html() -> bool:
	return OS.get_name() == "HTML5"
	
static func is_mobile() -> bool:
	return OS.get_name() in ["Android", "iOS"]

static func get_random_array_element(array: Array):
	var randomizer = RandomNumberGenerator.new()
	return array[randomizer.randi_range(0, array.size() -1)]
		
static func get_resources_data(preloader: ResourcePreloader) -> Dictionary:
	var data = {}
	for resource_name in preloader.get_resource_list():
		data[resource_name] = preloader.get_resource(resource_name)
	return data

# Given a preloader with 1 file, it returns a list of all other resources
# in the directory of that 1 file.
static func preloderer_get_dir_list(preloader: ResourcePreloader, include_subfolders: = true) -> Dictionary:
	var default_resource: = preloader.get_resource(preloader.get_resource_list()[0])		
	var paths: Array = get_content_in_path(
		default_resource.resource_path.get_base_dir(), true, include_subfolders)
	var list = {}
	for path in paths:
		list[path.get_file().trim_suffix('.' + path.get_extension())] = path
	return list

static func get_content_in_path(path: String, ignore_dot_import: = true, recrusive: = false) -> Array:
	var dir: = DirAccess.open(path)
	var content: = []
	if dir and dir.list_dir_begin()  == OK:
		var filename: String = dir.get_next()
		while filename:
			if not OS.is_debug_build():
				filename = filename.replace('.import', '')
			if !(ignore_dot_import and filename.ends_with(".import") and OS.is_debug_build()):
				if dir.current_is_dir() and recrusive:
					content.append_array(get_content_in_path(
						path.path_join(filename), ignore_dot_import, recrusive))
				else:
					content.append(path.path_join(filename))
			filename = dir.get_next()
	return content
	
static func generate_board_styles(path: String, output: String):
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin() # TODOGODOT4 fill missing arguments https://github.com/godotengine/godot/pull/40547
		var file: String = dir.get_next()
		while file:
			if dir.current_is_dir():
				generate_board_styles(path.path_join(file), output)
			elif ResourceLoader.exists(path.path_join(file)):
				var texture = load(path.path_join(file))
				if texture is Texture2D:
					# Create atlas textures
					var tile_tex: = AtlasTexture.new()
					var tile_alt_tex = AtlasTexture.new()
					tile_tex.atlas = texture.duplicate()
					tile_alt_tex.atlas = texture.duplicate()
					tile_tex.region = Rect2(Vector2(250, 251), Vector2(250,250))
					tile_alt_tex.region = Rect2(Vector2(500,250), Vector2(250,250))
					
					# Create Styleboxes
					var tile_stylebox = StyleBoxTexture.new()
					tile_stylebox.texture = tile_tex
					var tile_alt_stylebox = StyleBoxTexture.new()
					tile_alt_stylebox.texture = tile_alt_tex
					
					# Create BoardStyles
					var board_style = BoardStyle.new()
					board_style.tile = tile_stylebox.duplicate()
					board_style.tile_alt = tile_alt_stylebox.duplicate()
					
					ResourceSaver.save(
						board_style,
						output.path_join(file.get_file() + ".tres"))
			file = dir.get_next()
