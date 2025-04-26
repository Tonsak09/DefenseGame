extends StaticBody2D

func disappear():
	print("Wall disappearing...")
	queue_free()
	$CollisionShape2D.disabled = true
