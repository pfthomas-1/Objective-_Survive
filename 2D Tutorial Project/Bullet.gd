extends Area2D

var bulletSpeed = 750 # speed of the bullet

func _physics_process(delta):
	position += transform.x * bulletSpeed * delta

func _on_bullet_body_entered(body):
	if body.is_in_group("mobs"):
		body.queue_free()
	queue_free()

