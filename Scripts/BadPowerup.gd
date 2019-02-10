extends Node2D

enum BadPowerupTypes { SLOW_DOWN_BARRIER = 0 , ENEMY_SHIP_SPEEDUP = 1, WEAKEN_BARRIER = 2, BAD_NUKE = 3, BAD_POWERUP_COUNT = 4}

var slow_down_barrier_texture = preload("res://Assets/powerups/Shield-Slower.png")
var enemy_ship_speedup_texture = preload("res://Assets/powerups/Enemy-Ship-Faster.png")
var weaken_barrier_texture = preload("res://Assets/powerups/Shield-Weaker.png")
var bad_nuke_texture = preload("res://Assets/powerups/Bad-Nuke.png")

var current_texture = Sprite.new()
var current_type

onready var scene_variables = get_node("/root/SceneVariables")

func _ready():
    pass

func _process():
    pass

func set_type(type):
    current_type = type

    if current_type == BadPowerupTypes.SLOW_DOWN_BARRIER:
        current_texture.texture = slow_down_barrier_texture
    elif current_type == BadPowerupTypes.ENEMY_SHIP_SPEEDUP:
        current_texture.texture = enemy_ship_speedup_texture
    elif current_type == BadPowerupTypes.WEAKEN_BARRIER:
        current_texture.texture = weaken_barrier_texture
    elif current_type == BadPowerupTypes.BAD_NUKE:
        current_texture.texture = bad_nuke_texture
    
    current_texture.scale = Vector2(0.1, 0.1)        
    add_child(current_texture)

func execute_effect():
    scene_variables.execute_bad_powerup(current_type)
