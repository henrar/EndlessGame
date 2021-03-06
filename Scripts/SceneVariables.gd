extends Node

var session_timer = 0.0 #global session timer, do not touch this

#configuration
const initial_paint_no_bonus = 45;
var initial_paint = initial_paint_no_bonus #how much paint we have at the beginning
var paint_score_modifier = 15 #increases initial paint when score reaches certain threshold
const ring_radius_percentage_of_viewport = 0.8 #size of the ring-barrier
const initial_lives = 3

#score configuration
const high_score_threshold = 500 #we get initial_paint + modifier * (previous_session_score % threshold)
const score_time_addition = 10
const score_time_addition_interval = 1.0

#barrier
var barrier_erect_speed = 5 #per second
const base_barrier_strenth = 0
var barrier_strength = base_barrier_strenth

#ball behavior
var collision_timer = 2.0 #how long will it take for a ship to return from a barrier bounce to normal state

#gold ball configuration
const gold_ball_base_speed = 200.0 #base speed, gold_ball_speed is the current one
var gold_ball_speed = green_ball_base_speed
const gold_ball_speed_modifier = 10.0
const gold_ball_speed_modifier_interval = 60.0

const gold_ball_base_spawn_rate = 1 #per interval
var gold_ball_spawn_rate = gold_ball_base_spawn_rate

const gold_ball_base_spawn_interval = 60.0 #interval (seconds)
var gold_ball_spawn_interval = gold_ball_base_spawn_interval
var gold_ball_spawn_rate_modifier = 1
var gold_ball_spawn_rate_interval_modifier = 0.0
var gold_ball_spawn_rate_timer = 60.0

const gold_ball_strength = 1
const gold_ball_points_destroy = 0 #destroyed by barrier
const gold_ball_reached_center = 0
const gold_ball_hit_barrier = 0
const gold_ball_collide = 0

#green ball configuration
const green_ball_base_speed = 200.0 #base speed, green_ball_speed is the current one
var green_ball_speed = green_ball_base_speed
const green_ball_speed_modifier = 10.0
const green_ball_speed_modifier_interval = 60.0

const green_ball_base_spawn_rate = 1 #per interval
var green_ball_spawn_rate = green_ball_base_spawn_rate

const green_ball_base_spawn_interval = 3.0 #interval (seconds)
var green_ball_spawn_interval = green_ball_base_spawn_interval
var green_ball_spawn_rate_modifier = 0
var green_ball_spawn_rate_interval_modifier = 0.0
var green_ball_spawn_rate_timer = 60.0

const green_ball_strength = 0
const green_ball_points_destroy = 0 #destroyed by barrier
const green_ball_reached_center = 10
const green_ball_hit_barrier = 0
const green_ball_collide = 0

#red ball configuration - arrays for values
enum RedBallTypes { SHIP_1 = 0, SHIP_2 = 1, SHIP_3 = 2, SHIP_TYPE_COUNT = 3 }

const red_ball_base_speed = [199.0, 151.0, 97.0]
var red_ball_speed = []

const red_ball_speed_modifier = [10.0, 10.0, 10.0]
const red_ball_speed_modifier_interval = [60.0, 60.0, 60.0]

const red_ball_base_spawn_rate = [1, 1, 1] #per interval
var red_ball_spawn_rate = []

const red_ball_base_spawn_interval = [5.0, 19.0, 31.0] #interval (seconds)
var red_ball_spawn_interval = []
const red_ball_spawn_rate_modifier = [1, 1, 1]
const red_ball_spawn_rate_interval_modifier = [0.0, 0.0, 0.0]
const red_ball_spawn_rate_timer = [60.0, 60.0, 60.0]

const red_ball_strength = [0, 1, 2]
const red_ball_points_destroy = [10, 15, 20]
const red_ball_reached_center = [0, 0, 0]
const red_ball_hit_barrier = [10, 15, 20]
const red_ball_collide = [10, 15, 20]

#upgrade cost
enum UpgradeTypes {UPGRADE_MACH_EFFECT = 0, UPGRADE_STURDY = 1, UPGRADE_RESOURCEFUL = 2, UPGRADE_LETHAL_DEFENCE = 3, UPGRADE_NUM = 4}
const upgrade_cost = [5, 10, 15, 20]

