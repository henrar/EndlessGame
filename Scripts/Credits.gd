extends Node2D

var background_sprite

func _ready():
    background_sprite = get_tree().get_root().get_node("MainMenu/Background")

    background_sprite.scale *= scene_variables.scale_factor
    background_sprite.global_position *= scene_variables.scale_factor
    