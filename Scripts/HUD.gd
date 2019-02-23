extends CanvasLayer

var score_text
var high_score_text
var lives_text
var paint_text
var fps_text

var number_textures = []
var number_sprites = []

onready var scene_variables = get_node("/root/SceneVariables")
onready var score_tracker = get_node("/root/ScoreTracker")

func _ready():
    fps_text = get_tree().get_root().get_node("GameWorld/HUD/Control/FPSCounter")

    for i in range(10):
        number_textures.append(load("res://Assets/HUD/numbers_small/" + str(i) + ".png"))

    for i in range(6):
        number_sprites.append(get_tree().get_root().get_node("GameWorld/HUD/Control/Score" + str(i)))

func _process(delta):
    fps_text.text = str(Engine.get_frames_per_second())

    display_score()

func display_score():
    var score = get_node("/root/ScoreTracker").current_score

    if score > 999999:
        for i in range(6):
            number_sprites[i].texture = number_textures[9]
        return
            

    var score_str = str(score)

    for i in range(score_str.length()):
        var number = int(score_str[score_str.length() - 1 - i])
        number_sprites[5 - i].texture = number_textures[number]

