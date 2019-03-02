extends Node

onready var scene_variables = get_node("/root/SceneVariables")
onready var score_tracker = get_node("/root/ScoreTracker")
onready var audio_player = get_node("/root/AudioPlayer")
onready var upgrade_tracker = get_node("/root/UpgradeTracker")

func _ready():
    scene_variables.session_timer = 0.0
    scene_variables.reinit_variables()
    score_tracker.reset_score()
    score_tracker.load_score()

    audio_player.play_music(audio_player.Music.MUSIC_INGAME)

    upgrade_tracker.execute_upgrades()

    scene_variables.init_score_timer()

