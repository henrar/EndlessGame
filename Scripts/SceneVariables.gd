extends Node

#configuration
var initial_paint = 10
var ball_spawn_rate = 1 #per second
var barrier_erect_speed = 10 #per second
var barrier_strength = 10 
var ball_speed = 5
var ball_strength = 4
var high_score_threshold = 100
var points_per_ball = 10
var paint_score_modifier = 10 #increases initial paint when score reaches certain threshold

#on load variables
var center_location
var lives
var current_paint_level

func _ready():
	center_location = Vector2(get_viewport().size.x / 2.0, get_viewport().size.y / 2.0)
	print(center_location)
	
	reinit_variables()
	pass

func reinit_variables():
	lives = 3
	current_paint_level = initial_paint

func restart_game():
	get_node("/root/ScoreTracker").save_score()
	get_node("/root/ScoreTracker").reset_score()
	reinit_variables()
	get_tree().reload_current_scene()

func remove_life():
	if lives > 0:
		lives -= 1
		print("lives: ", lives)
	else:
		restart_game()

func add_paint():
	current_paint_level += paint_score_modifier
