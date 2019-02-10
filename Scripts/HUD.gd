extends CanvasLayer

var score_text
var high_score_text
var lives_text
var paint_text

onready var scene_variables = get_node("/root/SceneVariables")
onready var score_tracker = get_node("/root/ScoreTracker")

func _ready():
    score_text = get_tree().get_root().get_node("World/HUD/Control/ScoreCounter")
    high_score_text = get_tree().get_root().get_node("World/HUD/Control/HighScoreCounter")
    lives_text = get_tree().get_root().get_node("World/HUD/Control/LivesCounter")
    paint_text = get_tree().get_root().get_node("World/HUD/Control/PaintCounter")

func _process(delta):
    score_text.text = str(score_tracker.current_score)
    high_score_text.text = str(score_tracker.high_score)
    lives_text.text = str(scene_variables.current_lives)
    paint_text.text = str(scene_variables.current_paint_level)