#powerups variables
#types
#DO NOT TOUCH ENUMS
enum GoodPowerupTypes { SPEED_UP_BARRIER = 0, ENEMY_SHIP_SLOWDOWN = 1, STRENGTHEN_BARRIER = 2, ADD_LIFE = 3, GOOD_NUKE = 4, GOOD_POWERUP_COUNT = 5 }
enum BadPowerupTypes { SLOW_DOWN_BARRIER = 0 , ENEMY_SHIP_SPEEDUP = 1, WEAKEN_BARRIER = 2, BAD_NUKE = 3, BAD_POWERUP_COUNT = 4}

const good_powerup_drop_probability = [ 0.05, 0.05, 0.0, 0.05, 0.05 ]
const bad_powerup_drop_probability = [ 0.1, 0.1, 0.1, 0.1 ]

#good ones
const speed_up_barrier_modifier = 1
const speed_up_barrier_time = 10.0

const enemy_ship_slowdown_modifier = 10.0
const enemy_ship_slowdown_time = 10.0

const strengthen_barrier_modifier = 1
const strengthen_barrier_time = 10.0

const add_life_time = 10.0

#bad ones
var slow_down_barrier_modifier = 1
var slow_down_barrier_time = 10.0

const enemy_ship_speedup_modifier = 20.0 #must be positive, we substract the value in RedBall.gd
const enemy_ship_speedup_time = 10.0

var weaken_barrier_modifier = 1.0
var weaken_barrier_time = 10.0

#powerup logic variables, DO NOT TOUCH
var add_life_time_start
var add_life_powerup_drop_triggered_timer = false
var add_life_powerup_drop = false

var speed_up_barrier_start_time
var speed_up_barrier_triggered = false

var enemy_ship_slowdown_start_time
var enemy_ship_slowdown_triggered = false

var strengthen_barrier_start_time
var strengthen_barrier_triggered = false

var slow_down_barrier_start_time
var slow_down_barrier_triggered = false

var enemy_ship_speedup_start_time
var enemy_ship_speedup_triggered = false

var weaken_barrier_start_time
var weaken_barrier_triggered = false
var old_barrier_speed
var old_barrier_strength

#on load variables
var center_location
var current_lives
var current_paint_level

#Types
var GreenBall = preload("res://Scripts/GreenBall.gd")
var RedBall = preload("res://Scripts/RedBall.gd")
var GoldBall = preload("res://Scripts/GoldBall.gd")
var NukeExplosion = preload("res://Scenes/NukeParticle.tscn")

#graphics
const virtual_resolution_x = 1920.0
const virtual_resolution_y = 1080.0
var scale_factor

onready var score_tracker = get_node("/root/ScoreTracker")
onready var upgrade_tracker = get_node("/root/UpgradeTracker")
onready var audio_player = get_node("/root/AudioPlayer")

var score_timer
var created_score_timer = false

var green_ball_speed_timer
var red_ball_speed_timer = []
var gold_ball_speed_timer

var green_ball_spawn_increase_timer
var red_ball_spawn_increase_timer = []
var gold_ball_spawn_increase_timer

func _ready():
    get_tree().set_auto_accept_quit(false)
    get_tree().set_quit_on_go_back(false)
    scale_factor = Vector2(get_viewport().size.x / virtual_resolution_x, get_viewport().size.y / virtual_resolution_y)
    center_location = Vector2(get_viewport().size.x / 2.0, get_viewport().size.y / 2.0)
    reinit_variables()

