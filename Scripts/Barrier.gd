extends KinematicBody2D

var radius
var thickness = 20
var center_coords = Vector2(0.0, 0.0)
var clicked_within_ring = false
var input_pos
var base_barrier_color = Color(1.0, 0.0, 0.0, 0.1)
var fill_barrier_color = Color(1.0, 0.0, 0.0, 1.0)
var hold_timer = 0.0

var angles = {}
var starting_angle = null
var angle_index_left
var angle_index_right

var current_barrier_strength
var current_barrier_speed

onready var scene_variables = get_node("/root/SceneVariables")

func _ready():
    position = scene_variables.center_location
    radius = Vector2(get_viewport().size.y * scene_variables.ring_radius_percentage_of_viewport / 2.0, 0.0)
    current_barrier_strength = scene_variables.barrier_strength
    current_barrier_speed = scene_variables.barrier_erect_speed
    clear_angles()

func _process(delta):
    current_barrier_speed = scene_variables.barrier_erect_speed

    if clicked_within_ring:
        hold_timer += delta
    else:
        hold_timer = 0.0

    if current_barrier_strength < 0 && clicked_within_ring:
        clicked_within_ring = false
        clear_angles()
        
    if hold_timer > 0.0 && fmod(hold_timer, 1.0) <= 0.01 && clicked_within_ring:
        var index = 0

        var barrier_paint_per_side = current_barrier_speed

        if barrier_paint_per_side >= scene_variables.current_paint_level:
            barrier_paint_per_side = barrier_paint_per_side / 2

        for i in range(1, barrier_paint_per_side + 1):
            if scene_variables.current_paint_level > 0:   
                var positive_i = i
                          
                if angle_index_right + positive_i >= 360:
                    angles[(angle_index_right + positive_i) - 360] = true
                else:
                    angles[angle_index_right + positive_i] = true
                
                index = positive_i   
                scene_variables.substract_paint()

        if angle_index_right + index >= 360:
            angle_index_right = (angle_index_right + index) - 360;
        else:
            angle_index_right = angle_index_right + index

        for i in range(1, barrier_paint_per_side + 1):
            if scene_variables.current_paint_level > 0:  
                var negative_i = -i   
                
                if angle_index_left + negative_i < 0:
                    negative_i = 360 + negative_i 

                angles[angle_index_left + negative_i] = true  
                index = negative_i    
                scene_variables.substract_paint()   

        angle_index_left = angle_index_left + index
    
    update()

func _input(event):
    if OS.get_name() == "Android" || OS.get_name() == "iOS":
        if event is InputEventScreenTouch:
            if event.pressed:
                handle_click(event)
            elif !event.pressed:
                handle_release(event)
    else:
        if event is InputEventMouseButton: 
            if event.pressed && event.button_index == BUTTON_LEFT:
                handle_click(event)
            elif !event.pressed && event.button_index == BUTTON_LEFT:
                handle_release(event)

        if event is InputEventMouseMotion:
            if clicked_within_ring:
                input_pos = convert_to_ring_relative_coords(event.position)
                if is_on_ring(input_pos):
                    pass    
  
func handle_click(event):
    if scene_variables.current_paint_level > 0:
        input_pos = convert_to_ring_relative_coords(event.position)
        clicked_within_ring = convert_to_ring_relative_coords(input_pos)
        starting_angle = int(floor(get_angle_between_position_and_ring_origin(input_pos)))
        angles[starting_angle] = true
        angle_index_left = starting_angle
        angle_index_right = starting_angle
        current_barrier_strength = scene_variables.barrier_strength   
    
func handle_release(event):
    input_pos = null
    clicked_within_ring = false
    clear_angles()

func convert_to_ring_relative_coords(position):
    return Vector2(position.x - scene_variables.center_location.x, scene_variables.center_location.y - position.y)                

func is_on_ring(position):
    return position.distance_to(center_coords) > (radius.x - thickness / 2.0) && position.distance_to(center_coords) < (radius.x + thickness / 2.0)
    
func is_inside_inner_circle(position):
    return position.distance_to(center_coords) < (radius.x - thickness / 2.0)

func get_angle_between_position_and_ring_origin(position):
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
    if angles[0]:
        color = fill_barrier_color
    else:
        color = base_barrier_color

    draw_line(line_origin, line_end, color, thick)

func _draw():
    draw_ring(center_coords, radius, base_barrier_color, 1, thickness)
    
func damage_barrier():
    if current_barrier_strength >= 0:
        current_barrier_strength -= 1