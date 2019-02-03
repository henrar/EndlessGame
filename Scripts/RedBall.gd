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
    prepare_textures()

    set_ship_sprite(0, 0)
    add_child(sprite)

    speed = get_node("/root/SceneVariables").red_ball_speed
    toughness = get_node("/root/SceneVariables").red_ball_strength
    initial_pos = position

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

func collide_with_ball():
    get_node("/root/ScoreTracker").add_score(get_node("/root/SceneVariables").red_ball_collide)
    queue_free()

func add_collision_shape():
    collision_shape = CollisionShape2D.new()
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 20.0
    collision_shape.shape = circle_shape
    add_child(collision_shape)

func set_ship_sprite(index, type):
    sprite.texture = textures[type][index]
    sprite.scale = Vector2(0.1, 0.1)
    
func prepare_textures():
    textures.resize(3)
    for i in range (0, 3):
        textures[i] = []

    textures[0].append(preload("res://Assets/ships/enemy1/enemy-full.png"))
    textures[0].append(preload("res://Assets/ships/enemy1/enemy-2.png"))
    textures[0].append(preload("res://Assets/ships/enemy1/enemy-3.png"))    

    textures[1].append(preload("res://Assets/ships/enemy2/enemy-2.png"))
    textures[1].append(preload("res://Assets/ships/enemy2/enemy-2-1.png"))
    textures[1].append(preload("res://Assets/ships/enemy2/enemy-2-2.png"))    

    textures[2].append(preload("res://Assets/ships/enemy3/enemy-3-1.png"))
    textures[2].append(preload("res://Assets/ships/enemy3/enemy-3-2.png"))
    textures[2].append(preload("res://Assets/ships/enemy3/enemy-3-3.png"))    