func add_speed_timers():
    green_ball_speed_timer = Timer.new()
    green_ball_speed_timer.set_name("GreenBallSpeedTimer")
    green_ball_speed_timer.one_shot = false
    green_ball_speed_timer.wait_time = green_ball_speed_modifier_interval
    green_ball_speed_timer.connect("timeout",self,"increase_green_ball_speed") 
    get_tree().get_root().get_node("GameWorld").add_child(green_ball_speed_timer)

    red_ball_speed_timer = []

    for i in range(RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_speed_timer.append(Timer.new())
        red_ball_speed_timer[i].set_name("RedBallSpeedTimer" + str(i))
        red_ball_speed_timer[i].one_shot = false
        red_ball_speed_timer[i].wait_time = red_ball_speed_modifier_interval[i]
        red_ball_speed_timer[i].connect("timeout",self,"increase_red_ball_speed", [i]) 
        get_tree().get_root().get_node("GameWorld").add_child(red_ball_speed_timer[i])

    gold_ball_speed_timer = Timer.new()
    gold_ball_speed_timer.set_name("GoldBallSpeedTimer")
    gold_ball_speed_timer.one_shot = false
    gold_ball_speed_timer.wait_time = gold_ball_speed_modifier_interval
    gold_ball_speed_timer.connect("timeout",self,"increase_gold_ball_speed") 
    get_tree().get_root().get_node("GameWorld").add_child(gold_ball_speed_timer)

func add_spawn_increase_timers():
    green_ball_spawn_increase_timer = Timer.new()
    green_ball_spawn_increase_timer.set_name("GreenBallSpawnIncreaseTimer")
    green_ball_spawn_increase_timer.one_shot = false
    green_ball_spawn_increase_timer.wait_time = green_ball_spawn_rate_timer
    green_ball_spawn_increase_timer.connect("timeout",self,"increase_green_ball_spawn_rate") 
    get_tree().get_root().get_node("GameWorld").add_child(green_ball_spawn_increase_timer)

    red_ball_spawn_increase_timer = []

    for i in range(RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_spawn_increase_timer.append(Timer.new())
        red_ball_spawn_increase_timer[i].set_name("RedBallSpawnIncreaseTimer" + str(i))
        red_ball_spawn_increase_timer[i].one_shot = false
        red_ball_spawn_increase_timer[i].wait_time = red_ball_spawn_rate_timer[i]
        red_ball_spawn_increase_timer[i].connect("timeout",self,"increase_red_ball_spawn_rate", [i]) 
        get_tree().get_root().get_node("GameWorld").add_child(red_ball_spawn_increase_timer[i])

    gold_ball_spawn_increase_timer = Timer.new()
    gold_ball_spawn_increase_timer.set_name("GoldBallSpawnIncreaseTimer")
    gold_ball_spawn_increase_timer.one_shot = false
    gold_ball_spawn_increase_timer.wait_time = gold_ball_spawn_rate_timer
    gold_ball_spawn_increase_timer.connect("timeout",self,"increase_gold_ball_spawn_rate") 
    get_tree().get_root().get_node("GameWorld").add_child(gold_ball_spawn_increase_timer)

func start_spawn_increase_timers():
    green_ball_spawn_increase_timer.start()
    for i in range(RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_spawn_increase_timer[i].start()
    gold_ball_spawn_increase_timer.start()

func stop_spawn_increase_timers():
    green_ball_spawn_increase_timer.stop()
    for i in range(RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_spawn_increase_timer[i].stop()
    gold_ball_spawn_increase_timer.stop()

func start_speed_timers():
    green_ball_speed_timer.start()
    for i in range(RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_speed_timer[i].start()
    gold_ball_speed_timer.start()

func stop_speed_timers():
    green_ball_speed_timer.stop()
    for i in range(RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_speed_timer[i].stop()
    gold_ball_speed_timer.stop()

func _process(delta):
    if get_tree().get_current_scene().get_name() == "GameWorld":
        session_timer += delta

        update_powerups()
    else:
        session_timer = 0.0

func increase_green_ball_spawn_rate():
    green_ball_spawn_rate += green_ball_spawn_rate_modifier
    if green_ball_spawn_interval - green_ball_spawn_rate_interval_modifier > 1.0:
        green_ball_spawn_interval -= green_ball_spawn_rate_interval_modifier

func increase_red_ball_spawn_rate(type):
    red_ball_spawn_rate[type] += red_ball_spawn_rate_modifier[type]
    if red_ball_spawn_interval[type] - red_ball_spawn_rate_interval_modifier[type] > 1.0:
        red_ball_spawn_interval[type] -= red_ball_spawn_rate_interval_modifier[type]

func increase_gold_ball_spawn_rate():
    gold_ball_spawn_rate += gold_ball_spawn_rate_modifier
    if gold_ball_spawn_interval - gold_ball_spawn_rate_interval_modifier > 1.0:
        gold_ball_spawn_interval -= gold_ball_spawn_rate_interval_modifier     

func increase_green_ball_speed():
    green_ball_speed += green_ball_speed_modifier

func increase_red_ball_speed(type):
    red_ball_speed[type] += red_ball_speed_modifier[type]

func increase_gold_ball_speed():
    gold_ball_speed += gold_ball_speed_modifier

func init_score_timer():
    if not created_score_timer:
        score_timer = Timer.new()
        score_timer.set_name("ScoreTimer")
        score_timer.one_shot = false
        score_timer.wait_time = score_time_addition_interval
        score_timer.connect("timeout",self,"update_score")
        get_tree().get_root().get_node("GameWorld").add_child(score_timer)
        score_timer.start()
        created_score_timer = true

func update_score():
    if get_tree().get_current_scene().get_name() == "GameWorld":
        score_tracker.add_score(score_time_addition)

func update_powerups():
    if speed_up_barrier_triggered && session_timer - speed_up_barrier_start_time >= speed_up_barrier_time:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_GOOD_POWERUP_ACTIVATE)
        speed_up_barrier_triggered = false
        barrier_erect_speed = old_barrier_speed

    if enemy_ship_slowdown_triggered && session_timer - enemy_ship_slowdown_start_time >= enemy_ship_slowdown_time:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_GOOD_POWERUP_ACTIVATE)
        enemy_ship_slowdown_triggered = false
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is RedBall:
                node.restore_speed()

    if strengthen_barrier_triggered && session_timer - strengthen_barrier_start_time >= strengthen_barrier_time:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_GOOD_POWERUP_ACTIVATE)
        strengthen_barrier_triggered = false
        barrier_strength = old_barrier_strength

    if add_life_powerup_drop_triggered_timer && session_timer - add_life_time_start >= add_life_time:
        add_life_powerup_drop = true
        add_life_powerup_drop_triggered_timer = false

    if slow_down_barrier_triggered && session_timer - slow_down_barrier_start_time >= slow_down_barrier_time:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_BAD_POWERUP_ACTIVATE)
        slow_down_barrier_triggered = false
        barrier_erect_speed = old_barrier_speed

    if enemy_ship_speedup_triggered && session_timer - enemy_ship_speedup_start_time >= enemy_ship_speedup_time:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_BAD_POWERUP_ACTIVATE)
        enemy_ship_speedup_triggered = false
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is RedBall:
                node.restore_speed()

    if weaken_barrier_triggered && session_timer - weaken_barrier_start_time >= weaken_barrier_time:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_BAD_POWERUP_ACTIVATE)
        weaken_barrier_triggered = false
        barrier_strength = old_barrier_strength

