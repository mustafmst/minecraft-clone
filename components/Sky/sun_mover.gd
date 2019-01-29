extends Position3D

var speed = 0.1
const change_color_range = PI / 8

onready var sun = get_node("sun")


func _process(delta):

    var new_sun_rotation = get_rotation()
    new_sun_rotation.z += (PI * speed) * delta

    if(new_sun_rotation.z > 2 * PI):
        new_sun_rotation.z -= 2 * PI
    elif(new_sun_rotation.z < 0):
        new_sun_rotation.z += 2 * PI

    set_rotation(new_sun_rotation)
