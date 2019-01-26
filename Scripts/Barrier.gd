extends KinematicBody2D

#for touch calculation
var outer_circle
var inner_circle

func _ready():
    position = get_node("/root/SceneVariables").center_location
    print(position)

func _physics_process(delta):

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
    print(position)
    draw_empty_circle(Vector2(0, 0), Vector2(get_viewport().size.y * 0.2, get_viewport().size.y * 0.2), Color(1.0, 0.0, 0.0, 0.2), 1, 20)

