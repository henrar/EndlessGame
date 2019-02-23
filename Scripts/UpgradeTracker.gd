extends Node

var upgrade_points = 0

var current_upgrades = []

func _ready(): 
    for i in range(4):
        current_upgrades.append(false)

    load_upgrades()

func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        save_upgrades()
        get_tree().quit()

func add_upgrade_points():
    upgrade_points += 1

func save_upgrades():
    var save_dict = {
        "upgrade_points" : upgrade_points,
        #"sturdy" : current_upgrades[0],
        #"mach_effect" : current_upgrades[1],
        #"resourceful" : current_upgrades[2],
        #"lethal_defence" : current_upgrades[3]
    }

    var save_game_file = File.new()
    save_game_file.open("user://upgrade_points.save", File.WRITE)

    save_game_file.store_line(to_json(save_dict))

    save_game_file.close()

func load_upgrades():
    var save_game_file = File.new()

    if not save_game_file.file_exists("user://upgrade_points.save"):
        upgrade_points = 0
        return

    save_game_file.open("user://upgrade_points.save", File.READ)
    var current_line = parse_json(save_game_file.get_line())

    if current_line == null:
        upgrade_points = 0
    else:
        upgrade_points = current_line["upgrade_points"]
        #current_upgrades[0] = bool(current_line["sturdy"])
        #current_upgrades[1] = bool(current_line["mach_effect"])
        #current_upgrades[2] = bool(current_line["resourceful"])
        #current_upgrades[3] = bool(current_line["lethal_defence"])

    save_game_file.close()

