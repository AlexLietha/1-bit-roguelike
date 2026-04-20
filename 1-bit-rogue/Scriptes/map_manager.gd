@tool
extends Node

enum Algos{
	WALKER,
	RECURSIZE_BACKTRACK,
	PRIMS
}

@onready var map_observer: MapObserver = %Map_Observer
@onready var prims_gen: PrimsMaze = %Prims_Gen
@onready var rbt_gen: RecursiveBacktrackMaze = %RBT_Gen
@onready var walker_generator: WalkerGenerator = %WalkerGenerator

@export var Algorithm := Algos.PRIMS
@export var Map_Dimensions := Vector2i(7,7)
@export var Holes := 0
@export_tool_button("Generate Map") var map_gen_button = generate_map
func _ready() -> void:
	generate_map()
	
func generate_map():
	if Algorithm == Algos.WALKER:
		walker_generator.generate_map()
	elif Algorithm == Algos.RECURSIZE_BACKTRACK:
		rbt_gen.generate_map()
	elif Algorithm == Algos.PRIMS:
		prims_gen.generate_map(Map_Dimensions, Holes)
		
	map_observer.obs_map()
