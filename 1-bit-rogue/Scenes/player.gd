extends Node2D
class_name Player

@onready var movement_component: MovementComponent = %"Movement Component"
@onready var input_component: InputComponent = %"Input Component"

func _process(delta: float) -> void:
	input_component.update()
	movement_component.direction = input_component.input_direction
	movement_component.update(delta)
