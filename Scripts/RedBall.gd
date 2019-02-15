extends KinematicBody2D

var speed
var old_speed
var textures = []
var collision_shape
var sprite = Sprite.new()
var toughness

var collided_with_barrier = false
var collided_with_ball = false
var initial_pos
var collided_timer = 0.0
var ship_type

var carried_powerup
var BadPowerup = preload("res://Scripts/BadPowerup.gd")

onready var scene_variables = get_node("/root/SceneVariables")
onready var barrier = get_tree().get_root().get_node("World/Barrier")
onready var score_tracker = get_node("/root/ScoreTracker")

func _ready():
    prepare_textures()

    speed = scene_variables.red_ball_speed[ship_type]
    toughness = scene_variables.red_ball_strength[ship_type]

    set_ship_sprite(ship_type, toughness)
    add_child(sprite)

    initial_pos = position

    add_collision_shape()

func _process(delta):
    var target
    if collided_with_barrier:
        target = initial_pos
        collided_timer += delta
    else:
        target = scene_variables.center_location

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

    if position == initial_pos || collided_timer > scene_variables.collision_timer:
        collided_with_barrier = false
        collided_timer = 0.0

func did_collide_with_barrier():
    var pos_relative_to_ring_center = barrier.convert_to_ring_relative_coords(position)
    return barrier.is_on_ring(pos_relative_to_ring_center) && barrier.angles[int(floor(barrier.get_angle_between_position_and_ring_origin(pos_relative_to_ring_center)))]

func handle_collision_with_barrier():
    if did_collide_with_barrier():
        if toughness > 0:
            toughness -= 1
            collided_with_barrier = true
            set_ship_sprite(ship_type, toughness)
            barrier.damage_barrier()
            score_tracker.add_score(scene_variables.red_ball_hit_barrier[ship_type])
        else:
            barrier.damage_barrier()
            destroy(false)

func destroy(reached_center):
    if not reached_center:
        score_tracker.add_score(scene_variables.red_ball_points_destroy[ship_type])
    else:
        score_tracker.add_score(scene_variables.red_ball_reached_center[ship_type])
        scene_variables.remove_life()
        if carried_powerup:
            carried_powerup.execute_effect()

    queue_free()

func collide_with_ball():
    if not collided_with_ball:
        collided_with_ball = true
        score_tracker.add_score(scene_variables.red_ball_collide[ship_type])
        queue_free()

func add_collision_shape():
    collision_shape = CollisionShape2D.new()
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 20.0
    collision_shape.shape = circle_shape
    add_child(collision_shape)

func set_ship_sprite(type, life):
    var index = 0
    if type == scene_variables.RedBallTypes.SHIP_3:
        index = 2 - life
    elif type == scene_variables.RedBallTypes.SHIP_2:
        index = 1 - life
    elif type == scene_variables.RedBallTypes.SHIP_1:
        index = 0

    if index < 0:
        index = 0
    sprite.texture = textures[type][index]
    sprite.scale = Vector2(0.05, 0.05)

func prepare_textures():
    textures.resize(3)
    for i in range (0, 3):
        textures[i] = []

    textures[0].append(preload("res://Assets/ships/enemy1/EnemyLevel1.png"))

    textures[1].append(preload("res://Assets/ships/enemy2/EnemyLevel2.png"))
    textures[1].append(preload("res://Assets/ships/enemy2/EnemyLevel2-first_strike.png"))

    textures[2].append(preload("res://Assets/ships/enemy3/EnemyLevel3.png"))
    textures[2].append(preload("res://Assets/ships/enemy3/EnemyLevel3-first_strike.png"))
    textures[2].append(preload("res://Assets/ships/enemy3/EnemyLevel3-second_strike.png"))

func set_powerup(type):
    carried_powerup = BadPowerup.new()
    carried_powerup.set_type(type)
    carried_powerup.set_position(Vector2(20.0, 20.0))
    add_child(carried_powerup)

func restore_speed():
    if old_speed:
        speed = old_speed

func slowdown():
    old_speed = speed
    old_speed -= scene_variables.enemy_ship_slowdown_modifier

func speedup():
    old_speed = speed
    old_speed += scene_variables.enemy_ship_speedup_modifier