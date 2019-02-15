extends Node2D

var start_button
var main_menu_button

func _ready():
    start_button = get_tree().get_root().get_node("UpgradeMenu/StartButton")
    main_menu_button = get_tree().get_root().get_node("UpgradeMenu/MainMenuButton")

func _process(delta):
    if start_button.pressed:
        get_tree().change_scene("res://Scenes/Game.tscn")

    if main_menu_button.pressed:
        get_tree().change_scene("res://Scenes/MainMenu.tscn")
        