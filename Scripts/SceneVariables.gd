extends Node

var session_timer = 0.0 #global session timer, do not touch this

#configuration
var initial_paint = 10 #how much paint we have at the beginning
var paint_score_modifier = 10 #increases initial paint when score reaches certain threshold
const ring_radius_percentage_of_viewport = 0.8 #size of the ring-barrier
const initial_lives = 2

#score configuration
const high_score_threshold = 100 #we get initial_paint + modifier * (previous_session_score % threshold)
const score_time_addition = 10
const score_time_addition_interval = 10.0

#barrier
var barrier_erect_speed = 10 #per second
var barrier_strength = 1 

#ball behavior
var collision_timer = 2.0 #how long will it take for a ship to return from a barrier bounce to normal state

#gold ball configuration
const gold_ball_base_speed = 200.0 #base speed, gold_ball_speed is the current one
var gold_ball_speed = green_ball_base_speed
var gold_ball_speed_modifier = 10.0
var gold_ball_speed_modifier_interval = 60.0

var gold_ball_spawn_rate = 1 #per interval
var gold_ball_spawn_interval = 1.0 #interval (seconds)
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

var green_ball_spawn_rate = 1 #per interval
var green_ball_spawn_interval = 1.0 #interval (seconds)
var green_ball_strength = 1
var green_ball_points_destroy = 10 #destroyed by barrier
var green_ball_reached_center = 10
var green_ball_hit_barrier = 10
var green_ball_collide = 10

#red ball configuration
const red_ball_base_speed = 200.0
var red_ball_speed = red_ball_base_speed
var red_ball_speed_modifier = 10.0
var red_ball_speed_modifier_interval = 60.0

var red_ball_spawn_rate = 1 
var red_ball_spawn_interval = 1.0
var red_ball_strength = 2
var red_ball_points_destroy = 10
var red_ball_reached_center = 10
var red_ball_hit_barrier = 10
var red_ball_collide = 10

#on load variables
var center_location
var current_lives
var current_paint_level

func _ready():
    center_location = Vector2(get_viewport().size.x / 2.0, get_viewport().size.y / 2.0)
    reinit_variables()
    pass

func _physics_process(delta):
    session_timer += delta

    if fmod(session_timer, green_ball_speed_modifier_interval) <= 0.01:
        green_ball_speed += green_ball_speed_modifier

    if fmod(session_timer, red_ball_speed_modifier_interval) <= 0.01:
        red_ball_speed += red_ball_speed_modifier   
        
    if fmod(session_timer, gold_ball_speed_modifier_interval) <= 0.01:
        gold_ball_speed += gold_ball_speed_modifier    

    if fmod(session_timer, score_time_addition_interval) <= 0.01:
        get_node("/root/ScoreTracker").add_score(score_time_addition)

func reinit_variables():
    current_lives = initial_lives
    current_paint_level = initial_paint
    green_ball_speed = green_ball_base_speed
    red_ball_speed = red_ball_base_speed
    gold_ball_speed = gold_ball_base_speed

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
    