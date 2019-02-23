extends Node2D

var start_button
var main_menu_button
var upgrade_window

var upgrade_sprites = []

var buy_buttons = []

var number_textures = []
var number_sprites = []

var upgrade_number_textures = []

var gp_sprites = []
var gp_number_sprites = []

var background_sprite
onready var scene_variables = get_node("/root/SceneVariables")
onready var upgrade_tracker = get_node("/root/UpgradeTracker")
onready var audio_player = get_node("/root/AudioPlayer")

var description_textures = []
var description_sprite

func _ready():
    upgrade_window = get_tree().get_root().get_node("UpgradeMenu/UpgradeWindow")
    start_button = get_tree().get_root().get_node("UpgradeMenu/StartButton")
    main_menu_button = get_tree().get_root().get_node("UpgradeMenu/MainMenuButton")
    background_sprite = get_tree().get_root().get_node("UpgradeMenu/Background")

    upgrade_sprites.append(get_tree().get_root().get_node("UpgradeMenu/SturdySprite"))
    upgrade_sprites.append(get_tree().get_root().get_node("UpgradeMenu/MachEffectSprite"))
    upgrade_sprites.append(get_tree().get_root().get_node("UpgradeMenu/ResourcefulSprite"))
    upgrade_sprites.append(get_tree().get_root().get_node("UpgradeMenu/LethalDefenceSprite"))

    for i in range(4):
        buy_buttons.append(get_tree().get_root().get_node("UpgradeMenu/BuyButton" + str(i+1)))
        buy_buttons[i].rect_scale *= scene_variables.scale_factor
        buy_buttons[i].rect_position *= scene_variables.scale_factor

    for i in range(10):
        number_textures.append(load("res://Assets/menu/numbers/" + str(i) + ".png"))
        upgrade_number_textures.append(load("res://Assets/menu/numbers_gp/cyferki_" + str(i) + ".png"))

    for i in range(3):
        number_sprites.append(get_tree().get_root().get_node("UpgradeMenu/NumberSprite" + str(i)))
        number_sprites[i].scale *= scene_variables.scale_factor
        number_sprites[i].global_position *= scene_variables.scale_factor

    for i in range(4):
        gp_sprites.append(get_tree().get_root().get_node("UpgradeMenu/GPSprite" + str(i+1)))
        gp_sprites[i].scale *= scene_variables.scale_factor 
        gp_sprites[i].global_position *= scene_variables.scale_factor

    for i in range(4 * 2):
        gp_number_sprites.append(get_tree().get_root().get_node("UpgradeMenu/GPNumber" + str(i)))
        gp_number_sprites[i].scale *= scene_variables.scale_factor 
        gp_number_sprites[i].global_position *= scene_variables.scale_factor
   
    description_sprite = get_tree().get_root().get_node("UpgradeMenu/Description")

    description_textures.append(preload("res://Assets/menu/upgrade_descriptions/sturdy.png"))
    description_textures.append(preload("res://Assets/menu/upgrade_descriptions/mach.png"))
    description_textures.append(preload("res://Assets/menu/upgrade_descriptions/resourceful.png"))
    description_textures.append(preload("res://Assets/menu/upgrade_descriptions/lethal.png"))

    display_upgrade_points()
    display_upgrade_prices()

    description_sprite.scale *= scene_variables.scale_factor
    description_sprite.global_position *= scene_variables.scale_factor
   
    for i in range(4):
        upgrade_sprites[i].rect_scale *= scene_variables.scale_factor
        upgrade_sprites[i].rect_position *= scene_variables.scale_factor

    upgrade_window.scale *= scene_variables.scale_factor
    upgrade_window.global_position *= scene_variables.scale_factor

    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor

    start_button.rect_scale *= scene_variables.scale_factor
    start_button.rect_position *= scene_variables.scale_factor
    main_menu_button.rect_scale *= scene_variables.scale_factor
    main_menu_button.rect_position *= scene_variables.scale_factor

    audio_player.play_music(audio_player.Music.MUSIC_UPGRADE)

func _process(delta):
    if start_button.pressed:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_CLICK)
        get_tree().change_scene("res://Scenes/Game.tscn")

    if main_menu_button.pressed:
        audio_player.play_sound_effect(audio_player.SoundEffect.SE_CLICK)
        get_tree().change_scene("res://Scenes/MainMenu.tscn")

    update_description_text()
    update_buy_upgrades()
    update_buy_button_visibility()

func update_buy_upgrades():
    for i in range(4):
        if buy_buttons[i].pressed && upgrade_tracker.upgrade_points > scene_variables.upgrade_cost[i]:
            upgrade_tracker.upgrade_points -= scene_variables.upgrade_cost[i]
            upgrade_tracker.current_upgrades[i] = true 
            upgrade_tracker.save_upgrades()   
            display_upgrade_points()

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

func display_upgrade_prices():
    for i in range(4):
        var price = scene_variables.upgrade_cost[i]

        if price > 99:
            gp_number_sprites[i] = upgrade_number_textures[9]
            gp_number_sprites[i + 1] = upgrade_number_textures[9]
            continue

        var price_str = str(price)
        
        for j in range(price_str.length()):
            var number = int(price_str[price_str.length() - 1 - j])
            gp_number_sprites[1 - j + i * 2].texture = upgrade_number_textures[number]

func update_buy_button_visibility():
    for i in range(4):
        if not upgrade_tracker.current_upgrades[i]:
            buy_buttons[i].show()
        else:
            buy_buttons[i].hide()

func update_description_text():
    for i in range(4):
        if upgrade_sprites[i].pressed:
            audio_player.play_sound_effect(audio_player.SoundEffect.SE_BUY_UPGRADE)
            description_sprite.texture = description_textures[i]
