extends Node

var session_timer = 0.0 #global session timer, do not touch this

#configuration
var initial_paint = 45 #how much paint we have at the beginning
var paint_score_modifier = 15 #increases initial paint when score reaches certain threshold
const ring_radius_percentage_of_viewport = 0.8 #size of the ring-barrier
const initial_lives = 2

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
var gold_ball_speed_modifier = 10.0
var gold_ball_speed_modifier_interval = 60.0

const gold_ball_base_spawn_rate = 1 #per interval
var gold_ball_spawn_rate = gold_ball_base_spawn_rate 

const gold_ball_base_spawn_interval = 60.0 #interval (seconds)
var gold_ball_spawn_interval = gold_ball_base_spawn_interval 
var gold_ball_spawn_rate_modifier = 1
var gold_ball_spawn_rate_interval_modifier = 0.0
var gold_ball_spawn_rate_timer = 60.0

var gold_ball_strength = 1
var gold_ball_points_destroy = 10 #destroyed by barrier
var gold_ball_reached_center = 10
var gold_ball_hit_barrier = 10
var gold_ball_collide = 10

#green ball configuration
const green_ball_base_speed = 200.0 #base speed, green_ball_speed is the current one
var green_ball_speed = green_ball_base_speed
var green_ball_speed_modifier = 10.0
var green_ball_speed_modifier_interval = 60.0

const green_ball_base_spawn_rate = 1 #per interval
var green_ball_spawn_rate = green_ball_base_spawn_rate 

const green_ball_base_spawn_interval = 3.0 #interval (seconds)
var green_ball_spawn_interval = green_ball_base_spawn_interval 
var green_ball_spawn_rate_modifier = 0
var green_ball_spawn_rate_interval_modifier = 0.0
var green_ball_spawn_rate_timer = 60.0

var green_ball_strength = 0
var green_ball_points_destroy = 0 #destroyed by barrier
var green_ball_reached_center = 10
var green_ball_hit_barrier = 0
var green_ball_collide = 0

#red ball configuration - arrays for values
enum RedBallTypes { SHIP_1 = 0, SHIP_2 = 1, SHIP_3 = 2, SHIP_TYPE_COUNT = 3 }

const red_ball_base_speed = [199.0, 151.0, 97.0]
var red_ball_speed = [red_ball_base_speed[RedBallTypes.SHIP_1], red_ball_base_speed[RedBallTypes.SHIP_2], red_ball_base_speed[RedBallTypes.SHIP_3]]

var red_ball_speed_modifier = [10.0, 10.0, 10.0]
var red_ball_speed_modifier_interval = [60.0, 60.0, 60.0]

const red_ball_base_spawn_rate = [1, 1, 1] #per interval
var red_ball_spawn_rate = red_ball_base_spawn_rate 

const red_ball_base_spawn_interval = [5.0, 19.0, 31.0] #interval (seconds)
var red_ball_spawn_interval = red_ball_base_spawn_interval 
var red_ball_spawn_rate_modifier = [1, 1, 1]
var red_ball_spawn_rate_interval_modifier = [0.0, 0.0, 0.0]
var red_ball_spawn_rate_timer = [60.0, 60.0, 60.0]

var red_ball_strength = [0, 1, 2]
var red_ball_points_destroy = [10, 15, 20]
var red_ball_reached_center = [0, 0, 0]
var red_ball_hit_barrier = [10, 15, 20]
var red_ball_collide = [10, 15, 20]

#powerups variables
#types
enum GoodPowerupTypes { SPEED_UP_BARRIER = 0, ENEMY_SHIP_SLOWDOWN = 1, STRENGTHEN_BARRIER = 2, ADD_LIFE = 3, GOOD_NUKE = 4, GOOD_POWERUP_COUNT = 5 }
enum BadPowerupTypes { SLOW_DOWN_BARRIER = 0 , ENEMY_SHIP_SPEEDUP = 1, WEAKEN_BARRIER = 2, BAD_NUKE = 3, BAD_POWERUP_COUNT = 4}
#good ones
const speed_up_barrier_modifier = 1
const speed_up_barrier_time = 20.0

const enemy_ship_slowdown_modifier = 10.0
const enemy_ship_slowdown_time = 20.0

const strengthen_barrier_modifier = 10
const strengthen_barrier_time = 20.0

const add_life_time = 20.0

#bad ones
const slow_down_barrier_modifier = 1
const slow_down_barrier_time = 20.0

const enemy_ship_speedup_modifier = 20.0
const enemy_ship_speedup_time = 20.0

const weaken_barrier_modifier = 20.0
const weaken_barrier_time = 20.0

#on load variables
var center_location
var current_lives
var current_paint_level

func _ready():
    center_location = Vector2(get_viewport().size.x / 2.0, get_viewport().size.y / 2.0)
    reinit_variables()
    pass

func _process(delta):
    session_timer += delta

    update_ball_speed()
    update_ball_spawn_rate()
    update_score()

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

    pass

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
        get_node("/root/ScoreTracker").add_score(score_time_addition)

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
    get_node("/root/ScoreTracker").save_score()
    get_node("/root/ScoreTracker").reset_score()
    reinit_variables()
    session_timer = 0.0
    get_tree().reload_current_scene()

func remove_life():
    if current_lives > 0:
        current_lives -= 1
        current_paint_level = initial_paint
    else:
        restart_game()

func add_paint():
    current_paint_level += paint_score_modifier

func substract_paint():
    if current_paint_level > 0:
        current_paint_level -= 1
    