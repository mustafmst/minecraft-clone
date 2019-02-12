extends RayCast



func _ready():
    # Called when the node is added to the scene for the first time.
    # Initialization here
    pass


func _process(delta):
    if Input.is_action_just_pressed ('mouse_left'):
        use_tool('primary');
    elif Input.is_action_just_pressed ('mouse_right'):
        use_tool('secondary');

func use_tool(action):
    force_raycast_update()
    if is_colliding():
        var hit_body = get_collider();
        var action_name = 'do_' + action;
        if hit_body.has_method(action_name):
            hit_body.callv(action_name, [get_collision_normal(), get_collision_point()])
