extends CanvasLayer

var fps_text

var number_textures = []
var number_sprites = []

var plasma_ball

var barrier_speedup_sprite
var enemy_ship_slowdown_sprite
var strengthen_barrier_sprite
var slowdown_barrier_sprite
var enemy_ship_speedup_sprite
var weaken_barrier_sprite

var bar_textures = []
var barrier_speedup_textures = []
var enemy_ship_slowdown_textures = []
var strengthen_barrier_textures = []
var slowdown_barrier_textures = []
var enemy_ship_speedup_textures = []
var weaken_barrier_textures = []

onready var scene_variables = get_node("/root/SceneVariables")
onready var score_tracker = get_node("/root/ScoreTracker")

func _ready():
    plasma_ball = get_tree().get_root().get_node("GameWorld/HUD/Control/PlasmaBall") 

    fps_text = get_tree().get_root().get_node("GameWorld/HUD/Control/FPSCounter")

    bar_textures.append(preload("res://Assets/HUD/timer-alone-inactive.png"))
    bar_textures.append(preload("res://Assets/HUD/timer-alone-active.png"))

    barrier_speedup_sprite = get_tree().get_root().get_node("GameWorld/HUD/Control/BarrierSpeedUp") 
    enemy_ship_slowdown_sprite = get_tree().get_root().get_node("GameWorld/HUD/Control/EnemyShipSlowdown") 
    strengthen_barrier_sprite = get_tree().get_root().get_node("GameWorld/HUD/Control/StrengthenBarrier") 
    slowdown_barrier_sprite = get_tree().get_root().get_node("GameWorld/HUD/Control/SlowDownBarrier") 
    enemy_ship_speedup_sprite = get_tree().get_root().get_node("GameWorld/HUD/Control/SlowDownBarrier") 
    weaken_barrier_sprite = get_tree().get_root().get_node("GameWorld/HUD/Control/WeakenBarrier") 

    barrier_speedup_textures.append(preload("res://Assets/HUD/bonus-2a.png"))
    barrier_speedup_textures.append(preload("res://Assets/HUD/bonus-2.png"))

    enemy_ship_slowdown_textures.append(preload("res://Assets/HUD/bonus-5a.png"))
    enemy_ship_slowdown_textures.append(preload("res://Assets/HUD/bonus-5.png"))

    strengthen_barrier_textures.append(preload("res://Assets/HUD/bonus-1a.png"))
    strengthen_barrier_textures.append(preload("res://Assets/HUD/bonus-1.png"))

    slowdown_barrier_textures.append(preload("res://Assets/HUD/anus-2a.png"))
    slowdown_barrier_textures.append(preload("res://Assets/HUD/anus-2.png"))

    enemy_ship_speedup_textures.append(preload("res://Assets/HUD/anus-4a.png"))
    enemy_ship_speedup_textures.append(preload("res://Assets/HUD/anus-4.png"))

    weaken_barrier_textures.append(preload("res://Assets/HUD/anus-1a.png"))
    weaken_barrier_textures.append(preload("res://Assets/HUD/anus-1.png"))

    for i in range(10):
        number_textures.append(load("res://Assets/HUD/numbers_small/" + str(i) + ".png"))

    for i in range(6):
        number_sprites.append(get_tree().get_root().get_node("GameWorld/HUD/Control/Score" + str(i)))
        number_sprites[i].scale *= scene_variables.scale_factor
        number_sprites[i].global_position *= scene_variables.scale_factor

    plasma_ball.scale *= scene_variables.scale_factor
    plasma_ball.global_position *= scene_variables.scale_factor

    barrier_speedup_sprite.scale *= scene_variables.scale_factor
    barrier_speedup_sprite.global_position *= scene_variables.scale_factor
    enemy_ship_slowdown_sprite.scale *= scene_variables.scale_factor
    enemy_ship_slowdown_sprite.global_position *= scene_variables.scale_factor
    strengthen_barrier_sprite.scale *= scene_variables.scale_factor
    strengthen_barrier_sprite.global_position *= scene_variables.scale_factor
    slowdown_barrier_sprite.scale *= scene_variables.scale_factor
    slowdown_barrier_sprite.global_position *= scene_variables.scale_factor
    enemy_ship_speedup_sprite.scale *= scene_variables.scale_factor
    enemy_ship_speedup_sprite.global_position *= scene_variables.scale_factor
    weaken_barrier_sprite.scale *= scene_variables.scale_factor
    weaken_barrier_sprite.global_position *= scene_variables.scale_factor

func _process(delta):
    fps_text.text = str(Engine.get_frames_per_second())

    display_score()
    update_bar()
    update_powerups_display()

