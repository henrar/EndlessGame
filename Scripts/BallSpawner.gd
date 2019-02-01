extends Node

var timer
var scene_instance
var GreenBall
var RedBall

func _ready():
    timer = Timer.new()
    timer.one_shot = false
    timer.wait_time = 1.0
    timer.connect("timeout",self,"spawn_ball") 
    timer.start()
    add_child(timer)

    scene_instance = get_tree().get_root().get_node("World")
    GreenBall = load("res://Scripts/GreenBall.gd")
    RedBall = load("res://Scripts/RedBall.gd")
    
    randomize()

func _physics_process(delta):
    pass
    
func get_random_spawn_position():
    var spawn_position = Vector2()
    
    #TODO: write this function better
    var candidate_x1 = rand_range(-200, -100)
    var candidate_x2 = rand_range(2020, 2120)

    var candidate_y = rand_range(-100, 1180);

    spawn_position.y = candidate_y

    if randi() % 2:
        spawn_position.x = candidate_x1
    else:
        spawn_position.x = candidate_x2

    return spawn_position

func spawn_ball():
    for i in range(get_node("/root/SceneVariables").green_ball_spawn_rate):
        var ball = GreenBall.new()
        ball.position = get_random_spawn_position()
        scene_instance.add_child(ball)

    for i in range(get_node("/root/SceneVariables").red_ball_spawn_rate):
        var ball = RedBall.new()
        ball.position = get_random_spawn_position()
        scene_instance.add_child(ball)


