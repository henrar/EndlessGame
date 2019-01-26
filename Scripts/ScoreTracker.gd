extends Node

var current_score
var high_score

func _ready(): 
    current_score = 0
    load_score()

func _notification(what):
    if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
        save_score()
        get_tree().quit()

func save_score():
    var save_dict = {
        "high_score" : high_score
    }

    var save_game_file = File.new()
    save_game_file.open("user://save.save", File.WRITE)

    save_game_file.store_line(to_json(save_dict))

    save_game_file.close()

func load_score():
    var save_game_file = File.new()

    if not save_game_file.file_exists("user://save.save"):
        high_score = 0

    save_game_file.open("user://save.save", File.READ)
    var current_line = parse_json(save_game_file.get_line())

    if current_line == null:
        high_score = 0
    else:
        print(current_line["high_score"])
        high_score = current_line["high_score"]
        var new_paint_amount = get_node("/root/SceneVariables").initial_paint

        var crossed_threshold = high_score / get_node("/root/SceneVariables").high_score_threshold

        for i in range(crossed_threshold):
            new_paint_amount += get_node("/root/SceneVariables").paint_score_modifier

        get_node("/root/SceneVariables").initial_paint = new_paint_amount

    save_game_file.close()

func reset_score():
    current_score = 0

func add_score(score):
    current_score += score
    if current_score % get_node("/root/SceneVariables").high_score_threshold == 0:
        get_node("/root/SceneVariables").add_paint()

    if current_score > high_score:
        high_score = current_score
    
