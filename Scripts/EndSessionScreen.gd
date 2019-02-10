extends Node2D

var main_menu_button

func _ready():
    main_menu_button = get_tree().get_root().get_node("EndSessionScreen/MainMenuButton")

func _process(delta):
    if main_menu_button.pressed:
        get_tree().change_scene("res://Scenes/MainMenu.tscn")
        