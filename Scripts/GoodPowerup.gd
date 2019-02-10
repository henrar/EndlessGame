extends Node2D

enum GoodPowerupTypes { SPEED_UP_BARRIER = 0, ENEMY_SHIP_SLOWDOWN = 1, STRENGTHEN_BARRIER = 2, ADD_LIFE = 3, GOOD_NUKE = 4, GOOD_POWERUP_COUNT = 5 }

var speed_up_barrier_texture = preload("res://Assets/powerups/Shield-Faster.png")
var enemy_ship_slowdown_texture = preload("res://Assets/powerups/Enemy-Ship-Slower.png")
var strengthen_barrier_texture = preload("res://Assets/powerups/Shield-Stronger.png")
var add_life_texture = preload("res://Assets/powerups/Life.png")
var good_nuke_texture = preload("res://Assets/powerups/Good-Nuke.png")

var current_texture = Sprite.new()
var current_type

func _ready():
    pass

func _process():
    pass

func set_type(type):
    current_type = type

    if current_type == GoodPowerupTypes.SPEED_UP_BARRIER:
        current_texture.texture = speed_up_barrier_texture
    elif current_type == GoodPowerupTypes.ENEMY_SHIP_SLOWDOWN:
        current_texture.texture = enemy_ship_slowdown_texture
    elif current_type == GoodPowerupTypes.STRENGTHEN_BARRIER:
        current_texture.texture = strengthen_barrier_texture
    elif current_type == GoodPowerupTypes.ADD_LIFE:
        current_texture.texture = add_life_texture
    elif current_type == GoodPowerupTypes.GOOD_NUKE:
        current_texture.texture = good_nuke_texture
    
    current_texture.scale = Vector2(0.1, 0.1)        
    add_child(current_texture)

func execute_effect():
    get_node("/root/SceneVariables").execute_good_powerup(current_type)
