extends CharacterBody2D

@export var progBar : ProgressBar
@export var timeKeep : Label

const SPEED = 80.0
const JUMP_VELOCITY = -400.0

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var input_log = []
var is_recording = false
var spawn_position := Vector2(0, 0)
var last_move_dir := Vector2.ZERO
var time : float 

#@onready var animation = $AnimatedSprite2D
@onready var replay_clone_scene = preload("res://Prefabs/ReplayClone.tscn")

var replay_clone : Node = null


func _ready():
	spawn_position = global_position


func _physics_process(delta):
	
	time += delta 
	timeKeep.text = str(int(time))
	# Apply gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# Input handling
	var h = Input.get_axis("move_left", "move_right")
	var v = Input.get_axis("move_up", "move_down")
	
	# Movement
	velocity.x = h * SPEED * delta * 100
	velocity.y = v * SPEED * delta * 100
	move_and_slide()
	
	if (Input.get_action_strength("start_record")):
		is_recording = true; 
	
	
	if progBar.value >= progBar.max_value:
		is_recording = false
	
	if is_recording:
		progBar.value += delta
	
	# Animation logic
	if h != 0 or v != 0:
		last_move_dir = Vector2(h, v).normalized()
		#if v > 0:
		#	animation.play("WalkSouth", 1.75)
		#elif v < 0:
		#	animation.play("WalkNorth", 1.75)
		#elif h > 0:
		#	animation.play("WalkRight", 1.6)
		#else:
		#	animation.play("WalkLeft", 1.6)
	#else:
		#if last_move_dir.y > 0:
		#	animation.play("IdleSouth")
		#elif last_move_dir.y < 0:
		#	animation.play("IdleNorth")
		#elif last_move_dir.x > 0:
		#	animation.play("IdleRight")
		#elif last_move_dir.x < 0:
		#	animation.play("IdleLeft")
		#else:
		#	animation.play("IdleSouth") # fallback if never moved

	# Input recording
	if is_recording:
		input_log.append({
			"horizontal": h,
			"vertical": v,
		})


func _input(event):
	if event.is_action_pressed("replay"):
		print("Replay triggered") # Debug print
		start_replay()


func start_replay():
	if replay_clone != null and is_instance_valid(replay_clone):
		replay_clone.queue_free()
		replay_clone = null
	
	progBar.value = 0
	is_recording = false
	#global_position = spawn_position
	
	spawn_replay_clone()
	
	input_log.clear()
	#is_recording = true
	


func spawn_replay_clone():

	replay_clone = replay_clone_scene.instantiate()
	get_parent().add_child(replay_clone)
	replay_clone.global_position = global_position #spawn_position
	replay_clone.start_replay(input_log.duplicate(true)) # Deep copy input log
	# replay_clone.get_node("AnimatedSprite2D").modulate = Color(0.5, 0.5, 0.5, 0.8) # Tint ghost


func Damage():
	print_debug("Hit")
