extends Node2D

var start_button
var main_menu_button

var background_sprite
onready var scene_variables = get_node("/root/SceneVariables")

func _ready():
    start_button = get_tree().get_root().get_node("UpgradeMenu/StartButton")
    main_menu_button = get_tree().get_root().get_node("UpgradeMenu/MainMenuButton")

    background_sprite = get_tree().get_root().get_node("UpgradeMenu/Background")
    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

    start_button.rect_scale *= scene_variables.scale_factor
    start_button.rect_position *= scene_variables.scale_factor
    main_menu_button.rect_scale *= scene_variables.scale_factor
    main_menu_button.rect_position *= scene_variables.scale_factor

func _process(delta):
    if start_button.pressed:
        get_tree().change_scene("res://Scenes/Game.tscn")

    if main_menu_button.pressed:
        get_tree().change_scene("res://Scenes/MainMenu.tscn")
        