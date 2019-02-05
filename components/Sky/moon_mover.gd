extends Position3D

var speed = 0.001388889 # 1h in game world = 1 minute in real
#var speed = 0.2 # test speed

onready var moon = get_node("moon")

func _ready():
    Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta):

    if Input.is_action_just_pressed("ui_cancel"):
        if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
            Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
        else:
            Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

    var new_moon_rotation = get_rotation()
    new_moon_rotation.z -= (PI * speed) * delta

    if(new_moon_rotation.z > 2 * PI):
        new_moon_rotation.z -= 2 * PI
    elif(new_moon_rotation.z < 0):
        new_moon_rotation.z += 2 * PI

    if ((new_moon_rotation.z > 0) && (new_moon_rotation.z < PI)):
        moon.visible = true
    else:
        moon.visible = false

    set_rotation(new_moon_rotation)
