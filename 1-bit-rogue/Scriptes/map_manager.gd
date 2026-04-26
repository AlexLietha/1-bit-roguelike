@tool
extends Node
class_name Maze
enum Algos{
	WALKER,
	RECURSIZE_BACKTRACK,
	PRIMS
}

@onready var map_builder: MapBuilder = %Map_Builder
@onready var prims_gen: PrimsMaze = %Prims_Gen
@onready var rbt_gen: RecursiveBacktrackMaze = %RBT_Gen
@onready var walker_generator: WalkerGenerator = %WalkerGenerator

@export var Algorithm := Algos.PRIMS
@export var Map_Dimensions := Vector2i(7,7)
@export var Holes := 0
@export var Statues := 0
@export var Chests := 0
@export_tool_button("Generate Map") var map_gen_button = start
func _ready() -> void:
	generate_map()
	place_objects()
	
func start():
	generate_map()
	place_objects()

func generate_map():
	if Algorithm == Algos.WALKER:
		walker_generator.generate_map()
	elif Algorithm == Algos.RECURSIZE_BACKTRACK:
		rbt_gen.generate_map()
	elif Algorithm == Algos.PRIMS:
		prims_gen.generate_map(Map_Dimensions, Holes)
	map_builder.scan_map()
	
func place_objects():
	map_builder.place_chests(Chests)
	map_builder.place_statues(Statues)
	map_builder.place_pressure_plate()
	
func neighbor_tiles(pos: Vector2i) -> Array[Vector2i]:
	return map_builder.tilemap_layer.get_surrounding_cells(pos)
	
