extends Node

#configuration
var initial_paint = 10
var barrier_erect_speed = 10 #per second
var barrier_strength = 0 

var ball_spawn_rate = 1 
var ball_speed = 200
var ball_strength = 1
var points_per_ball = 10


var high_score_threshold = 100

var paint_score_modifier = 10 #increases initial paint when score reaches certain threshold

var collision_timer = 2.0
var ring_radius_percentage_of_viewport = 0.8

#on load variables
var center_location
var lives
var current_paint_level
var session_timer = 0.0

func _ready():
    center_location = Vector2(get_viewport().size.x / 2.0, get_viewport().size.y / 2.0)
    reinit_variables()
    pass

func _physics_process(delta):
    session_timer += delta

func reinit_variables():
    lives = 3
    current_paint_level = initial_paint

func restart_game():
    get_node("/root/ScoreTracker").save_score()
    get_node("/root/ScoreTracker").reset_score()
    reinit_variables()
    session_timer = 0.0
    get_tree().reload_current_scene()

func remove_life():
    if lives > 0:
        lives -= 1
        current_paint_level = initial_paint
    else:
        restart_game()

func add_paint():
    current_paint_level += paint_score_modifier

func substract_paint():
    if current_paint_level > 0:
        current_paint_level -= 1
    