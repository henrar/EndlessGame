extends Node2D

var play_again_button
var upgrades_button
var main_menu_button
var highscore_notification_sprite

var number_textures = []
var number_sprites = []

var background_sprite

onready var scene_variables = get_node("/root/SceneVariables")
onready var audio_player = get_node("/root/AudioPlayer") 

func _ready():
    play_again_button = get_tree().get_root().get_node("EndSessionScreen/PlayAgainButton")
    upgrades_button = get_tree().get_root().get_node("EndSessionScreen/UpgradesButton")
    main_menu_button = get_tree().get_root().get_node("EndSessionScreen/MainMenuButton")

    background_sprite = get_tree().get_root().get_node("EndSessionScreen/Background")

    highscore_notification_sprite = get_tree().get_root().get_node("EndSessionScreen/HighscoreNotification")
    if get_node("/root/ScoreTracker").new_high_score_achieved:
        highscore_notification_sprite.show()
    else:
        highscore_notification_sprite.hide()

    for i in range(10):
        number_textures.append(load("res://Assets/menu/numbers/" + str(i) + ".png"))
        number_sprites.append(get_tree().get_root().get_node("EndSessionScreen/HighScore" + str(i)))

    display_score()

    play_again_button.rect_scale *= scene_variables.scale_factor
    play_again_button.rect_position *= scene_variables.scale_factor
    upgrades_button.rect_scale *= scene_variables.scale_factor
    upgrades_button.rect_position *= scene_variables.scale_factor
    main_menu_button.rect_scale *= scene_variables.scale_factor
    main_menu_button.rect_position *= scene_variables.scale_factor

    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

    highscore_notification_sprite.scale *= scene_variables.scale_factor
    highscore_notification_sprite.global_position *= scene_variables.scale_factor

    for i in range(10):
        number_sprites[i].scale *= scene_variables.scale_factor
        number_sprites[i].global_position *= scene_variables.scale_factor

    audio_player.play_music(audio_player.Music.MUSIC_GAME_OVER)

func _process(delta):
    if play_again_button.pressed:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_CLICK)
        get_tree().change_scene("res://Scenes/Game.tscn")

    if upgrades_button.pressed:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_CLICK)
        get_tree().change_scene("res://Scenes/UpgradeMenu.tscn")

    if main_menu_button.pressed:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_CLICK)
        get_tree().change_scene("res://Scenes/MainMenu.tscn")

func display_score():
    var score = get_node("/root/ScoreTracker").current_score

    var score_str = str(score)

    for i in range(score_str.length()):
        var number = int(score_str[score_str.length() - 1 - i])
        number_sprites[9 - i].texture = number_textures[number]
    
