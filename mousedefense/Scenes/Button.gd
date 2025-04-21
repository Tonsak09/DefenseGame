extends Area2D

signal button_pressed

var is_pressed = false

@onready var sprite = $Sprite2D

func _on_body_entered(body):
	if body is CharacterBody2D and !is_pressed:
		is_pressed = true
		print("Button pressed!")
		sprite.modulate = Color(0.6, 0.6, 0.6) # Visual feedback
		emit_signal("button_pressed")
