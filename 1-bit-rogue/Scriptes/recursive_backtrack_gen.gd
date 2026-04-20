@tool
extends Node
class_name RecursiveBacktrackMaze

const TILE_DATA: Dictionary = {
	"floor": {
		"source_id": 4,
		"atlas_coords": Vector2i(1,0)
	},
	"wall": {
		"source_id": 4,
		"atlas_coords": Vector2i(2,0)
	}
}

@export var gen_seed: int = 0
@export var randomize_seed: = true
@export var map_dimensions:= Vector2i(7, 7)
@export_tool_button("Generate Map") var map_gen_button = generate_map
@export var tilemap_layer: TileMapLayer
var start_pos:= Vector2i(1,1)
var visited_cells: Array = []
var dirs:= [Vector2i.LEFT, Vector2i.RIGHT, Vector2i.UP, Vector2i.DOWN]
func _ready() -> void:
	generate_map()


func generate_map() -> void:
	if tilemap_layer == null:
		return
	if randomize_seed :
		gen_seed = randi()
	seed(gen_seed)
	tilemap_layer.clear()
	visited_cells.clear()
	fill_map()
	carve_maze(start_pos)
	
func fill_map():
	for x in range(map_dimensions.x):
		for y in range(map_dimensions.y):
			tilemap_layer.set_cell(Vector2i(x, y), TILE_DATA.wall.source_id, TILE_DATA.wall.atlas_coords)
			
func carve_maze(start_pos: Vector2i):
	tilemap_layer.set_cell(start_pos, TILE_DATA.floor.source_id, TILE_DATA.floor.atlas_coords)
	carve(start_pos)
	pass
	
func carve(pos: Vector2i):
	var stack := [start_pos]
	tilemap_layer.set_cell(
		start_pos,
		TILE_DATA.floor.source_id,
		TILE_DATA.floor.atlas_coords
	)
	
	while not stack.is_empty():
		var current_pos : Vector2i = stack[-1]
		
		var unvisited_neighbors = _get_unvisited_neighbors(current_pos)
		
		if not unvisited_neighbors.is_empty():
			# Choose a random direction to go
			var next_dir = unvisited_neighbors.pick_random()
			var new_pos = current_pos + (next_dir * 2)
			var connecting_pos = current_pos + next_dir
			
			tilemap_layer.set_cell(
				connecting_pos,
				TILE_DATA.floor.source_id,
				TILE_DATA.floor.atlas_coords
			)
			tilemap_layer.set_cell(
				new_pos,
				TILE_DATA.floor.source_id,
				TILE_DATA.floor.atlas_coords
			)
			
			stack.append(new_pos)
		else:
			# Dead end! Backtrack by popping the stack
			stack.pop_back()
	
func _get_unvisited_neighbors(pos: Vector2i):
	var neighbors := []
	
	for dir in dirs:
		var neighbor_pos : Vector2i= pos + (dir * 2)
		
		# Check bounds
		if neighbor_pos.x <= 0 or neighbor_pos.x >= map_dimensions.x - 1:
			continue
		if neighbor_pos.y <= 0 or neighbor_pos.y >= map_dimensions.y - 1:
			continue
		
		# Check if unvisited (still a wall)
		if tilemap_layer.get_cell_atlas_coords(neighbor_pos) == TILE_DATA.wall.atlas_coords:
			neighbors.append(dir)

		
	return neighbors
		
		
