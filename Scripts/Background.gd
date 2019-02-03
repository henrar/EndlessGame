extends Sprite

var background_change_timer
var current_sprite_index = 1
var textures = []

func _ready():
    for i in range(1, 9):
        var path = "res://Assets/Backgrounds/space_" + str(i) + ".png"
        textures.append(load(path))
    
    texture = textures[0]

    background_change_timer = Timer.new()
    background_change_timer.one_shot = false
    background_change_timer.wait_time = 60.0
    background_change_timer.connect("timeout",self,"replace_background") 
    background_change_timer.start()
    add_child(background_change_timer)
    

func replace_background():
    current_sprite_index = int(rand_range(0, 9))      
    texture = textures[current_sprite_index]
    
