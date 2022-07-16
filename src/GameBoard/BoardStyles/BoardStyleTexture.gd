tool
extends BoardStyle
class_name BoardStyleTexture

const TILE_TEXTURE_SIZE = Vector2(250,250)

export var board_texture: Texture setget set_board_texture
export var tile_texture: Texture
export var alt_tile_texture: Texture

func set_board_texture(val: Texture):
	board_texture = val
	
	var tile: = AtlasTexture.new()
	var alt_tile = AtlasTexture.new()
	tile.atlas = board_texture
	alt_tile.atlas = board_texture
	tile.region = Rect2(Vector2(250, 251), TILE_TEXTURE_SIZE)
	alt_tile.region = Rect2(Vector2(500,250),TILE_TEXTURE_SIZE)
	self.tile_texture = tile
	self.alt_tile_texture = alt_tile
