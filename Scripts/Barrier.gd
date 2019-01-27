extends KinematicBody2D

#for touch calculation
var outer_circle
var inner_circle
var radius

func _ready():
    position = get_node("/root/SceneVariables").center_location
    radius = Vector2(get_viewport().size.y * get_node("/root/SceneVariables").ring_radius_percentage_of_viewport / 2.0, 0)
    print(radius)

func _physics_process(delta):
    pass
    
func _input(event):
    if OS.get_name() == "Android" || OS.get_name() == "iOS":
        if event is InputEventScreenTouch:
            if event.pressed:
                var touch_pos = event.position
    else:
        if event is InputEventMouseButton:
            if event.pressed:
                var click_pos = event.position

func convert_to_ring_relative_coords(position):
    return Vector2(position.x - get_node("/root/SceneVariables").center_location.x, get_node("/root/SceneVariables").center_location.y - position.y)                

func is_on_ring(position):
    pass
    
func is_inside_inner_circle(position):
    pass    

func draw_empty_circle(circle_center, circle_radius, color, resolution, thick):
    var draw_counter = 1
    var line_origin = Vector2()
    var line_end = Vector2()
    line_origin = circle_radius + circle_center

    while draw_counter <= 360:
        line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
        draw_line(line_origin, line_end, color, thick)
        draw_counter += 1 / resolution
        line_origin = line_end

    line_end = circle_radius.rotated(deg2rad(360)) + circle_center
    draw_line(line_origin, line_end, color, thick)
	

func _draw():
    draw_empty_circle(Vector2(0, 0), radius, Color(1.0, 0.0, 0.0, 0.2), 1, 20)

