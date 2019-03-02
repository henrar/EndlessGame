extends Node

var upgrade_points = 0

var current_upgrades = []

onready var scene_variables = get_node("/root/SceneVariables")
onready var score_tracker = get_node("/root/ScoreTracker")

func _ready():
    get_tree().set_auto_accept_quit(false)
    get_tree().set_quit_on_go_back(false)
    reset_upgrades()
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
    }

    var save_game_file = File.new()
    save_game_file.open("user://upgrade_points.save", File.WRITE)

    save_game_file.store_line(to_json(save_dict))

    save_game_file.close()

func reset_upgrades():
    current_upgrades = []
    for i in range(4):
        current_upgrades.append(false)

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

    save_game_file.close()

func execute_upgrades():
    if current_upgrades[0]:
        score_tracker.add_score(500)

    if current_upgrades[1]:
        scene_variables.barrier_strength += 1

    if current_upgrades[2]:
        scene_variables.initial_paint += 30
