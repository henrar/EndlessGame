extends Node2D

var start_button
var main_menu_button
var upgrade_window

var text_field

var sturdy_sprite
var mach_effect_sprite
var resourceful_sprite
var lethal_defence_sprite

var buy_button_sturdy
var buy_button_mach_effect
var buy_button_resourceful
var buy_button_lethal_defence

var number_textures = []
var number_sprites = []

var background_sprite
onready var scene_variables = get_node("/root/SceneVariables")
onready var upgrade_tracker = get_node("/root/UpgradeTracker")

func _ready():
    upgrade_window = get_tree().get_root().get_node("UpgradeMenu/UpgradeWindow")
    start_button = get_tree().get_root().get_node("UpgradeMenu/StartButton")
    main_menu_button = get_tree().get_root().get_node("UpgradeMenu/MainMenuButton")
    background_sprite = get_tree().get_root().get_node("UpgradeMenu/Background")

    text_field = get_tree().get_root().get_node("UpgradeMenu/DescriptionText")

    sturdy_sprite = get_tree().get_root().get_node("UpgradeMenu/SturdySprite")
    mach_effect_sprite = get_tree().get_root().get_node("UpgradeMenu/MachEffectSprite")
    resourceful_sprite = get_tree().get_root().get_node("UpgradeMenu/ResourcefulSprite")
    lethal_defence_sprite = get_tree().get_root().get_node("UpgradeMenu/LethalDefenceSprite")

    buy_button_sturdy = get_tree().get_root().get_node("UpgradeMenu/BuyButton1")
    buy_button_mach_effect = get_tree().get_root().get_node("UpgradeMenu/BuyButton2")
    buy_button_resourceful = get_tree().get_root().get_node("UpgradeMenu/BuyButton3")
    buy_button_lethal_defence = get_tree().get_root().get_node("UpgradeMenu/BuyButton4")

    for i in range(10):
        number_textures.append(load("res://Assets/menu/numbers/" + str(i) + ".png"))

    for i in range(3):
        number_sprites.append(get_tree().get_root().get_node("UpgradeMenu/NumberSprite" + str(i)))
        number_sprites[i].scale *= scene_variables.scale_factor
        number_sprites[i].global_position *= scene_variables.scale_factor

    display_upgrade_points()

    text_field.rect_scale *= scene_variables.scale_factor
    text_field.rect_position *= scene_variables.scale_factor

    sturdy_sprite.scale *= scene_variables.scale_factor
    sturdy_sprite.global_position *= scene_variables.scale_factor
    mach_effect_sprite.scale *= scene_variables.scale_factor
    mach_effect_sprite.global_position *= scene_variables.scale_factor
    resourceful_sprite.scale *= scene_variables.scale_factor
    resourceful_sprite.global_position *= scene_variables.scale_factor
    lethal_defence_sprite.scale *= scene_variables.scale_factor
    lethal_defence_sprite.global_position *= scene_variables.scale_factor

    buy_button_sturdy.rect_scale *= scene_variables.scale_factor
    buy_button_sturdy.rect_position *= scene_variables.scale_factor
    buy_button_mach_effect.rect_scale *= scene_variables.scale_factor
    buy_button_mach_effect.rect_position *= scene_variables.scale_factor
    buy_button_resourceful.rect_scale *= scene_variables.scale_factor
    buy_button_resourceful.rect_position *= scene_variables.scale_factor
    buy_button_lethal_defence.rect_scale *= scene_variables.scale_factor
    buy_button_lethal_defence.rect_position *= scene_variables.scale_factor

    upgrade_window.scale *= scene_variables.scale_factor
    upgrade_window.global_position *= scene_variables.scale_factor

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

    update_buy_upgrades()

func update_buy_upgrades():
    if buy_button_sturdy.pressed:
        pass
    
    if buy_button_mach_effect.pressed:
        pass

    if buy_button_resourceful.pressed:
        pass

    if buy_button_lethal_defence.pressed:
        pass     

func display_upgrade_points():
    var points = upgrade_tracker.upgrade_points

    if points > 999:
        for i in range(3):
            number_sprites[i] = number_textures[9]
        return

    var points_str = str(points)

    for i in range(points_str.length()):
        var number = int(points_str[points_str.length() - 1 - i])
        number_sprites[2 - i].texture = number_textures[number]