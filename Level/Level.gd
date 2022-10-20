extends Node

var PlayerScore = 0
var EnemyScore = 0
var StartSide

var screen_size

func set_all_visiblity(visibility):
	$PlayerScore.visible = visibility
	$EnemyScore.visible = visibility
	$Player.visible = visibility
	$Enemy.visible = visibility
	$Ball.visible = visibility
	$Line.visible = visibility
	
func _ready():
	screen_size = get_viewport().size
	
func reset_positions():
	$Ball.position = Vector2(screen_size.x/2, screen_size.y/2)
	$Player.position = Vector2(50, screen_size.y/2)
	$Enemy.position = Vector2(screen_size.x - 50, screen_size.y/2)

func reset_score():
	EnemyScore = 0
	PlayerScore = 0

func start_game():
	StartSide = [-1,1][randi() % 2]
	set_all_visiblity(true)
	reset_score()
	$StartGame.visible = false
	$Message.visible = false
	reset_positions()
	$CountdownTimer.start()
	$Ball.visible = false

func _on_LeftArea_body_entered(body):
	score_changed(false)

func _on_RightArea_body_entered(body):
	score_changed(true)
	
func _process(delta):
	$PlayerScore.text = str(PlayerScore)
	$EnemyScore.text = str(EnemyScore)
	
func game_over(is_win):
	set_all_visiblity(false)
	if is_win: $Message.text = "You WIN!"
	else: $Message.text = "You LOSE!"
	$StartGame.text = "Restart game"
	$StartGame.visible = true
	$Message.visible = true

func _on_CountdownTimer_timeout():
	get_tree().call_group('BallGroup', 'activate_ball', StartSide, PlayerScore + EnemyScore)

func score_changed(is_player):
	reset_positions()
	get_tree().call_group('BallGroup', 'stop_ball')
	$Ball.visible = false
	
	if is_player: 
		PlayerScore += 1
		StartSide = 1
		$Win.play()
	else: 
		EnemyScore += 1
		StartSide = -1
		$Lose.play()
		
	if PlayerScore == 9:
		game_over(true)
	elif EnemyScore == 9:
		game_over(false)
	else:
		$CountdownTimer.start()
