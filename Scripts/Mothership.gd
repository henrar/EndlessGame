extends KinematicBody2D

onready var scene_variables = get_node("/root/SceneVariables")

func _ready():
    position = get_node("/root/SceneVariables").center_location
    scale *= scene_variables.scale_factor

