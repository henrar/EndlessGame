extends Node

var loading_bar

func _ready():
    loading_bar = get_tree().get_root().get_node("LoadingScreen/LoadingBox/LoadingBar")
    loading_bar.scale = Vector2(0.1, 1.0)
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass
