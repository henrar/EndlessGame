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
var ExplosionParticle = preload("res://Scenes/ExplosionMothershipRed.tscn")
var ExplosionBarrierParticle = preload("res://Scenes/ExplosionBarrierWhite.tscn")
var EngineParticle = preload("res://Scenes/EngineParticlesRed.tscn")

onready var scene_variables = get_node("/root/SceneVariables")
onready var barrier = get_tree().get_root().get_node("GameWorld/Barrier")
onready var score_tracker = get_node("/root/ScoreTracker")
onready var upgrade_tracker = get_node("/root/UpgradeTracker")
onready var audio_player = get_node("/root/AudioPlayer")

var target

func _ready():
    target = scene_variables.center_location

    prepare_textures()

    speed = scene_variables.red_ball_speed[ship_type]
    toughness = scene_variables.red_ball_strength[ship_type]

    set_ship_sprite(ship_type, toughness)
    add_child(sprite)

    initial_pos = position

    add_collision_shape()

    var particle_position = Vector2(-20.0 * scene_variables.scale_factor.x, 0.0 * scene_variables.scale_factor.y)
    var engine_particle = EngineParticle.instance()
    engine_particle.get_node("EngineParticles").process_material.color = Color(1.0, 0.0, 0.0)
    add_child(engine_particle)
    engine_particle.position = particle_position

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
            var explosion_particle = ExplosionParticle.instance()
            explosion_particle.global_position = global_position
            get_tree().get_root().get_node("GameWorld").add_child(explosion_particle)
            var particle = explosion_particle.get_node("ExplosionParticle")
            particle.emitting = true
            particle.process_material.color = Color(1.0, 0.0, 0.0)
            destroy(true)
        else:
            var explosion_particle = ExplosionParticle.instance()
            explosion_particle.global_position = global_position
            get_tree().get_root().get_node("GameWorld").add_child(explosion_particle)
            var particle = explosion_particle.get_node("ExplosionParticle")
            particle.emitting = true
            particle.process_material.color = Color(1.0, 0.5, 0.0)
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_SHIP_COLLISION)
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
        if upgrade_tracker.current_upgrades[3]:
            barrier.damage_barrier()
            explode_on_barrier()
            destroy(false)
            return
        if toughness > 0:
            toughness -= 1
            collided_with_barrier = true
            set_ship_sprite(ship_type, toughness)
            barrier.damage_barrier()
            score_tracker.add_score(scene_variables.red_ball_hit_barrier[ship_type])
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_BARRIER_COLLISION_BOUNCE)
        else:
            barrier.damage_barrier()
            explode_on_barrier()
            destroy(false)

func destroy(reached_center):
    if not reached_center:
        score_tracker.add_score(scene_variables.red_ball_points_destroy[ship_type])
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_BARRIER_COLLISION_DESTROY)
    else:
        score_tracker.add_score(scene_variables.red_ball_reached_center[ship_type])
        scene_variables.remove_life()
        if carried_powerup:
            carried_powerup.execute_effect()

        audio_player.play_sound_effect(audio_player.SoundEffect.SE_MOTHERSHIP_HIT_RED)

    queue_free()

func collide_with_ball():
    if not collided_with_ball:
        collided_with_ball = true
        score_tracker.add_score(scene_variables.red_ball_collide[ship_type])
        queue_free()

func add_collision_shape():
    var scale_factor = Vector2(get_viewport().size.x / 1920.0, get_viewport().size.y / 1080.0)
    collision_shape = CollisionShape2D.new()
    var circle_shape = CircleShape2D.new()
    circle_shape.radius = 20.0 * scale_factor.x
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

    var scale_factor = Vector2(get_viewport().size.x / 1920.0, get_viewport().size.y / 1080.0)
    sprite.texture = textures[type][index]
    sprite.scale = Vector2(scale_factor.x * 0.05, scale_factor.y * 0.05)

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

func set_powerup(type, scale_factor):
    carried_powerup = BadPowerup.new()
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

func restore_speed():
    if old_speed:
        speed = old_speed

func slowdown():
    old_speed = speed
    speed -= scene_variables.enemy_ship_slowdown_modifier

func speedup():
    old_speed = speed
    speed += scene_variables.enemy_ship_speedup_modifier

func explode_on_barrier():
    var explosion_particle = ExplosionBarrierParticle.instance()
    explosion_particle.global_position = global_position
    get_tree().get_root().get_node("GameWorld").add_child(explosion_particle)
    var particle = explosion_particle.get_node("ExplosionParticle")
    particle.emitting = true
    particle.process_material.color = Color(1.0, 1.0, 1.0)
