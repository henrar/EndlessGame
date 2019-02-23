extends Node

var session_timer = 0.0 #global session timer, do not touch this

#configuration
var initial_paint = 45 #how much paint we have at the beginning
var paint_score_modifier = 15 #increases initial paint when score reaches certain threshold
const ring_radius_percentage_of_viewport = 0.8 #size of the ring-barrier
const initial_lives = 3

#score configuration
const high_score_threshold = 500 #we get initial_paint + modifier * (previous_session_score % threshold)
const score_time_addition = 10
const score_time_addition_interval = 1.0

#barrier
var barrier_erect_speed = 5 #per second
var barrier_strength = 0 

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
var red_ball_speed = [red_ball_base_speed[RedBallTypes.SHIP_1], red_ball_base_speed[RedBallTypes.SHIP_2], red_ball_base_speed[RedBallTypes.SHIP_3]]

const red_ball_speed_modifier = [10.0, 10.0, 10.0]
const red_ball_speed_modifier_interval = [60.0, 60.0, 60.0]

const red_ball_base_spawn_rate = [1, 1, 1] #per interval
var red_ball_spawn_rate = red_ball_base_spawn_rate 

const red_ball_base_spawn_interval = [5.0, 19.0, 31.0] #interval (seconds)
var red_ball_spawn_interval = red_ball_base_spawn_interval 
const red_ball_spawn_rate_modifier = [1, 1, 1]
const red_ball_spawn_rate_interval_modifier = [0.0, 0.0, 0.0]
const red_ball_spawn_rate_timer = [60.0, 60.0, 60.0]

const red_ball_strength = [0, 1, 2]
const red_ball_points_destroy = [10, 15, 20]
const red_ball_reached_center = [0, 0, 0]
const red_ball_hit_barrier = [10, 15, 20]
const red_ball_collide = [10, 15, 20]

#upgrade cost
enum UpgradeTypes {UPGRADE_STURDY = 0, UPGRADE_MACH_EFFECT = 1, UPGRADE_RESOURCEFUL = 2, UPGRADE_LETHAL_DEFENCE = 3, UPGRADE_NUM = 4} 
const upgrade_cost = [10, 5, 15, 20]

#powerups variables
#types
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

#graphics
const virtual_resolution_x = 1920.0
const virtual_resolution_y = 1080.0
var scale_factor

onready var score_tracker = get_node("/root/ScoreTracker")
onready var upgrade_tracker = get_node("/root/UpgradeTracker")

func _ready():
    get_tree().set_auto_accept_quit(false)
    scale_factor = Vector2(get_viewport().size.x / virtual_resolution_x, get_viewport().size.y / virtual_resolution_y)
    center_location = Vector2(get_viewport().size.x / 2.0, get_viewport().size.y / 2.0)
    reinit_variables()

func _process(delta):
    if get_tree().get_current_scene().get_name() == "GameWorld":
        session_timer += delta

        update_ball_speed()
        update_ball_spawn_rate()
        update_score()
        update_powerups()

func update_ball_spawn_rate():
    if fmod(session_timer, green_ball_spawn_rate_timer) <= 0.01:
        green_ball_spawn_rate += green_ball_spawn_rate_modifier
        if green_ball_spawn_interval - green_ball_spawn_rate_interval_modifier > 1.0:
            green_ball_spawn_interval -= green_ball_spawn_rate_interval_modifier

    for i in range(0, 3):   
        if fmod(session_timer, red_ball_spawn_rate_timer[i]) <= 0.01:
            red_ball_spawn_rate[i] += red_ball_spawn_rate_modifier[i]
            if red_ball_spawn_interval[i] - red_ball_spawn_rate_interval_modifier[i] > 1.0:
                red_ball_spawn_interval[i] -= red_ball_spawn_rate_interval_modifier[i]     

    if fmod(session_timer, gold_ball_spawn_rate_timer) <= 0.01:
        gold_ball_spawn_rate += gold_ball_spawn_rate_modifier
        if gold_ball_spawn_interval - gold_ball_spawn_rate_interval_modifier > 1.0:
            gold_ball_spawn_interval -= gold_ball_spawn_rate_interval_modifier        

func update_ball_speed():
    if fmod(session_timer, green_ball_speed_modifier_interval) <= 0.01:
        green_ball_speed += green_ball_speed_modifier

    for i in range(0, 3):
        if fmod(session_timer, red_ball_speed_modifier_interval[i]) <= 0.01:
            red_ball_speed[i] += red_ball_speed_modifier[i]   
        
    if fmod(session_timer, gold_ball_speed_modifier_interval) <= 0.01:
        gold_ball_speed += gold_ball_speed_modifier    

func update_score():
    if fmod(session_timer, score_time_addition_interval) <= 0.01:
        score_tracker.add_score(score_time_addition)

