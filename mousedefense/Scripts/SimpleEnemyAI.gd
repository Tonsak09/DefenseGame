extends CharacterBody2D

# Assumes managed 
@export var player : Node2D
@export var moveSpeed : float 
@export var slowDown : float 

@export var castChecker : ShapeCast2D
@export var avoidShipsVel : float 

@export var collider : Area2D
@export var hittableHealth : Node2D

var normVel : Vector2
var canMove : bool
@export var camera : Camera2D
var origin : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	canMove = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !canMove || !player:
		return
	
	#if player.stopped:
	#	return 
	
	# Vel towards target 
	var d = player.global_position - global_position
	var diff = (d).normalized() * moveSpeed
	normVel = velocity.normalized()
	velocity += diff * delta 
	
	
	if(d.length_squared() <= 20):
		hittableHealth.health = -1;
		get_tree().reload_current_scene()

	
	# Vel away from group 
	var count = min(castChecker.get_collision_count(), 3) 
	var avg : Vector2
	for i in count:
		avg += castChecker.get_collision_point(i)
	
	if count > 0:
		avg /= count
	
	velocity += (global_position - avg) * delta * avoidShipsVel
	
	velocity -= normVel * velocity.length() * delta * slowDown
	move_and_slide()

func UpdateCast():
	castChecker.force_shapecast_update()
