extends Node2D

var play_again_button
var upgrades_button
var main_menu_button
var highscore_notification_sprite

var number_textures = []
var number_sprites = []

func _ready():
    play_again_button = get_tree().get_root().get_node("EndSessionScreen/PlayAgainButton")
    upgrades_button = get_tree().get_root().get_node("EndSessionScreen/UpgradesButton")
    main_menu_button = get_tree().get_root().get_node("EndSessionScreen/MainMenuButton")

    highscore_notification_sprite = get_tree().get_root().get_node("EndSessionScreen/HighscoreNotification")
    if get_node("/root/ScoreTracker").new_high_score_achieved:
        highscore_notification_sprite.show()
    else:
        highscore_notification_sprite.hide()

    for i in range(10):
        number_textures.append(load("res://Assets/menu/numbers/" + str(i) + ".png"))
        number_sprites.append(get_tree().get_root().get_node("EndSessionScreen/HighScore" + str(i)))

    display_high_score()

func _process(delta):
    if play_again_button.pressed:
        get_tree().change_scene("res://Scenes/Game.tscn")

    if upgrades_button.pressed:
        get_tree().change_scene("res://Scenes/UpgradeMenu.tscn")

    if main_menu_button.pressed:
        get_tree().change_scene("res://Scenes/MainMenu.tscn")

func display_high_score():
    var high_score = get_node("/root/ScoreTracker").high_score

    var high_score_str = str(high_score)

    for i in range(high_score_str.length()):
        var number = int(high_score_str[high_score_str.length() - 1 - i])
        number_sprites[9 - i].texture = number_textures[number]

