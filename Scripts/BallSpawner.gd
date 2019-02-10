extends Node

enum GoodPowerupTypes { SPEED_UP_BARRIER = 0, ENEMY_SHIP_SLOWDOWN = 1, STRENGTHEN_BARRIER = 2, ADD_LIFE = 3, GOOD_NUKE = 4, GOOD_POWERUP_COUNT = 5 }
enum BadPowerupTypes { SLOW_DOWN_BARRIER = 0 , ENEMY_SHIP_SPEEDUP = 1, WEAKEN_BARRIER = 2, BAD_NUKE = 3, BAD_POWERUP_COUNT = 4}

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
    GreenBall = preload("res://Scripts/GreenBall.gd")
    RedBall = preload("res://Scripts/RedBall.gd")
    GoldBall = preload("res://Scripts/GoldBall.gd")
    
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

        if get_node("/root/SceneVariables").add_life_powerup_drop:
            add_life_powerup_drop = false
            ball.set_powerup(GoodPowerupTypes.ADD_LIFE)

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

