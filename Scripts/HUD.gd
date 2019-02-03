extends CanvasLayer

var score_text
var high_score_text
var lives_text
var paint_text

func _ready():
    score_text = get_tree().get_root().get_node("World/HUD/Control/ScoreCounter")
    high_score_text = get_tree().get_root().get_node("World/HUD/Control/HighScoreCounter")
    lives_text = get_tree().get_root().get_node("World/HUD/Control/LivesCounter")
    paint_text = get_tree().get_root().get_node("World/HUD/Control/PaintCounter")

func _physics_process(delta):
    score_text.text = str(get_node("/root/ScoreTracker").current_score)
    high_score_text.text = str(get_node("/root/ScoreTracker").high_score)
    lives_text.text = str(get_node("/root/SceneVariables").current_lives)
    paint_text.text = str(get_node("/root/SceneVariables").current_paint_level)
