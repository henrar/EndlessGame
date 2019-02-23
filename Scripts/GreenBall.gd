extends KinematicBody2D

var speed

var texture = preload("res://Assets/ships/friend/Friend.png")
var collision_shape
var sprite = Sprite.new()
var toughness

var collided_with_barrier = false
var collided_with_ball = false
var initial_pos
var collided_timer = 0.0

var carried_powerup
var GoodPowerup = preload("res://Scripts/GoodPowerup.gd")
onready var scene_variables = get_node("/root/SceneVariables")
onready var barrier = get_tree().get_root().get_node("GameWorld/Barrier")
onready var score_tracker = get_node("/root/ScoreTracker")

var target

func _ready():
    target = scene_variables.center_location
    speed = scene_variables.green_ball_speed
    toughness = scene_variables.green_ball_strength
    initial_pos = position

    set_ship_sprite(toughness)
    add_child(sprite)

    add_collision_shape()

func _process(delta):
    if collided_with_barrier:
        target = initial_pos
        collided_timer += delta
    else:
        target = scene_variables.center_location

    var velocity = (target - position).normalized() * speed * delta

    look_at(target)
    update_powerup_position()

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
            set_ship_sprite(toughness)
            score_tracker.add_score(scene_variables.green_ball_hit_barrier)
        else:
            barrier.damage_barrier()
            destroy(false)

func destroy(reached_center):
    if reached_center:
        score_tracker.add_score(scene_variables.green_ball_reached_center)
        scene_variables.add_paint()
        if carried_powerup:
            carried_powerup.execute_effect()
    else:
        score_tracker.add_score(scene_variables.green_ball_points_destroy)

    queue_free()
    
func collide_with_ball():
    if not collided_with_ball:
        collided_with_ball = true
        score_tracker.add_score(scene_variables.green_ball_collide)
        queue_free()

func add_collision_shape():
    var scale_factor = Vector2(get_viewport().size.x / 1920.0, get_viewport().size.y / 1080.0)
    collision_shape = CollisionShape2D.new()
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 20.0 * scale_factor.x
    collision_shape.shape = circle_shape
    add_child(collision_shape)

func set_ship_sprite(life):
    var scale_factor = Vector2(get_viewport().size.x / 1920.0, get_viewport().size.y / 1080.0)
    sprite.texture = texture
    sprite.scale = Vector2(scale_factor.x * 0.05, scale_factor.y * 0.05)

func set_powerup(type, scale_factor):
    carried_powerup = GoodPowerup.new()
    carried_powerup.set_type(type)
    var powerup_position = Vector2(-60.0 * scale_factor.x, 0.0 * scale_factor.y)
    carried_powerup.set_position(powerup_position)
    carried_powerup.set_texture(scale_factor)
    carried_powerup.set_name("Powerup")
    add_child(carried_powerup)

func update_powerup_position():
    if get_child_count() > 2 && get_child(0).get_name() == "Powerup":
        var powerup_position = Vector2(-60.0 * scene_variables.scale_factor.x, 0.0 * scene_variables.scale_factor.y)
        carried_powerup.set_position(powerup_position)
        carried_powerup.set_rotation(-get_rotation())
