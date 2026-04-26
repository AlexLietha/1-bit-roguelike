@tool
extends Node
class_name PrimsMaze

const TILE_DATA: Dictionary = {
	"floor": {
		"source_id": 0,
		"atlas_coords": Vector2i(3,0)
	},
	"wall": {
		"source_id": 0,
		"atlas_coords": Vector2i(4,0)
	},
	"corner": {
		"source_id": 0,
		"atlas_coords": Vector2i(2,0)
	}
}


@export var gen_seed: int = 0
@export var randomize_seed: = true
@export var map_dimensions:= Vector2i(7, 7)
@export var holes: int = 0
@export_tool_button("Generate Map") var map_gen_button = generate_map
@export var tilemap_layer: TileMapLayer
var start_pos:= Vector2i(1,1)
var visited_cells: Array = []
var dirs:= [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]



func generate_map(dimesions: Vector2i = map_dimensions, holes_count: int = holes) -> void:
	if tilemap_layer == null:
		push_error("PrimsMaze: No TileMapLayer assigned!")
		return
		
	if randomize_seed :
		gen_seed = randi()
	map_dimensions = dimesions
	holes = holes_count
	seed(gen_seed)
	tilemap_layer.clear()
	fill_map()
	carve_map(Vector2i(1,1))
	poke_holes()

func fill_map() -> void:
	for x in range(map_dimensions.x):
		for y in range(map_dimensions.y):
			tilemap_layer.set_cell(Vector2i(x, y), TILE_DATA.wall.source_id, TILE_DATA.wall.atlas_coords)
			
func carve_map(start_pos: Vector2i) -> void:
	var walls = []
	tilemap_layer.set_cell(start_pos, TILE_DATA.floor.source_id, TILE_DATA.floor.atlas_coords)
	add_walls(start_pos, walls)

	while !walls.is_empty():
		walls.shuffle()
		var picked_wall: Vector2i  = Vector2i.ZERO
		for wall in walls:
			if check_wall_valid(wall):
				picked_wall = wall
				break
		if picked_wall == Vector2i.ZERO:
			continue
		var picked_cell = find_potential_floor(picked_wall)
		if picked_cell == Vector2i(-1,-1):
			walls.pop_at(walls.find(picked_wall))
			continue
		tilemap_layer.set_cell(picked_wall, TILE_DATA.floor.source_id, TILE_DATA.floor.atlas_coords)
		var connector = (picked_wall + picked_cell) / 2
		tilemap_layer.set_cell(connector, TILE_DATA.floor.source_id, TILE_DATA.floor.atlas_coords)
		add_walls(picked_wall, walls)
		walls.erase(picked_wall)

		
	
func add_walls(cell: Vector2i, walls: Array) -> void:
	for d in dirs:
		var dir = d * 2 + cell
		if dir not in walls:
			if !(dir.x > map_dimensions.x -1 or dir.y > map_dimensions.y - 1 or dir.x < 0 or dir.y < 0):
				if tilemap_layer.get_cell_atlas_coords(dir) != TILE_DATA.floor.atlas_coords:
					walls.append(dir)
	pass
	
func check_wall_valid(wall: Vector2i) -> bool:
	# 1 check if not a floor
	if tilemap_layer.get_cell_atlas_coords(wall) == TILE_DATA.floor.atlas_coords:
		return false
		
	return true
	
func find_potential_floor(wall: Vector2i) -> Vector2i:
	for d in dirs:
		var dir = d * 2 + wall
		if !(dir.x > map_dimensions.x -1 or dir.y > map_dimensions.y - 1 or dir.x < 0 or dir.y < 0):
			if tilemap_layer.get_cell_atlas_coords(dir) == TILE_DATA.floor.atlas_coords:
				return dir
			
	return Vector2i(-1,-1)

func poke_holes():
	var odd_walls = []
	for x in range(1, map_dimensions.x):
		for y in range(1, map_dimensions.y):
				if x % 2 == 1 or y % 2 == 1:
					if tilemap_layer.get_cell_atlas_coords(Vector2i(x,y)) == TILE_DATA.wall.atlas_coords:
						if surrounded_by_x_floors(2, Vector2i(x,y)):
							odd_walls.append(Vector2i(x,y))
	for i in range(holes):
		var hole = odd_walls.pick_random()
		tilemap_layer.set_cell(hole, TILE_DATA.floor.source_id, TILE_DATA.floor.atlas_coords)
		odd_walls.erase(hole)
	
func surrounded_by_x_floors(floor_count: int, wall: Vector2i) -> bool:
	var neigbors = tilemap_layer.get_surrounding_cells(wall)
	var floor_tiles := 0
	for n in neigbors:
		if tilemap_layer.get_cell_atlas_coords(n) == TILE_DATA.floor.atlas_coords:
			floor_tiles += 1
			
	if floor_tiles == floor_count:
		return true
			
	return false
	
