extends Node

var green_ball_spawn_timer
var red_ball_spawn_timer = []
var gold_ball_spawn_timer
var scene_instance
var GreenBall
var RedBall
var GoldBall

func _ready():
    green_ball_spawn_timer = Timer.new()
    green_ball_spawn_timer.one_shot = false
    green_ball_spawn_timer.wait_time = get_node("/root/SceneVariables").green_ball_spawn_interval
    green_ball_spawn_timer.connect("timeout",self,"spawn_green_ball") 
    green_ball_spawn_timer.start()
    add_child(green_ball_spawn_timer)

    for i in range(0, get_node("/root/SceneVariables").RedBallTypes.SHIP_TYPE_COUNT):
        red_ball_spawn_timer.append(Timer.new())
        red_ball_spawn_timer[i].one_shot = false
        red_ball_spawn_timer[i].wait_time = get_node("/root/SceneVariables").red_ball_spawn_interval[i]
        red_ball_spawn_timer[i].connect("timeout",self,"spawn_red_ball", [i]) 
        red_ball_spawn_timer[i].start()
        add_child(red_ball_spawn_timer[i])
        
    gold_ball_spawn_timer = Timer.new()
    gold_ball_spawn_timer.one_shot = false
    gold_ball_spawn_timer.wait_time = get_node("/root/SceneVariables").gold_ball_spawn_interval
    gold_ball_spawn_timer.connect("timeout",self,"spawn_gold_ball") 
    gold_ball_spawn_timer.start()
    add_child(gold_ball_spawn_timer)    

    scene_instance = get_tree().get_root().get_node("World")
    GreenBall = load("res://Scripts/GreenBall.gd")
    RedBall = load("res://Scripts/RedBall.gd")
    GoldBall = load("res://Scripts/GoldBall.gd")
    
    randomize()

func _process(delta):
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

func spawn_green_ball():
    for i in range(get_node("/root/SceneVariables").green_ball_spawn_rate):
        var ball = GreenBall.new()
        ball.position = get_random_spawn_position()
        scene_instance.add_child(ball)

func spawn_red_ball(type):
    for i in range(get_node("/root/SceneVariables").red_ball_spawn_rate[type]):
        var ball = RedBall.new()
        ball.position = get_random_spawn_position()
        ball.ship_type = type
        scene_instance.add_child(ball)

func spawn_gold_ball():
    for i in range(get_node("/root/SceneVariables").gold_ball_spawn_rate):
        var ball = GoldBall.new()
        ball.position = get_random_spawn_position()
        scene_instance.add_child(ball)

