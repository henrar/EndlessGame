extends KinematicBody2D

var speed

var textures = []
var collision_shape
var sprite = Sprite.new()
var toughness

var collided_with_barrier = false
var collided_with_ball = false
var initial_pos
var collided_timer = 0.0

var carried_powerup
var GoodPowerup = preload("res://Scripts/GoodPowerup.gd")

func _ready():
    set_name("GreenBall")

    textures.append(preload("res://Assets/ships/friend/Friend.png"))

    speed = get_node("/root/SceneVariables").green_ball_speed
    toughness = get_node("/root/SceneVariables").green_ball_strength
    initial_pos = position

    set_ship_sprite(toughness)
    add_child(sprite)

    add_collision_shape()

func _process(delta):
    var target
    if collided_with_barrier:
        target = initial_pos
        collided_timer += delta
    else:
        target = get_node("/root/SceneVariables").center_location

    var velocity = (target - position).normalized() * speed * delta

    sprite.look_at(target)

    var collision = move_and_collide(velocity)
    if collision:
        if collision.collider.get_name() == "Mothership":
            destroy(true)
        else:
            collision.collider.collide_with_ball()
            collide_with_ball()
    handle_collision_with_barrier()

    if position == initial_pos || collided_timer > get_node("/root/SceneVariables").collision_timer:
        collided_with_barrier = false
        collided_timer = 0.0

func did_collide_with_barrier():
    var barrier = get_tree().get_root().get_node("World/Barrier")
    var pos_relative_to_ring_center = barrier.convert_to_ring_relative_coords(position)
    return barrier.is_on_ring(pos_relative_to_ring_center) && barrier.angles[int(floor(barrier.get_angle_between_position_and_ring_origin(pos_relative_to_ring_center)))]

func handle_collision_with_barrier():
    if did_collide_with_barrier():
        if toughness > 0:
            toughness -= 1
            collided_with_barrier = true
            set_ship_sprite(toughness)
            get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").green_ball_hit_barrier)
        else:
            var barrier = get_tree().get_root().get_node("World/Barrier")
            barrier.damage_barrier()
            destroy(false)

func destroy(reached_center):
    if reached_center:
        get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").green_ball_reached_center)
        get_node("/root/SceneVariables").add_paint()
        if carried_powerup:
            carried_powerup.execute_effect()
    else:
        get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").green_ball_points_destroy)

    queue_free()
    
func collide_with_ball():
    if not collided_with_ball:
        collided_with_ball = true
        get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").green_ball_collide)
        queue_free()

func add_collision_shape():
    collision_shape = CollisionShape2D.new()
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 20.0
    collision_shape.shape = circle_shape
    add_child(collision_shape)

func set_ship_sprite(life):
    sprite.texture = textures[0]
    sprite.scale = Vector2(0.05, 0.05)

func set_powerup(type):
    carried_powerup = GoodPowerup.new()
    carried_powerup.set_type(type)
    carried_powerup.set_position(Vector2(20.0, 20.0))
    add_child(carried_powerup)
