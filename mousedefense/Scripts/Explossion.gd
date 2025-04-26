extends Sprite2D

@export var timer : Timer

@export var startScale : Vector2
@export var endScale : Vector2
@export var scaleCurve : Curve

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var t = timer.time_left / timer.wait_time
	
	#material.set_shader_parameter("Alpha", t)
	self_modulate.a = t
	scale = lerp(endScale, startScale, scaleCurve.sample(t))


func Cleanup():
	queue_free()
