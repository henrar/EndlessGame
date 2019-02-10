extends Node

var loading_bar
var loading_timer = 0.0

func _ready():
    loading_bar = get_tree().get_root().get_node("LoadingScreen/LoadingBox/LoadingBar")
    loading_bar.scale = Vector2(0.0, 1.0)
    pass

func _process(delta):
    loading_timer += delta

    if fmod(loading_timer, 0.5) <= 0.02 && loading_bar.scale.x < 1.0:
        loading_bar.scale.x += 0.1
    
    if loading_bar.scale.x >= 1.0:
        get_tree().change_scene("res://Scenes/Game.tscn")

    pass
