extends Node

onready var scene_variables = get_node("/root/SceneVariables")
onready var score_tracker = get_node("/root/ScoreTracker")

func _ready():
    scene_variables.session_timer = 0.0
    scene_variables.reinit_variables()
    score_tracker.reset_score()