extends CanvasLayer

# Notifies 'Main' node that the button was pressed
signal start_game

func _ready():
	$ScoreLabel.hide()
	$HighScoreLabel.hide()

func _process(delta):
	if Global.difficulty == 1:
		$DifficultyButton.text = str("Easy")
	if Global.difficulty == 2:
		$DifficultyButton.text = str("Normal")
	if Global.difficulty == 3:
		$DifficultyButton.text = str("Hard")

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func show_game_over():
	show_message("Game Over")
	# Wait until MessageTimer has counted down.
	await $MessageTimer.timeout
	
	$Message.text = "Objective:\nSurvive"
	$Message.show()
	$ScoreLabel.hide()
	$HighScoreLabel.show()
	$ControlsMessage.show()
	# Make a One-Shot timer and await for it to finish
	await get_tree().create_timer(1.0).timeout
	$StartButton.show()
	$QuitButton.show()
	$DifficultyButton.show()
	Global.can_quit = true
	
func update_score(score):
	$ScoreLabel.text = str(score)

func update_high_score(high_score):
	$HighScoreLabel.text = str("High Score: ", high_score)

func _on_start_button_pressed():
	$ScoreLabel.show()
	$StartButton.hide()
	$HighScoreLabel.hide()
	$ControlsMessage.hide()
	$QuitButton.hide()
	$DifficultyButton.hide()
	Global.can_quit = false
	start_game.emit()

func _on_message_timer_timeout():
	$Message.hide()
	$ControlsMessage.hide()

func _on_quit_button_pressed():
	if Global.can_quit == true:
		get_tree().quit()


func _on_difficulty_button_pressed():
	if Global.can_change_difficulty == true:
		Global.difficulty += 1
	if Global.difficulty > 3:
		Global.difficulty = 1
