extends KinematicBody2D

var speed
var texture = preload("res://Assets/green_ball.png")
var sprite = Sprite.new()

func _ready():
	sprite.texture = texture
	sprite.scale = Vector2(0.5, 0.5)
	add_child(sprite)

	speed = get_node("/root/SceneVariables").ball_speed

func _physics_process(delta):
	var target = get_node("/root/SceneVariables").center_location
	var velocity = (target - position).normalized() * speed * delta

	if (target - position).length() > 5:
		var collision = move_and_collide(velocity)
	else:
		destroy(true)

func destroy(reached_center):
	if reached_center:
		get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").points_per_ball)
		get_node("/root/SceneVariables").add_paint()

	queue_free()
