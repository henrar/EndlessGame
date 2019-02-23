extends Node2D

var new_game_button
var upgrades_button
var how_to_play_button

var title_sprite
var background_sprite

onready var scene_variables = get_node("/root/SceneVariables")
onready var audio_player = get_node("/root/AudioPlayer") 

func _ready():
    new_game_button = get_tree().get_root().get_node("MainMenu/NewGameButton")
    upgrades_button = get_tree().get_root().get_node("MainMenu/UpgradesButton")
    how_to_play_button = get_tree().get_root().get_node("MainMenu/HowToPlayButton")
    title_sprite = get_tree().get_root().get_node("MainMenu/Title")
    background_sprite = get_tree().get_root().get_node("MainMenu/Background")

    title_sprite.scale *= scene_variables.scale_factor
    title_sprite.global_position *= scene_variables.scale_factor
    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

    new_game_button.rect_scale *= scene_variables.scale_factor
    new_game_button.rect_position *= scene_variables.scale_factor
    upgrades_button.rect_scale *= scene_variables.scale_factor
    upgrades_button.rect_position *= scene_variables.scale_factor
    how_to_play_button.rect_scale *= scene_variables.scale_factor
    how_to_play_button.rect_position *= scene_variables.scale_factor

    audio_player.play_music(audio_player.Music.MUSIC_MENU)

func _process(delta):
    if new_game_button.pressed:
        get_tree().change_scene("res://Scenes/LoadingScreen.tscn")

    if upgrades_button.pressed:
        get_tree().change_scene("res://Scenes/UpgradeMenu.tscn")

    if how_to_play_button.pressed:
        get_tree().change_scene("res://Scenes/HowToPlayScreen.tscn")
