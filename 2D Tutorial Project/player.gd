extends Area2D
signal hit

@export var bullet_scene: PackedScene
@export var speed = 250 # how fast the player moves (pixels/sec).

var screen_size # size of game window

func _ready():
	screen_size = get_viewport_rect().size
	hide()

func _process(delta):
	look_at(get_global_mouse_position())
	
	var velocity = Vector2.ZERO
	if Input.is_action_pressed("move_right"):
		velocity.x += 1
	if Input.is_action_pressed("move_left"):
		velocity.x += -1
	if Input.is_action_pressed("move_up"):
		velocity.y += -1
	if Input.is_action_pressed("move_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		velocity = velocity.normalized() * speed
		$AnimatedSprite2D.play()
	else:
		$AnimatedSprite2D.stop()
	
	position += velocity * delta
	position = position.clamp(Vector2.ZERO, screen_size)
	
	if velocity.x != 0 or velocity.y != 0:
		$AnimatedSprite2D.animation = "up"
		$AnimatedSprite2D.flip_v = false
		$AnimatedSprite2D.flip_h = false
	
	if Input.is_action_just_pressed("shoot") and Global.can_shoot == true:
		$LaserSound.play()
		shoot()

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		hide()
		hit.emit()
		$CollisionShape2D.set_deferred("disabled", true)

func start(pos):
	position = pos
	show()
	$CollisionShape2D.disabled = false

func shoot():
	var b = bullet_scene.instantiate()
	owner.add_child(b)
	b.transform = $Muzzle.global_transform
