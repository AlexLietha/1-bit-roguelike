@tool
extends Node
class_name MapBuilder

@export var tilemap_layer: TileMapLayer
@export_tool_button("Draw Corners") var map_obs_button = scan_map

var corners : Array[Vector2i] = []
var floors : Array[Vector2i] = []
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
	},
	"chest": {
		"source_id": 3,
		"atlas_coords": Vector2i(0,0)
	},
	"statue": {
		"source_id": 3,
		"atlas_coords": Vector2i(1,0)
	}
}


func scan_map():
	floors.clear()
	corners.clear()
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
			#tilemap_layer.set_cell(cell, TILE_DATA.corner.source_id, TILE_DATA.corner.atlas_coords)
			corners.append(cell)
		else:
			floors.append(cell)
		x += 1
	pass

func get_corners() -> Array[Vector2i]:
	return corners
	
func get_valid_floors() -> Array[Vector2i]:
	return floors

func place_chests(chests: int):
	for i in range(chests):
		if corners.is_empty():
			return
		var corner = corners.pick_random()
		tilemap_layer.set_cell(corner, TILE_DATA.chest.source_id,  TILE_DATA.chest.atlas_coords)
		corners.erase(corner)

func place_statues(statues: int):
	for i in range(statues):
		if corners.is_empty():
			return
		var corner = corners.pick_random()
		tilemap_layer.set_cell(corner, TILE_DATA.statue.source_id,  TILE_DATA.statue.atlas_coords)
		corners.erase(corner)
