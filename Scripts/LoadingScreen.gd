extends Node

var loading_box
var loading_bar
var loading_timer = 0.0

var title_sprite
var background_sprite

onready var scene_variables = get_node("/root/SceneVariables")
onready var score_tracker = get_node("/root/ScoreTracker")

func _ready():
    loading_box = get_tree().get_root().get_node("LoadingScreen/LoadingBox")
    loading_bar = get_tree().get_root().get_node("LoadingScreen/LoadingBox/LoadingBar")
    loading_bar.scale = Vector2(0.0, 1.0 * scene_variables.scale_factor.y)

    title_sprite = get_tree().get_root().get_node("LoadingScreen/Title")
    background_sprite = get_tree().get_root().get_node("LoadingScreen/Background")

    loading_box.scale *= scene_variables.scale_factor
    loading_box.global_position *= scene_variables.scale_factor

    title_sprite.scale *= scene_variables.scale_factor
    title_sprite.global_position *= scene_variables.scale_factor
    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

func _process(delta):
    loading_timer += delta

    if fmod(loading_timer, 0.4) <= 0.02 && loading_bar.scale.x < 1.0:
        loading_bar.scale.x += 0.1

    if loading_bar.scale.x >= 1.0:
        score_tracker.reset_score()
        get_tree().change_scene("res://Scenes/Game.tscn")


