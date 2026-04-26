@tool
extends Node
class_name GameManager
enum  ACTIONS{
	MOVE, INTERACT, ATTACK
}

@export var player: Player
@onready var map: Maze = %Map
@export_tool_button("New Level") var map_obs_button = new_level

func _ready() -> void:
	player.get_move_signal().connect(get_actions)
	new_level()
func new_level() -> void:
	if map != null:
		map.start()
		map.map_builder.place_player(player)
		get_actions()
		

func get_actions() -> void:
	print(player.movement_component.map_pos)
	print(map.map_builder.get_surrounding_actions(player.movement_component.map_pos))
	player.actions = map.map_builder.get_surrounding_actions(player.movement_component.map_pos)
	pass
