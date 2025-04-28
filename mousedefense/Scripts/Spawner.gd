extends Node2D

@export var entities : PackedScene
@export var player : Node2D
@export var camera : Camera2D
@export var spawnTimer : Timer

@export var spawnTimeRange : Vector2
@export var spawnNodes : Array[Node2D]
@export var spawnRadius : float 

var spawnerToUse : int 
var rng : RandomNumberGenerator

var enemies : Array
var wave : int

func _ready() -> void:
	rng = RandomNumberGenerator.new()
	SwapSpawner()

func _process(delta: float) -> void:
	if Input.is_action_just_released("Restart"):
		spawnTimer.start()

func SpawnEntities():
	
	var spawnNode = spawnNodes[spawnerToUse]
	var entity = entities.instantiate()
	entity.global_position = spawnNode.global_position
	
	entity.collider.maxHealth = 1
	entity.collider.health = 1
	
	get_tree().current_scene.add_child(entity) 
	
	entity.player = player
	entity.camera = camera
	entity.origin = self
	
	SwapSpawner()


func StopTimer():
	spawnTimer.stop()
	wave += 1

func SwapSpawner():
	spawnerToUse = rng.randi_range(0, spawnNodes.size() - 1)
