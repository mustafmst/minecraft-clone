extends Position3D

#var speed = 0.001388889 # 1h in game world = 1 minute in real
var speed = 0.2

onready var sun = get_node("sun")
onready var w_env = get_node("WorldEnvironment")


func _physics_process(delta):
    var new_sun_rotation = get_rotation()
    new_sun_rotation.z += (PI * speed) * delta

    if (new_sun_rotation.z > 2 * PI):
        new_sun_rotation.z -= 2 * PI
    elif (new_sun_rotation.z < 0):
        new_sun_rotation.z += 2 * PI

    if ((new_sun_rotation.z > 0) && (new_sun_rotation.z < PI)):
        w_env.environment.background_energy = 0.25
        sun.visible = false
    else:
        w_env.environment.background_energy = 0.75
        sun.visible = true

    set_rotation(new_sun_rotation)
