extends KinematicBody2D

var radius
var thickness = 20
var center_coords = Vector2(0.0, 0.0)
var clicked_within_ring = false
var input_pos
var base_barrier_color = Color(1.0, 0.0, 0.0, 0.2)
var fill_barrier_color = Color(1.0, 0.0, 0.0, 1.0)

func _ready():
    position = get_node("/root/SceneVariables").center_location
    radius = Vector2(get_viewport().size.y * get_node("/root/SceneVariables").ring_radius_percentage_of_viewport / 2.0, 0.0)

func _physics_process(delta):
    update()
    pass

func _input(event):
    if OS.get_name() == "Android" || OS.get_name() == "iOS":
        if event is InputEventScreenTouch:
            if event.pressed:
                input_pos = convert_to_ring_relative_coords(event.position)
                clicked_within_ring = convert_to_ring_relative_coords(input_pos)
    else:
        if event is InputEventMouseButton: 
            if event.pressed && event.button_index == BUTTON_LEFT:
                input_pos = convert_to_ring_relative_coords(event.position)
                clicked_within_ring = convert_to_ring_relative_coords(input_pos)
            elif !event.pressed && event.button_index == BUTTON_LEFT:
                input_pos = null
                clicked_within_ring = false

        if event is InputEventMouseMotion:
            if clicked_within_ring:
                input_pos = convert_to_ring_relative_coords(event.position)
                if is_on_ring(input_pos):
                    pass    
                    
func convert_to_ring_relative_coords(position):
    return Vector2(position.x - get_node("/root/SceneVariables").center_location.x, get_node("/root/SceneVariables").center_location.y - position.y)                

func is_on_ring(position):
    return position.distance_to(center_coords) > (radius.x - thickness / 2.0) && position.distance_to(center_coords) < (radius.x + thickness / 2.0)
    
func is_inside_inner_circle(position):
    return position.distance_to(center_coords) < (radius.x - thickness / 2.0)

func get_angle_between_click_and_ring_origin(position):
    var ring_origin = center_coords + radius
    var angle = rad2deg(position.angle_to(ring_origin))
    if angle <= 180.0 && angle >= 0.0:
        return angle
    else:
        return angle + 360.0
 
func draw_ring(circle_center, circle_radius, color, resolution, thick):
    var draw_counter = 1
    var line_origin = Vector2()
    var line_end = Vector2()
    line_origin = circle_radius + circle_center

    var angle = null

    if input_pos && clicked_within_ring:
        angle = get_angle_between_click_and_ring_origin(input_pos)
        
    while draw_counter <= 360:
        line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
        
        if angle != null && draw_counter == int(angle):
            color = fill_barrier_color
        else:
            color = base_barrier_color
            
        draw_line(line_origin, line_end, color, thick)

        draw_counter += 1 / resolution
        line_origin = line_end

    line_end = circle_radius.rotated(deg2rad(360)) + circle_center
    draw_line(line_origin, line_end, color, thick)

func _draw():
    draw_ring(center_coords, radius, base_barrier_color, 1, thickness)
    