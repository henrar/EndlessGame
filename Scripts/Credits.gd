extends Node2D

var main_menu_button

var background_sprite

onready var scene_variables = get_node("/root/SceneVariables")
onready var audio_player = get_node("/root/AudioPlayer") 

func _ready():
    main_menu_button = get_tree().get_root().get_node("Credits/MainMenuButton")

    background_sprite = get_tree().get_root().get_node("Credits/Background")

    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

    main_menu_button.rect_scale *= scene_variables.scale_factor
    main_menu_button.rect_position *= scene_variables.scale_factor

func _process(delta):
    if main_menu_button.pressed:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_CLICK)
        get_tree().change_scene("res://Scenes/MainMenu.tscn")