func update_powerups():
    if speed_up_barrier_triggered && session_timer - speed_up_barrier_start_time >= speed_up_barrier_time:
        speed_up_barrier_triggered = false
        barrier_erect_speed = old_barrier_speed

    if enemy_ship_slowdown_triggered && session_timer - enemy_ship_slowdown_start_time >= enemy_ship_slowdown_time:
        enemy_ship_slowdown_triggered = false
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is RedBall:
                node.restore_speed()
    
    if strengthen_barrier_triggered && session_timer - strengthen_barrier_start_time >= strengthen_barrier_time:
        strengthen_barrier_triggered = false
        barrier_strength = old_barrier_strength

    if add_life_powerup_drop_triggered_timer && session_timer - add_life_time_start >= add_life_time:
        add_life_powerup_drop = true
        add_life_powerup_drop_triggered_timer = false

    if slow_down_barrier_triggered && session_timer - slow_down_barrier_start_time >= slow_down_barrier_time:
        slow_down_barrier_triggered = false
        barrier_erect_speed = old_barrier_speed

    if enemy_ship_speedup_triggered && session_timer - enemy_ship_speedup_start_time >= enemy_ship_speedup_time:
        enemy_ship_speedup_triggered = false
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is RedBall:
                node.restore_speed()

    if weaken_barrier_triggered && session_timer - weaken_barrier_start_time >= weaken_barrier_time:
        weaken_barrier_triggered = false
        barrier_strength = old_barrier_strength

func reinit_variables():
    current_lives = initial_lives
    current_paint_level = initial_paint

    green_ball_speed = green_ball_base_speed
    green_ball_spawn_rate = green_ball_base_spawn_rate
    green_ball_spawn_interval = green_ball_base_spawn_interval

    for i in range(0, RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_speed[i] = red_ball_base_speed[i]
        red_ball_spawn_rate[i] = red_ball_base_spawn_rate[i]
        red_ball_spawn_interval[i] = red_ball_base_spawn_interval[i]

    gold_ball_speed = gold_ball_base_speed
    gold_ball_spawn_rate = gold_ball_base_spawn_rate
    gold_ball_spawn_interval = gold_ball_base_spawn_interval

func restart_game():
    score_tracker.save_score()
    reinit_variables()
    session_timer = 0.0
    get_tree().change_scene("res://Scenes/EndSessionScreen.tscn")

func remove_life():
    if current_lives > 0:
        current_lives -= 1
        current_paint_level = initial_paint

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
        restart_game()

func add_life():
    if current_lives < initial_lives:
        current_lives += 1
        var mothership = get_tree().get_root().get_node("GameWorld/Mothership")
        mothership.set_sprite_based_on_life()

func add_paint():
    current_paint_level += paint_score_modifier

func substract_paint():
    if current_paint_level > 0:
        current_paint_level -= 1

func execute_good_powerup(type):
    if type == GoodPowerupTypes.SPEED_UP_BARRIER:
        if not speed_up_barrier_triggered && not slow_down_barrier_triggered:
            speed_up_barrier_triggered = true
            speed_up_barrier_start_time = session_timer
            old_barrier_speed = barrier_erect_speed
            barrier_erect_speed += speed_up_barrier_modifier
    elif type == GoodPowerupTypes.ENEMY_SHIP_SLOWDOWN:
        if not enemy_ship_slowdown_triggered && not enemy_ship_speedup_triggered:
            enemy_ship_slowdown_triggered = true
            enemy_ship_slowdown_start_time = session_timer
            for node in get_tree().get_root().get_node("GameWorld").get_children():
                if node is RedBall:
                    node.slowdown()
    elif type == GoodPowerupTypes.STRENGTHEN_BARRIER:
        if not strengthen_barrier_triggered && barrier_strength < 3 && not weaken_barrier_triggered:
            strengthen_barrier_triggered = true
            strengthen_barrier_start_time = session_timer
            old_barrier_strength = barrier_strength
            barrier_strength += strengthen_barrier_modifier
    elif type == GoodPowerupTypes.ADD_LIFE:
        add_life()
    elif type == GoodPowerupTypes.GOOD_NUKE:
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is RedBall:
                node.destroy(false)

func execute_bad_powerup(type):
    if type == BadPowerupTypes.SLOW_DOWN_BARRIER:
        if not slow_down_barrier_triggered && not speed_up_barrier_triggered:
            slow_down_barrier_triggered = true
            slow_down_barrier_start_time = session_timer
            old_barrier_speed = barrier_erect_speed
            barrier_erect_speed -= weaken_barrier_modifier
    elif type == BadPowerupTypes.ENEMY_SHIP_SPEEDUP:
        if not enemy_ship_speedup_triggered && not enemy_ship_slowdown_triggered:
            enemy_ship_speedup_triggered = true
            enemy_ship_speedup_start_time = session_timer
            for node in get_tree().get_root().get_node("GameWorld").get_children():
                if node is RedBall:
                    node.speedup()
    elif type == BadPowerupTypes.WEAKEN_BARRIER:
        if not weaken_barrier_triggered && barrier_strength > 0 && not strengthen_barrier_triggered:
            weaken_barrier_triggered = true
            weaken_barrier_start_time = session_timer
            old_barrier_strength = barrier_strength
            barrier_strength -= weaken_barrier_modifier
    elif type == BadPowerupTypes.BAD_NUKE:
        for node in get_tree().get_root().get_node("GameWorld").get_children():
            if node is GreenBall || node is GoldBall:
                node.destroy(false)

        