extends Node2D
class_name Player

@onready var movement_component: MovementComponent = %"Movement Component"
@onready var input_component: InputComponent = %"Input Component"

var dirs:= [Vector2i.UP, Vector2i.RIGHT, Vector2i.DOWN, Vector2i.LEFT]
var actions = []

func _process(delta: float) -> void:
	input_component.update()
	movement_component.update(delta)
	var action = null
	for i in range(len(dirs)):
		if input_component.input_direction == dirs[i]:
			action = actions[i]
			break
		else:
			action = null
	movement_component.direction = Vector2i.ZERO
	if action == "Move":
		movement_component.direction = input_component.input_direction
		
	
func get_move_signal()-> Signal:
	return movement_component.moved
