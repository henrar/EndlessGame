extends Node2D

var radius
const thickness = 20
const center_coords = Vector2(0.0, 0.0)
var line_origins = []
var line_ends = []

var clicked_within_ring = false
var input_pos
const base_barrier_color = Color(0.0, 0.0, 1.0, 0.1)
const fill_barrier_color = Color(0.0, 0.0, 0.1, 1.0)
var hold_timer = 0.0

var angles = {}
var starting_angle = null
var angle_index_left
var angle_index_right

var current_barrier_strength
var old_barrier_strength
var current_barrier_speed

onready var scene_variables = get_node("/root/SceneVariables")
#onready var barrier_sprite = get_tree().get_root().get_node("GameWorld/Barrier/BarrierSprite")

var barrier_sprite_textures = []
var barrier_sprites = []

var ring_hint_sprite = Sprite.new()

func _ready():
    position = scene_variables.center_location
    radius = Vector2(get_viewport().size.y * scene_variables.ring_radius_percentage_of_viewport / 2.0, 0.0)
    current_barrier_strength = scene_variables.barrier_strength
    old_barrier_strength = current_barrier_strength
    current_barrier_speed = scene_variables.barrier_erect_speed

    barrier_sprite_textures.append(preload("res://Assets/barrier/circle-1st-r.png"))
    barrier_sprite_textures.append(preload("res://Assets/barrier/circle-1st-y.png"))
    barrier_sprite_textures.append(preload("res://Assets/barrier/circle-1st.png"))

    ring_hint_sprite.texture = preload("res://Assets/barrier/ring.png")
    ring_hint_sprite.scale *= ((radius.x / (390.0 * scene_variables.scale_factor.x)) * scene_variables.scale_factor)
    ring_hint_sprite.set_name("RingHintSprite")
    add_child(ring_hint_sprite)

    clear_angles()
    precompute_ring()

    load_barrier_sprites_based_on_strength()

    #barrier_sprite_textures.append(preload("res://Assets/barrier/circle-fin-3.png"))
    #barrier_sprite_textures.append(preload("res://Assets/barrier/circle-fin-2.png"))
   # barrier_sprite_textures.append(preload("res://Assets/barrier/circle-fin-1.png"))

    #barrier_sprite.global_position = position
    #barrier_sprite.scale *= scene_variables.scale_factor
 #   barrier_sprite.hide()

func _process(delta):
    current_barrier_speed = scene_variables.barrier_erect_speed

    if old_barrier_strength != current_barrier_strength:
        load_barrier_sprites_based_on_strength()
    
    old_barrier_strength = current_barrier_strength

    if clicked_within_ring:
        hold_timer += delta
    else:
        hold_timer = 0.0

    if current_barrier_strength < 0 && clicked_within_ring:
        clicked_within_ring = false
        clear_angles()
        
    if hold_timer > 0.0 && fmod(hold_timer, 0.5) <= 0.01 && clicked_within_ring && scene_variables.current_paint_level > 0:
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
    
    update_sprites()

func update_sprites():
    for i in range(360):
        if angles[i]:
            barrier_sprites[i].show()
        else:
            barrier_sprites[i].hide()

    if angles[0]:
        barrier_sprites[0].show()
    else:
        barrier_sprites[0].hide()

func load_barrier_sprites_based_on_strength():
    var life = current_barrier_strength

    if life < 0:
        life = 0
    elif life > 2:
        life = 2

    for node in get_tree().get_root().get_node("GameWorld/Barrier").get_children():
        if node is Sprite && not node.name == "RingHintSprite":
            remove_child(node)
            node.queue_free()
    
    barrier_sprites = []

    for i in range(361):
        barrier_sprites.append(Sprite.new())
        barrier_sprites[i].texture = barrier_sprite_textures[life]
        barrier_sprites[i].position = line_origins[i]
        barrier_sprites[i].scale *= scene_variables.scale_factor * Vector2(1.0, 3.0)
        barrier_sprites[i].rotate(deg2rad(i))
        add_child(barrier_sprites[i])
        barrier_sprites[i].hide()

func _input(event):
    if OS.get_name() == "Android" || OS.get_name() == "iOS":
        if event is InputEventScreenTouch:
            if event.pressed:
                handle_click(event)
            elif !event.pressed:
                handle_release(event)
        if event is InputEventScreenDrag:
            if clicked_within_ring:
                input_pos = convert_to_ring_relative_coords(event.position)
                if is_on_ring(input_pos):
                    pass
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
        load_barrier_sprites_based_on_strength() 
    
func handle_release(event):
    input_pos = null
    clicked_within_ring = false
    hold_timer = 0.0
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

func precompute_ring():
    line_origins = []
    line_ends = []
    line_origins.append(radius + center_coords)

    var draw_counter = 0 
    while draw_counter < 360:
        line_ends.append(radius.rotated(deg2rad(draw_counter)) + center_coords)
        line_origins.append(line_ends[draw_counter])
        draw_counter += 1
    
    line_ends.append(radius.rotated(deg2rad(360)) + center_coords)

func draw_entire_ring():
    var draw_counter = 0 
    var color = base_barrier_color
        
    while draw_counter < 360:           
        draw_line(line_origins[draw_counter], line_ends[draw_counter], color, thickness)
        draw_counter += 1

    draw_line(line_origins[360], line_ends[360], color, thickness)

func draw_segments():
    var draw_counter = 0 
    var color = fill_barrier_color

    while draw_counter < 360:    
        if angles != null && angles[draw_counter]:
            draw_line(line_origins[draw_counter], line_ends[draw_counter], color, thickness)

        draw_counter += 1  
    
    if angles[0]:
        draw_line(line_origins[360], line_ends[360], color, thickness)
    
func damage_barrier():
    if current_barrier_strength >= 0:
        current_barrier_strength -= 1
        load_barrier_sprites_based_on_strength()