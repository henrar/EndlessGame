extends Node

var upgrade_points = 0

enum UpgradeTypes {UPGRADE_STURDY = 0, UPGRADE_MACH_EFFECT = 1, UPGRADE_RESOURCEFUL = 2, UPGRADE_LETHAL_DEFENCE = 3, UPGRADE_NUM = 4} 

var current_upgrades = {}

func _ready(): 
    load_points()

func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        save_points()
        get_tree().quit()

func add_upgrade_points():
    upgrade_points += 1

func save_points():
    var save_dict = {
        "upgrade_points" : upgrade_points
    }

    var save_game_file = File.new()
    save_game_file.open("user://upgrade_points.save", File.WRITE)

    save_game_file.store_line(to_json(save_dict))

    save_game_file.close()

func load_points():
    var save_game_file = File.new()

    if not save_game_file.file_exists("user://upgrade_points.save"):
        upgrade_points = 0

    save_game_file.open("user://upgrade_points.save", File.READ)
    var current_line = parse_json(save_game_file.get_line())

    if current_line == null:
        upgrade_points = 0
    else:
        upgrade_points = current_line["upgrade_points"]

    save_game_file.close()