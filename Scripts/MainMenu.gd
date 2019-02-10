extends Node2D

var new_game_button
var upgrades_button
var how_to_play_button

func _ready():
    new_game_button = get_tree().get_root().get_node("MainMenu/NewGameButton")
    upgrades_button = get_tree().get_root().get_node("MainMenu/UpgradesButton")
    how_to_play_button = get_tree().get_root().get_node("MainMenu/HowToPlayButton")

func _process(delta):
    if new_game_button.pressed:
        get_tree().change_scene("res://Scenes/LoadingScreen.tscn")

    if upgrades_button.pressed:
        get_tree().change_scene("res://Scenes/UpgradeMenu.tscn")

    if how_to_play_button.pressed:
        get_tree().change_scene("res://Scenes/HowToPlayScreen.tscn")
