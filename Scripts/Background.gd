extends Sprite

var background_change_timer
var current_sprite_index = 1
var textures = []

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
    background_change_timer.connect("timeout",self,"replace_background")
    background_change_timer.start()
    add_child(background_change_timer)

func replace_background():
    current_sprite_index = int(rand_range(0, 8))
    texture = textures[current_sprite_index]