func reinit_variables():
    current_lives = initial_lives
    initial_paint = initial_paint_no_bonus
    current_paint_level = initial_paint

    green_ball_speed = green_ball_base_speed
    green_ball_spawn_rate = green_ball_base_spawn_rate
    green_ball_spawn_interval = green_ball_base_spawn_interval

    red_ball_speed = []
    red_ball_spawn_rate = []
    red_ball_spawn_interval = []
    for i in range(RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_speed.append(red_ball_base_speed[i])
        red_ball_spawn_rate.append(red_ball_base_spawn_rate[i])
        red_ball_spawn_interval.append(red_ball_base_spawn_interval[i])

    gold_ball_speed = gold_ball_base_speed
    gold_ball_spawn_rate = gold_ball_base_spawn_rate
    gold_ball_spawn_interval = gold_ball_base_spawn_interval

    speed_up_barrier_triggered = false
    slow_down_barrier_triggered = false

    enemy_ship_slowdown_triggered = false
    enemy_ship_speedup_triggered = false

    strengthen_barrier_triggered = false
    weaken_barrier_triggered = false

    speed_up_barrier_start_time = 0.0
    enemy_ship_slowdown_start_time = 0.0
    strengthen_barrier_start_time = 0.0
    slow_down_barrier_start_time = 0.0
    enemy_ship_speedup_start_time = 0.0
    weaken_barrier_start_time = 0.0

    add_life_powerup_drop = false
    add_life_powerup_drop_triggered_timer = false

    barrier_strength = base_barrier_strenth

func restart_game():
    score_tracker.save_score()
    upgrade_tracker.save_upgrades()
    upgrade_tracker.reset_upgrades()
    reinit_variables()
    session_timer = 0.0
    created_score_timer = false
    get_tree().change_scene("res://Scenes/EndSessionScreen.tscn")

func remove_life():
    if current_lives > 0:
        current_lives -= 1

        var barrier = get_tree().get_root().get_node("GameWorld/Barrier")
        barrier.input_pos = null
        barrier.clicked_within_ring = false
        barrier.clear_angles()

        var mothership = get_tree().get_root().get_node("GameWorld/Mothership")
        mothership.set_sprite_based_on_life()

        if current_lives == 0 && !add_life_powerup_drop_triggered_timer:
            add_life_time_start = session_timer
            add_life_powerup_drop_triggered_timer = true
    else:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_MOTHERSHIP_DESTROY)
        restart_game()

