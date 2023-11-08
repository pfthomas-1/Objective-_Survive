extends Node

@export var mob_scene: PackedScene
var score

func _ready():
	pass

func game_over():
	Global.can_shoot = false
	if score > Global.high_score:
		Global.high_score = score
		$HUD.update_high_score(Global.high_score)
	$ScoreTimer.stop()
	$MobTimer.stop()
	$HUD.show_game_over()
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	$Player.start($StartPosition.position)
	Global.can_shoot = true
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	get_tree().call_group("bullets", "queue_free")
	$Music.play()

func _on_score_timer_timeout():
	score += 1
	$HUD.update_score(score)

func _on_start_timer_timeout():
	$MobTimer.start()
	$ScoreTimer.start()

func _on_mob_timer_timeout():
	if Global.difficulty == 1:
		$MobTimer.wait_time = 0.45
	elif Global.difficulty == 2:
		$MobTimer.wait_time = randf_range(0.15, 0.35)
	elif Global.difficulty == 3:
		$MobTimer.wait_time = randf_range(0.1, 0.25)
	
	# Create new instance of the Mob scene
	var mob = mob_scene.instantiate()
	
	# Choose a random location on Path2D
	var mob_spawn_location = get_node("MobPath/MobSpawnLocation")
	mob_spawn_location.progress_ratio = randf()
	
	# Set mob's direction perpendicular to the path direction
	var direction = mob_spawn_location.rotation + PI / 2
	
	# Set mob's position to a random location
	mob.position = mob_spawn_location.position
	
	# add randomness to direction
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# choose velocity for the mob
	var velocity = Vector2(randf_range(150.0, 250.0), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	#spawn the mob by adding it to the main screen
	add_child(mob)
