extends KinematicBody2D

var speed

var textures = []
var collision_shape
var sprite = Sprite.new()
var toughness

var collided_with_barrier
var initial_pos
var collided_timer = 0.0

func _ready():
    textures.append(preload("res://Assets/ships/friend/friend-full.png"))
    textures.append(preload("res://Assets/ships/friend/friend-2.png"))
    textures.append(preload("res://Assets/ships/friend/friend-3.png"))

    speed = get_node("/root/SceneVariables").green_ball_speed
    toughness = get_node("/root/SceneVariables").green_ball_strength
    initial_pos = position

    set_ship_sprite(toughness)
    add_child(sprite)

    add_collision_shape()

func _physics_process(delta):
    var target
    if collided_with_barrier:
        target = initial_pos
        collided_timer += delta
    else:
        target = get_node("/root/SceneVariables").center_location

    var velocity = (target - position).normalized() * speed * delta

    sprite.look_at(target)

    if (target - position).length() > 5:
        var collision = move_and_collide(velocity)
        if collision:
            collision.collider.collide_with_ball()
        handle_collision_with_barrier()
    else:
        destroy(true)

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
    else:
        get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").green_ball_points_destroy)

    queue_free()

func collide_with_ball():
    get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").green_ball_collide)
    queue_free()

func add_collision_shape():
    collision_shape = CollisionShape2D.new()
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 20.0
    collision_shape.shape = circle_shape
    add_child(collision_shape)

func set_ship_sprite(life):
    var index = 2 - life
    if index < 0:
        index = 0
    sprite.texture = textures[index]
    sprite.scale = Vector2(0.1, 0.1)

