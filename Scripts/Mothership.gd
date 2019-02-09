extends KinematicBody2D

func _ready():
    position = get_node("/root/SceneVariables").center_location
    pass

#func _process(delta):
#    # Called every frame. Delta is time since last frame.
#    # Update game logic here.
#    pass
