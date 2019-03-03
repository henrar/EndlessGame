extends Node2D

var main_menu_button

var background_sprite

onready var scene_variables = get_node("/root/SceneVariables")
onready var audio_player = get_node("/root/AudioPlayer")

var stellar_shield_header
var stellar_shield_text

var project_lead_header
var project_lead_text

var programming_header
var programming_text

var assistant_header
var assistant_text

var art_header
var art_text

var music_header
var music_text

var sound_effect_header
var sound_effect_text

var disclaimer_text

func _ready():
    main_menu_button = get_tree().get_root().get_node("Credits/MainMenuButton")

    background_sprite = get_tree().get_root().get_node("Credits/Background")

    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

    main_menu_button.rect_scale *= scene_variables.scale_factor
    main_menu_button.rect_position *= scene_variables.scale_factor

    stellar_shield_header = get_tree().get_root().get_node("Credits/StellarShieldHeader")
    stellar_shield_text = get_tree().get_root().get_node("Credits/StellarShieldText")

    stellar_shield_header.rect_scale *= scene_variables.scale_factor
    stellar_shield_header.rect_position *= scene_variables.scale_factor

    stellar_shield_text.rect_scale *= scene_variables.scale_factor
    stellar_shield_text.rect_position *= scene_variables.scale_factor

    project_lead_header = get_tree().get_root().get_node("Credits/ProjectLeadHeader")
    project_lead_text = get_tree().get_root().get_node("Credits/ProjectLeadText")

    project_lead_header.rect_scale *= scene_variables.scale_factor
    project_lead_header.rect_position *= scene_variables.scale_factor

    project_lead_text.rect_scale *= scene_variables.scale_factor
    project_lead_text.rect_position *= scene_variables.scale_factor

    programming_header = get_tree().get_root().get_node("Credits/ProgrammingHeader")
    programming_text = get_tree().get_root().get_node("Credits/ProgrammingText")

    programming_header.rect_scale *= scene_variables.scale_factor
    programming_header.rect_position *= scene_variables.scale_factor

    programming_text.rect_scale *= scene_variables.scale_factor
    programming_text.rect_position *= scene_variables.scale_factor

    assistant_header = get_tree().get_root().get_node("Credits/AssistantDesignerHeader")
    assistant_text = get_tree().get_root().get_node("Credits/AssistantDesignerText")

    assistant_header.rect_scale *= scene_variables.scale_factor
    assistant_header.rect_position *= scene_variables.scale_factor

    assistant_text.rect_scale *= scene_variables.scale_factor
    assistant_text.rect_position *= scene_variables.scale_factor

    art_header = get_tree().get_root().get_node("Credits/ArtDirectorHeader")
    art_text = get_tree().get_root().get_node("Credits/ArtDirectorText")

    art_header.rect_scale *= scene_variables.scale_factor
    art_header.rect_position *= scene_variables.scale_factor

    art_text.rect_scale *= scene_variables.scale_factor
    art_text.rect_position *= scene_variables.scale_factor

    music_header = get_tree().get_root().get_node("Credits/MusicHeader")
    music_text = get_tree().get_root().get_node("Credits/MusicText")

    music_header.rect_scale *= scene_variables.scale_factor
    music_header.rect_position *= scene_variables.scale_factor

    music_text.rect_scale *= scene_variables.scale_factor
    music_text.rect_position *= scene_variables.scale_factor

    sound_effect_header = get_tree().get_root().get_node("Credits/SoundEffectsHeader")
    sound_effect_text = get_tree().get_root().get_node("Credits/SoundEffectText")

    sound_effect_header.rect_scale *= scene_variables.scale_factor
    sound_effect_header.rect_position *= scene_variables.scale_factor

    sound_effect_text.rect_scale *= scene_variables.scale_factor
    sound_effect_text.rect_position *= scene_variables.scale_factor

    disclaimer_text = get_tree().get_root().get_node("Credits/DisclaimerText")

    disclaimer_text.rect_scale *= scene_variables.scale_factor
    disclaimer_text.rect_position *= scene_variables.scale_factor

func _process(delta):
    if main_menu_button.pressed:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_CLICK)
        get_tree().change_scene("res://Scenes/MainMenu.tscn")

