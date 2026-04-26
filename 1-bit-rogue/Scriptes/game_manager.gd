@tool
extends Node


@export var player: Player
@onready var map: Maze = %Map
@export_tool_button("New Level") var map_obs_button = new_level

func new_level():
	if map != null:
		map.start()
		map.map_builder.place_player(player)
		
