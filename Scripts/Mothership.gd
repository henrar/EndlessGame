extends KinematicBody2D

onready var scene_variables = get_node("/root/SceneVariables")

var textures = []

func _ready():
    position = scene_variables.center_location

    textures.append(preload("res://Assets/ships/mothership/Mothership_001_3.png"))
    textures.append(preload("res://Assets/ships/mothership/Mothership_001_2.png"))
    textures.append(preload("res://Assets/ships/mothership/Mothership_001_1.png"))
    textures.append(preload("res://Assets/ships/mothership/Mothership_001.png"))

    set_sprite_based_on_life()

    scale *= scene_variables.scale_factor

func set_sprite_based_on_life():
    var index = scene_variables.current_lives

    if index < 0:
        index = 0
    elif index > 3:
        index = 3

    var current_sprite = get_tree().get_root().get_node("GameWorld/Mothership/MothershipSprite")
    current_sprite.texture = textures[index]
