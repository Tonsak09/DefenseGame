extends CharacterBody2D

var playback_data = []
var current_frame = 0
const SPEED = 80.0

var last_move_dir = Vector2.ZERO

#@onready var animation = $AnimatedSprite2D

func _ready():
	set_physics_process(false)

func start_replay(data):
	playback_data = data
	current_frame = 0
	set_physics_process(true)

func _physics_process(delta):
	if current_frame >= playback_data.size():
		velocity = Vector2.ZERO
		set_physics_process(false)

		# 🆕 Play idle animation based on last direction
		#if last_move_dir.y > 0:
		#	animation.play("IdleSouth")
		#elif last_move_dir.y < 0:
		#	animation.play("IdleNorth")
		#elif last_move_dir.x > 0:
		#	animation.play("IdleRight")
		#elif last_move_dir.x < 0:
		#	animation.play("IdleLeft")
		#else:
		#	animation.play("IdleSouth") # Fallback
		return

	var input = playback_data[current_frame]
	var h = input["horizontal"]
	var v = input["vertical"]

	velocity.x = h * SPEED * delta * 100
	velocity.y = v * SPEED * delta * 100
	move_and_slide()

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
		# 🆕 Now use last_move_dir to choose idle animation
		#if last_move_dir.y > 0:
		#	animation.play("IdleSouth")
		#elif last_move_dir.y < 0:
		#	animation.play("IdleNorth")
		#elif last_move_dir.x > 0:
		#	animation.play("IdleRight")
		#elif last_move_dir.x < 0:
		#	animation.play("IdleLeft")
		#else:
		#	animation.play("IdleSouth") # Fallback

	current_frame += 1