func display_score():
    var score = score_tracker.current_score

    if score > 999999:
        for i in range(6):
            number_sprites[i].texture = number_textures[9]
        return         

    var score_str = str(score)

    for i in range(score_str.length()):
        var number = int(score_str[score_str.length() - 1 - i])
        number_sprites[5 - i].texture = number_textures[number]

func update_bar():
    pass

func update_powerups_display():
    if scene_variables.speed_up_barrier_triggered:
        barrier_speedup_sprite.texture = barrier_speedup_textures[1]
        barrier_speedup_sprite.get_child(0).texture = bar_textures[1] 
        barrier_speedup_sprite.get_child(0).get_child(0).text = str(int(scene_variables.speed_up_barrier_time - (scene_variables.session_timer - scene_variables.speed_up_barrier_start_time)))
    else:
        barrier_speedup_sprite.texture = barrier_speedup_textures[0]
        barrier_speedup_sprite.get_child(0).texture = bar_textures[0] 
        barrier_speedup_sprite.get_child(0).get_child(0).text = "00"

    if scene_variables.enemy_ship_slowdown_triggered:
        enemy_ship_slowdown_sprite.texture = enemy_ship_slowdown_textures[1]
        enemy_ship_slowdown_sprite.get_child(0).texture = bar_textures[1] 
        enemy_ship_slowdown_sprite.get_child(0).get_child(0).text = str(int(scene_variables.enemy_ship_slowdown_time - (scene_variables.session_timer - scene_variables.enemy_ship_slowdown_start_time)))  
    else:
        enemy_ship_slowdown_sprite.texture = enemy_ship_slowdown_textures[0]
        enemy_ship_slowdown_sprite.get_child(0).texture = bar_textures[0] 
        enemy_ship_slowdown_sprite.get_child(0).get_child(0).text = "00"

    if scene_variables.strengthen_barrier_triggered:
        strengthen_barrier_sprite.texture = strengthen_barrier_textures[1]
        strengthen_barrier_sprite.get_child(0).texture = bar_textures[1] 
        strengthen_barrier_sprite.get_child(0).get_child(0).text = str(int(scene_variables.strengthen_barrier_time - (scene_variables.session_timer - scene_variables.strengthen_barrier_start_time)))    
    else:
        strengthen_barrier_sprite.texture = strengthen_barrier_textures[0]
        strengthen_barrier_sprite.get_child(0).texture = bar_textures[0] 
        strengthen_barrier_sprite.get_child(0).get_child(0).text = "00"

    if scene_variables.slow_down_barrier_triggered:
        slowdown_barrier_sprite.texture = slowdown_barrier_textures[1]
        slowdown_barrier_sprite.get_child(0).texture = bar_textures[1] 
        slowdown_barrier_sprite.get_child(0).get_child(0).text = str(int(scene_variables.slow_down_barrier_time - (scene_variables.session_timer - scene_variables.slow_down_barrier_start_time)))    
    else:
        slowdown_barrier_sprite.texture = slowdown_barrier_textures[0]
        slowdown_barrier_sprite.get_child(0).texture = bar_textures[0] 
        slowdown_barrier_sprite.get_child(0).get_child(0).text = "00"

    if scene_variables.enemy_ship_speedup_triggered:
        enemy_ship_speedup_sprite.texture = enemy_ship_speedup_textures[1]
        enemy_ship_speedup_sprite.get_child(0).texture = bar_textures[1] 
        enemy_ship_speedup_sprite.get_child(0).get_child(0).text = str(int(scene_variables.enemy_ship_speedup_time - (scene_variables.session_timer - scene_variables.enemy_ship_speedup_start_time)))    
    else:
        enemy_ship_speedup_sprite.texture = enemy_ship_speedup_textures[0]
        enemy_ship_speedup_sprite.get_child(0).texture = bar_textures[0] 
        enemy_ship_speedup_sprite.get_child(0).get_child(0).text = "00"

    if scene_variables.weaken_barrier_triggered:
        weaken_barrier_sprite.texture = weaken_barrier_textures[1]
        weaken_barrier_sprite.get_child(0).texture = bar_textures[1] 
        weaken_barrier_sprite.get_child(0).get_child(0).text = str(int(scene_variables.weaken_barrier_time - (scene_variables.session_timer - scene_variables.weaken_barrier_start_time)))    
    else:
        weaken_barrier_sprite.texture = weaken_barrier_textures[0]
        weaken_barrier_sprite.get_child(0).texture = bar_textures[0] 
        weaken_barrier_sprite.get_child(0).get_child(0).text = "00"
