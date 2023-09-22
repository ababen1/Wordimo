@tool
extends Resource
class_name BoardStyle

@export var primary_color: = Color("2b2929")
@export var secondary_color: = Color("555151")
@export var outline_color: = Color.TRANSPARENT
@export var outline_size: float = 5.0
@export var highlight_color: = Color.GREEN_YELLOW
@export var error_color: = Color.RED
@export var tile: StyleBox = null
@export var tile_alt: StyleBox = null

func create_tiles_from_colors() -> void:
	tile = StyleBoxFlat.new()
	tile.bg_color = primary_color
	tile_alt = StyleBoxFlat.new()
	tile_alt.bg_color = secondary_color
	
func create_tiles_from_textures(tex_tile: Texture2D, tex_alt_tile: Texture2D) -> void:
	tile = StyleBoxTexture.new()
	tile.texture = tex_tile
	tile_alt = StyleBoxTexture.new()
	tile_alt.texture = tex_alt_tile
	
