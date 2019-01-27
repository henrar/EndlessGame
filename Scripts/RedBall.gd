extends KinematicBody2D

var speed
var texture = preload("res://Assets/red_ball.png")
var sprite = Sprite.new()
var toughness

func _ready():
	sprite.texture = texture
	sprite.scale = Vector2(0.5, 0.5)
	add_child(sprite)

	speed = get_node("/root/SceneVariables").ball_speed
	toughness = get_node("/root/SceneVariables").ball_strength

func _physics_process(delta):
	var target = get_node("/root/SceneVariables").center_location
	var velocity = (target - position).normalized() * speed * delta

	if (target - position).length() > 5:
		var collision = move_and_collide(velocity)
		handle_collision_with_barrier()
	else:
		destroy(true)

func collided_with_barrier():
	var barrier = get_tree().get_root().get_node("World/Barrier")
	var pos_relative_to_ring_center = barrier.convert_to_ring_relative_coords(position)
	return barrier.is_on_ring(pos_relative_to_ring_center) && barrier.angles[int(floor(barrier.get_angle_between_position_and_ring_origin(pos_relative_to_ring_center)))]

func handle_collision_with_barrier():
	if collided_with_barrier():
		if toughness > 0:
			toughness -= 1
		else:
			destroy(false)

func destroy(reached_center):
	if not reached_center:
		get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").points_per_ball)
	else:
		get_node("/root/SceneVariables").remove_life()

	queue_free()
