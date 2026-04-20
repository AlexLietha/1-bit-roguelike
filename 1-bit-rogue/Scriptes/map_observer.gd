@tool
extends Node
class_name MapObserver

@export var tilemap_layer: TileMapLayer
@export_tool_button("Observe Map") var map_obs_button = obs_map

const TILE_DATA: Dictionary = {
	"floor": {
		"source_id": 4,
		"atlas_coords": Vector2i(1,0)
	},
	"wall": {
		"source_id": 4,
		"atlas_coords": Vector2i(2,0)
	},
	"corner": {
		"source_id": 4,
		"atlas_coords": Vector2i(0,0)
	}
}


func obs_map():
	var x = 1
	var y = 1
	while true:
		var cell = Vector2i(x,y)
		if tilemap_layer.get_cell_atlas_coords(cell) == Vector2i(-1,-1):
			if x == 1:
				return
			x = 1
			y += 1
			continue
		elif tilemap_layer.get_cell_atlas_coords(cell) == TILE_DATA.wall.atlas_coords:
			x += 1
			continue
		
		var neigbors = tilemap_layer.get_surrounding_cells(cell)
		var is_corner := true
		var floor_count := 0
		
		for n in neigbors:
			if tilemap_layer.get_cell_atlas_coords(n) == TILE_DATA.floor.atlas_coords or tilemap_layer.get_cell_atlas_coords(n) == TILE_DATA.corner.atlas_coords:
				floor_count += 1
			if floor_count > 1:
				is_corner = false
				break
			
		if is_corner:
			tilemap_layer.set_cell(cell, TILE_DATA.corner.source_id, TILE_DATA.corner.atlas_coords)
		x += 1
	pass
