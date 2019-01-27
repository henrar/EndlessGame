extends KinematicBody2D

var radius
var thickness = 20
var center_coords = Vector2(0.0, 0.0)
var clicked_within_ring = false
var input_pos
var base_barrier_color = Color(1.0, 0.0, 0.0, 0.2)
var fill_barrier_color = Color(1.0, 0.0, 0.0, 1.0)
var hold_timer = 0.0

var angles = {}
var starting_angle = null

func _ready():
    position = get_node("/root/SceneVariables").center_location
    radius = Vector2(get_viewport().size.y * get_node("/root/SceneVariables").ring_radius_percentage_of_viewport / 2.0, 0.0)
    clear_angles()

func _physics_process(delta):
    if clicked_within_ring:
        hold_timer += delta
    else:
        hold_timer = 0.0
        
    if hold_timer > 0.0 && fmod(hold_timer, 1.0) <= 0.01:
        if get_node("/root/SceneVariables").current_paint_level > 0:
            for i in range(1, get_node("/root/SceneVariables").barrier_erect_speed):
                var negative_i = -i
                var positive_i = i
                
                if starting_angle + negative_i < 0:
                    negative_i = 360 + negative_i 
                    
                if starting_angle + positive_i > 360:
                    positive_i = 0 + positive_i
                              
                angles[starting_angle + negative_i] = true    
                angles[starting_angle + positive_i] = true         
    
    update()

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
                starting_angle = int(get_angle_between_click_and_ring_origin(input_pos))
                angles[starting_angle] = true
            elif !event.pressed && event.button_index == BUTTON_LEFT:
                input_pos = null
                clicked_within_ring = false
                clear_angles()

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
 
func clear_angles():
    starting_angle = null
    for i in range(360):
        angles[i] = false

func draw_ring(circle_center, circle_radius, color, resolution, thick):
    var draw_counter = 0
    var line_origin = Vector2()
    var line_end = Vector2()
    line_origin = circle_radius + circle_center
        
    while draw_counter < 360:
        line_end = circle_radius.rotated(deg2rad(draw_counter)) + circle_center
        
        if angles != null && angles[draw_counter]:
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
    