extends KinematicBody2D

var start_speed = 600
var speed = start_speed
var velocity = Vector2.ZERO
var player_paddle
var enemy_paddle

func _ready():
	randomize()
	player_paddle = get_parent().find_node("Player")
	enemy_paddle = get_parent().find_node("Enemy")

func _physics_process(delta):
	var collision_object = move_and_collide(velocity * speed * delta)
	if collision_object:
		if collision_object.collider.name == "Player":
			velocity = (position - player_paddle.position)
			speed = start_speed + velocity.length() * 5
			velocity = velocity.normalized()
		elif collision_object.collider.name == "Enemy":
			velocity = (position - enemy_paddle.position)
			speed = start_speed + velocity.length() * 5
			velocity = velocity.normalized()
		else:
			velocity = velocity.bounce(collision_object.normal)
		$Hit.play()
	else: $Hit.stop()
		
func stop_ball():
	speed = 0

func activate_ball(side, score):
	start_speed = 600 + score * 25
	speed = start_speed
	visible = true
	velocity.x = side
	velocity.y = randi() % 80 / 90.0 * [-1,1][randi() % 2]
	velocity = velocity.normalized()
