extends KinematicBody2D

var speed
var texture = preload("res://Assets/red_ball.png")
var sprite = Sprite.new()
var toughness

var collided
var initial_pos
var collided_timer = 0.0

func _ready():
    sprite.texture = texture
    sprite.scale = Vector2(0.5, 0.5)
    add_child(sprite)

    speed = get_node("/root/SceneVariables").red_ball_speed
    toughness = get_node("/root/SceneVariables").red_ball_strength
    initial_pos = position

func _physics_process(delta):
    var target
    if collided:
        target = initial_pos
        collided_timer += delta
    else:
        target = get_node("/root/SceneVariables").center_location

    var velocity = (target - position).normalized() * speed * delta

    if (target - position).length() > 5:
        var collision = move_and_collide(velocity)
        handle_collision_with_barrier()
    else:
        destroy(true)

    if position == initial_pos || collided_timer > get_node("/root/SceneVariables").collision_timer:
        collided = false
        collided_timer = 0.0

func collided_with_barrier():
    var barrier = get_tree().get_root().get_node("World/Barrier")
    var pos_relative_to_ring_center = barrier.convert_to_ring_relative_coords(position)
    return barrier.is_on_ring(pos_relative_to_ring_center) && barrier.angles[int(floor(barrier.get_angle_between_position_and_ring_origin(pos_relative_to_ring_center)))]

func handle_collision_with_barrier():
    if collided_with_barrier():
        if toughness > 0:
            toughness -= 1
            collided = true
            var barrier = get_tree().get_root().get_node("World/Barrier")
            barrier.damage_barrier()
            get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").red_ball_hit_barrier)
        else:
            destroy(false)

func destroy(reached_center):
    if not reached_center:
        get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").red_ball_points_destroy)
    else:
        get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").red_ball_reached_center)
        get_node("/root/SceneVariables").remove_life()

    queue_free()
