extends KinematicBody2D

var speed
var texture = preload("res://Assets/green_ball.png")
var sprite = Sprite.new()

func _ready():
	sprite.texture = texture
	sprite.scale = Vector2(0.5, 0.5)
	add_child(sprite)

	speed = get_node("/root/SceneVariables").ball_speed

	pass

func _physics_process(delta):
	var target = get_node("/root/SceneVariables").center_location
	var velocity = (target - position).normalized() * speed

	if (target - position).length() > 5:
		var collision = move_and_collide(velocity)
	else:
		queue_free()	

	pass

