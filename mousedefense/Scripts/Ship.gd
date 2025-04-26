extends Node2D

@export var charController : CharacterBody2D
@export var rotSpeed : float

var hadReadied = false 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var angle = global_position.direction_to(global_position + charController.normVel).angle()

	# slowly changes the rotation to face the angle
	rotation = rotate_toward(rotation, angle, rotSpeed * delta)
	
	