func add_life():
    if current_lives < initial_lives:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_LIFE_BONUS_ACTIVATE)
        current_lives += 1
        var mothership = get_tree().get_root().get_node("GameWorld/Mothership")
        mothership.set_sprite_based_on_life()

func add_paint():
    current_paint_level += paint_score_modifier
    if current_paint_level > initial_paint:
        current_paint_level = initial_paint

    if current_paint_level > 360:
        current_paint_level = 360

func substract_paint():
    if current_paint_level > 0:
        current_paint_level -= 1

func execute_good_powerup(type):
    if type == GoodPowerupTypes.SPEED_UP_BARRIER:
        if not speed_up_barrier_triggered && not slow_down_barrier_triggered:
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_GOOD_POWERUP_ACTIVATE)
            speed_up_barrier_triggered = true
            speed_up_barrier_start_time = session_timer
            old_barrier_speed = barrier_erect_speed
            barrier_erect_speed += speed_up_barrier_modifier
    elif type == GoodPowerupTypes.ENEMY_SHIP_SLOWDOWN:
        if not enemy_ship_slowdown_triggered && not enemy_ship_speedup_triggered:
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_GOOD_POWERUP_ACTIVATE)
            enemy_ship_slowdown_triggered = true
            enemy_ship_slowdown_start_time = session_timer
            for node in get_tree().get_root().get_node("GameWorld").get_children():
                if node is RedBall:
                    node.slowdown()
    elif type == GoodPowerupTypes.STRENGTHEN_BARRIER:
        if not strengthen_barrier_triggered && barrier_strength < 3 && not weaken_barrier_triggered:
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_GOOD_POWERUP_ACTIVATE)
            strengthen_barrier_triggered = true
            strengthen_barrier_start_time = session_timer
            old_barrier_strength = barrier_strength
            barrier_strength += strengthen_barrier_modifier
    elif type == GoodPowerupTypes.ADD_LIFE:
        add_life()
    elif type == GoodPowerupTypes.GOOD_NUKE:
        var nuke_explosion = NukeExplosion.instance()
        nuke_explosion.get_node("NukeParticles").emitting = true
        nuke_explosion.get_node("NukeParticles").process_material.color = Color(0.0, 1.0, 0.0)
        get_tree().get_root().get_node("GameWorld").add_child(nuke_explosion)
        nuke_explosion.global_position = center_location
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_NUKE_EXPLOSION)
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is RedBall:
                node.destroy(false)

func execute_bad_powerup(type):
    if type == BadPowerupTypes.SLOW_DOWN_BARRIER:
        if not slow_down_barrier_triggered && not speed_up_barrier_triggered:
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_BAD_POWERUP_ACTIVATE)
            slow_down_barrier_triggered = true
            slow_down_barrier_start_time = session_timer
            old_barrier_speed = barrier_erect_speed
            barrier_erect_speed -= weaken_barrier_modifier
    elif type == BadPowerupTypes.ENEMY_SHIP_SPEEDUP:
        if not enemy_ship_speedup_triggered && not enemy_ship_slowdown_triggered:
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_BAD_POWERUP_ACTIVATE)
            enemy_ship_speedup_triggered = true
            enemy_ship_speedup_start_time = session_timer
            for node in get_tree().get_root().get_node("GameWorld").get_children():
                if node is RedBall:
                    node.speedup()
    elif type == BadPowerupTypes.WEAKEN_BARRIER:
        if not weaken_barrier_triggered && barrier_strength > 0 && not strengthen_barrier_triggered:
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_BAD_POWERUP_ACTIVATE)
            weaken_barrier_triggered = true
            weaken_barrier_start_time = session_timer
            old_barrier_strength = barrier_strength
            barrier_strength -= weaken_barrier_modifier
    elif type == BadPowerupTypes.BAD_NUKE:
        var nuke_explosion = NukeExplosion.instance()
        nuke_explosion.get_node("NukeParticles").emitting = true
        nuke_explosion.get_node("NukeParticles").process_material.color = Color(1.0, 0.0, 0.0)
        get_tree().get_root().get_node("GameWorld").add_child(nuke_explosion)
        nuke_explosion.global_position = center_location
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_NUKE_EXPLOSION)
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is GreenBall || node is GoldBall:
                node.destroy(false)

