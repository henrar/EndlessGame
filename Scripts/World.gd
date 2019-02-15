extends Node

onready var scene_variables = get_node("/root/SceneVariables")

func ready():
    scene_variables.session_timer = 0.0
    scene_variables.reinit_variables()