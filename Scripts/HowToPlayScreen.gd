extends Node2D

var main_menu_button

var how_to_play_sprite

var background_sprite

onready var scene_variables = get_node("/root/SceneVariables")

func _ready():
    main_menu_button = get_tree().get_root().get_node("HowToPlayScreen/MainMenuButton")
    how_to_play_sprite = get_tree().get_root().get_node("HowToPlayScreen/HowToPlaySprite")
    background_sprite = get_tree().get_root().get_node("HowToPlayScreen/Background")

    main_menu_button.rect_scale *= scene_variables.scale_factor
    main_menu_button.rect_position *= scene_variables.scale_factor

    how_to_play_sprite.scale *= scene_variables.scale_factor
    how_to_play_sprite.global_position *= scene_variables.scale_factor

    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

func _process(delta):
    if main_menu_button.pressed:
        get_tree().change_scene("res://Scenes/MainMenu.tscn")
        