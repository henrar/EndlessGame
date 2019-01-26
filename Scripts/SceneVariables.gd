extends Node

var initial_paint = 10
var ball_spawn_rate = 10 #per second
var barrier_erect_speed = 10 #per second
var barrier_strength = 10 
var ball_speed = 5
var ball_strength = 4
var high_score_threshold = 100
var points_per_ball = 10


var center_location

func _ready():
	center_location = Vector2(get_viewport().size.x / 2, get_viewport().size.y / 2)
	print(center_location)

	pass

