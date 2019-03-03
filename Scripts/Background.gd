extends Sprite

var background_change_timer
var current_sprite_index = 0
var textures = []

var lower_alpha_timer
var increase_alpha_timer
var timer_counter = 0
const alpha_interval = 0.1

onready var scene_variables = get_node("/root/SceneVariables")

func _ready():
    for i in range(1, 9):
        var path = "res://Assets/Backgrounds/space_" + str(i) + ".png"
        textures.append(load(path))

    scale *= scene_variables.scale_factor

    randomize()

    replace_background()

    background_change_timer = Timer.new()
    background_change_timer.one_shot = false
    background_change_timer.wait_time = 60.0
    background_change_timer.connect("timeout",self,"replace_background_timer")
    background_change_timer.start()
    add_child(background_change_timer)

func replace_background():
    current_sprite_index = int(rand_range(0, 8))
    texture = textures[current_sprite_index]

func replace_background_timer():
    current_sprite_index = int(rand_range(0, 8))
    timer_counter = 0
    lower_alpha_timer = Timer.new()
    lower_alpha_timer.one_shot = false
    lower_alpha_timer.wait_time = alpha_interval
    lower_alpha_timer.connect("timeout",self,"lower_alpha")
    lower_alpha_timer.start()
    add_child(lower_alpha_timer)

func lower_alpha():
    modulate.a -= alpha_interval
    timer_counter += 1
    if timer_counter >= 10:
        lower_alpha_timer.stop()
        remove_child(lower_alpha_timer)
        texture = textures[current_sprite_index]
        timer_counter = 0
        increase_alpha_timer = Timer.new()
        increase_alpha_timer.one_shot = false
        increase_alpha_timer.wait_time = alpha_interval
        increase_alpha_timer.connect("timeout",self,"increase_alpha")
        increase_alpha_timer.start()
        add_child(increase_alpha_timer)

func increase_alpha():
    modulate.a += alpha_interval
    timer_counter += 1
    if timer_counter >= 10:
        increase_alpha_timer.stop()
        remove_child(increase_alpha_timer)
        timer_counter = 0
