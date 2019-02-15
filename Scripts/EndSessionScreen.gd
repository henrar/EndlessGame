extends Node2D

var play_again_button
var upgrades_button
var main_menu_button
var highscore_notification_sprite

func _ready():
    play_again_button = get_tree().get_root().get_node("EndSessionScreen/PlayAgainButton")
    upgrades_button = get_tree().get_root().get_node("EndSessionScreen/UpgradesButton")
    main_menu_button = get_tree().get_root().get_node("EndSessionScreen/MainMenuButton")

    highscore_notification_sprite = get_tree().get_root().get_node("EndSessionScreen/HighscoreNotification")
    if get_node("/root/ScoreTracker").new_high_score_achieved:
        highscore_notification_sprite.show()
    else:
        highscore_notification_sprite.hide()

func _process(delta):
    if play_again_button.pressed:
        get_tree().change_scene("res://Scenes/Game.tscn")

    if upgrades_button.pressed:
        get_tree().change_scene("res://Scenes/UpgradeMenu.tscn")

    if main_menu_button.pressed:
        get_tree().change_scene("res://Scenes/MainMenu.tscn")
        