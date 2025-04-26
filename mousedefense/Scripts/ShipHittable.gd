extends Area2D

@export_category("Stats")
@export var maxHealth : float 

@export_category("Visuals")
@export var primarySprite : Sprite2D
@export var damageSprite : Sprite2D
@export var pulseSpeed : float 
@export var deathVFX : PackedScene

@export_category("Cleanup")
@export var rootParent : Node2D
@export var timer : Timer
@export var checkTimer : Timer 

var health : float 
var interactable : bool

var activatedHold : bool 
var alpha : float 
var damageTimer : float 


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	health = maxHealth
	interactable = true

func Init():
	#health = rootParent.origin.wave
	health = 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	monitorable = interactable
	damageTimer += delta * pulseSpeed
	
	if activatedHold:
		alpha = lerp(0.4, 0.8, remap(sin(damageTimer), -1.0, 1.0, 0.0, 1.0))    #clampf(alpha + delta, 0, 0.6)
	else:
		alpha = clampf(alpha - delta, 0, 0.6)
		#damageTimer = 0.0
	
	#damageSprite.material.set_shader_parameter("Alpha", alpha)
	activatedHold = false
	

func Activate(targetter : Node2D, damage : float):
	health -= damage 
	
	activatedHold = true 
	
	
	if health <= 0.0:
		interactable = false 
		
		primarySprite.visible = false 
		damageSprite.visible = false 
		
		# Play destruction FX 
		var vfx = deathVFX.instantiate()
		vfx.global_position = global_position
		get_tree().current_scene.add_child(vfx)
		
		#rootParent.camera.ApplyShake()
		
		rootParent.canMove = false
		
		# Begin timer that will cleanup after a timer 
		timer.start()
	
	# Ship is still not dead

func Check():
	if health <= 0.0:
		checkTimer.stop()
		interactable = false 
		
		primarySprite.visible = false 
		damageSprite.visible = false 
		
		# Play destruction FX 
		var vfx = deathVFX.instantiate()
		vfx.global_position = global_position
		get_tree().current_scene.add_child(vfx)
		
		#rootParent.camera.ApplyShake()
		
		rootParent.canMove = false
		
		# Begin timer that will cleanup after a timer 
		timer.start()

func Cleanup():
	rootParent.queue_free()


func _on_body_entered(body: Node2D) -> void:
	print_debug(body.name)
	health = -1
	#body.Damage()
